module Cache#(
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] a,
    input logic [2:0] func3,
    input logic we,
    input logic [DATA_WIDTH-1:0] wd,
    input logic [63:0] blockRd,
    input logic [6:0] op,
    output logic[DATA_WIDTH-1:0] readData,
    output logic hit

);

logic [90:0] cache_array [15:0][1:0]; //2-way set associative cache, 16 sets
// |            WAY 1              ||||            WAY 0              |
// | V  |  U |  TAG  |     DATA    |||| V  |  U |  TAG  |     DATA    |
// |[90]|[89]|[88:64]|[63:32][31:0]||||[90]|[89]|[88:64]|[63:32][31:0]|
// V = Valid bit, U = Use bit, DATA contains 2 words

// Tag       | Set    | Block Offset | Byte Offset |
// a[31:7]   | a[6:3] | a[2]         | a[1:0]      |

logic [3:0]             set;
logic                   way;
logic [1:0]             byteOffset;
logic                   blockOffset;
logic [7:0]             bytee;
logic [DATA_WIDTH-1:0]  word;
logic                   ldOrSt;


always_comb begin //load
    set = a[6:3];
    byteOffset = a[1:0];
    blockOffset = a[2];
    if ((op==7'b0000011) || (op==7'b0100011)) ldOrSt = 1;
    else ldOrSt = 0;

    //check for a hit in way 0 by seeing if V = 1 and comparing address to tag

    if ((cache_array[set][0][90]==1) && (a[31:7] == cache_array[set][0][88:64])) begin
        hit = 1; //read from cache
        way = 0;
        if(blockOffset)
            word = cache_array[set][way][63:32];
        else
            word = cache_array[set][way][31:0];
        cache_array[set][0][89] = 0;
        cache_array[set][1][89] = 1;
    end
    else if ((cache_array[set][1][90]==1) && (a[31:7] == cache_array[set][1][88:64])) begin
        hit = 1; //read from cache
        way = 1;
        if(blockOffset)
            word = cache_array[set][way][63:32];
        else
            word = cache_array[set][way][31:0];
        cache_array[set][0][89] = 1;
        cache_array[set][1][89] = 0;
    end
    else begin //miss
        hit = 0; //read from data memory
        if (cache_array[set][0][89]==0) begin
            way = 1;
        end
        else if (cache_array[set][1][89]==0) begin
            way = 0;
        end
    end

    if (hit) begin
        //determine byte in word
        case(byteOffset)
            2'b00: bytee = word[7:0];
            2'b01: bytee = word[15:8];
            2'b10: bytee = word[23:16];
            2'b11: bytee = word[31:24];
        endcase

        case(func3[2])
            1'b0: begin
                case(func3[1:0]) //sign extend
                    2'b00: readData = {{24{bytee[7]}}, bytee};
                    2'b01: readData = {{16{word[15]}}, word[15:0]};
                    2'b10: readData = word[31:0];
                    default: readData = word[31:0]; //added default case to get rid of caseincomplete warnings to aid debugging
                endcase 
            end
            1'b1: begin //zero extend
                case(func3[1:0])
                    2'b00: readData = {24'b0, bytee};
                    2'b01: readData = {16'b0, word[15:0]};
                    default: readData = word[31:0];
                endcase
            end 
        endcase
    end
end
 
always_ff @(posedge clk) begin //write to cache
    if (we & hit) begin //store instruction with hit
        case(func3[1:0])
            2'b00: begin //store byte
                case(blockOffset)
                    1'b0: begin
                        case(byteOffset)
                            2'b00: cache_array[set][way][7:0] <= wd[7:0];      //byte 0
                            2'b01: cache_array[set][way][15:8] <= wd[7:0];     //byte 1
                            2'b10: cache_array[set][way][23:16] <= wd[7:0];    //byte 2
                            2'b11: cache_array[set][way][31:24] <= wd[7:0];    //byte 3
                        endcase
                    end
                    1'b1: begin
                        case(byteOffset)
                            2'b00: cache_array[set][way][39:32] <= wd[7:0];    //byte 0
                            2'b01: cache_array[set][way][47:40] <= wd[7:0];    //byte 1
                            2'b10: cache_array[set][way][55:48] <= wd[7:0];    //byte 2
                            2'b11: cache_array[set][way][63:56] <= wd[7:0];    //byte 3
                        endcase
                    end
                endcase
            end
            2'b01: begin //store half
                if(blockOffset) begin
                    case(byteOffset[1])
                        1'b0: cache_array[set][way][15+32:0+32] <= wd[15:0];    //store half into byte 0 and 1                
                        1'b1: cache_array[set][way][31+32:16+32] <= wd[15:0];   //store half into byte 2 and 3
                    endcase      
                end
                else begin
                    case(byteOffset[1])
                        1'b0: cache_array[set][way][15:0] <= wd[15:0];    //store half into byte 0 and 1                
                        1'b1: cache_array[set][way][31:16] <= wd[15:0];   //store half into byte 2 and 3
                    endcase
                end
            end
            2'b10: begin //store word
                if(blockOffset)
                    cache_array[set][way][31+32:0+32] <= wd[31:0]; 
                else
                    cache_array[set][way][31:0] <= wd[31:0];    //store word starting at byte 0
            end
            default: begin
                cache_array[set][way][15+32:0+32] <= wd[15:0];              
                cache_array[set][way][31+32:16+32] <= wd[15:0];
            end 
        endcase 
    end

    if ((!hit) && ldOrSt) begin  //in case of miss, fetch the block from data memory
        cache_array[set][way][90] <= 1;                //set valid bit to 1
        cache_array[set][way][88:64] <= a[31:7];     //set tag 
        cache_array[set][way][63:0] <= blockRd;   //load block from data memory into cache

        if (we) begin  //after fetching the block from data memory, write to the block in case of store instruction
            case(func3[1:0])
                2'b00: begin //store byte
                    case(blockOffset)
                        1'b0: begin
                            case(byteOffset)
                                2'b00: cache_array[set][way][7:0] <= wd[7:0];      //byte 0
                                2'b01: cache_array[set][way][15:8] <= wd[7:0];     //byte 1
                                2'b10: cache_array[set][way][23:16] <= wd[7:0];    //byte 2
                                2'b11: cache_array[set][way][31:24] <= wd[7:0];    //byte 3
                            endcase
                        end
                        1'b1: begin
                            case(byteOffset)
                                2'b00: cache_array[set][way][39:32] <= wd[7:0];    //byte 0
                                2'b01: cache_array[set][way][47:40] <= wd[7:0];    //byte 1
                                2'b10: cache_array[set][way][55:48] <= wd[7:0];    //byte 2
                                2'b11: cache_array[set][way][63:56] <= wd[7:0];    //byte 3
                            endcase
                        end
                    endcase
                end
                2'b01: begin //store half
                    if(blockOffset) begin
                        case(byteOffset[1])
                            1'b0: cache_array[set][way][15+32:0+32] <= wd[15:0];    //store half into byte 0 and 1                
                            1'b1: cache_array[set][way][31+32:16+32] <= wd[15:0];   //store half into byte 2 and 3
                        endcase      
                    end
                    else begin
                        case(byteOffset[1])
                            1'b0: cache_array[set][way][15:0] <= wd[15:0];    //store half into byte 0 and 1                
                            1'b1: cache_array[set][way][31:16] <= wd[15:0];   //store half into byte 2 and 3
                        endcase
                    end
                end
                2'b10: begin //store word
                    if(blockOffset)
                        cache_array[set][way][31+32:0+32] <= wd[31:0]; 
                    else
                        cache_array[set][way][31:0] <= wd[31:0];    //store word starting at byte 0
                end
                default: begin
                    cache_array[set][way][15+32:0+32] <= wd[15:0];              
                    cache_array[set][way][31+32:16+32] <= wd[15:0];
                end 
            endcase 
        end
    end
end

endmodule
