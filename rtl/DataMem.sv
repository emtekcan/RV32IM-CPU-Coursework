module DataMem#(
  parameter DATA_WIDTH = 32

)(
input logic clk,
input logic [DATA_WIDTH-1:0] a,
input logic [2:0] func3,
input logic we,
input logic [DATA_WIDTH-1:0] wd,
output logic[DATA_WIDTH-1:0] readData,
output logic[63:0] blockRd
);

logic [DATA_WIDTH-1:0] startAddress;
logic [7:0] ram_array [20'h1FFFF:0];//byte addressable up to where the data memory goes

initial begin
    $readmemh("sine.mem", ram_array, 20'h10000);
end;

assign startAddress = {a[31:3], 3'b000};
assign blockRd = {ram_array[startAddress+7], ram_array[startAddress+6], ram_array[startAddress+5], ram_array[startAddress+4],
ram_array[startAddress+3], ram_array[startAddress+2], ram_array[startAddress+1], ram_array[startAddress]};

//passing unaligned address 

always_comb //load
case(func3[2])
  1'b0:begin

    case(func3[1:0])
      2'b00: readData= {{24{ram_array[a][7]}},ram_array[a]};
      2'b01: readData= {{16{ram_array[a+1][7]}},ram_array[a+1], ram_array[a]};
      2'b10: readData= {ram_array[a+3], ram_array[a+2], ram_array[a+1], ram_array[a]};
      default: readData= {{24{ram_array[a][7]}},ram_array[a]};
    endcase 
  end
  1'b1:begin //zero extend
    case(func3[1:0])
    2'b00: readData = {24'b0, ram_array[a]};
    2'b01: readData = {16'b0, ram_array[a+1], ram_array[a]};
    default: readData = {24'b0, ram_array[a]};
    endcase
  end 
endcase


 
always_ff @(posedge clk) //store 
if(we)
case(func3[1:0])
          2'b00: ram_array[a] <= wd[7:0];
          2'b01: {ram_array[a+1], ram_array[a]} <= wd[15:0];
          2'b10: {ram_array[a+3], ram_array[a+2], ram_array[a+1], ram_array[a]} <= wd[31:0];
          default: ram_array[a] <= wd[7:0];

          //setting address to wd which it will write to 
//finish

endcase 
endmodule

