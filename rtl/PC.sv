module PC#(parameter ROM_WIDTH=12)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic [ROM_WIDTH-1:0] PCNext,
    output logic [ROM_WIDTH-1:0] PC
);

always_ff @(posedge clk, posedge rst)begin 
    if(rst)
        PC<={ROM_WIDTH{1'b0}};
    else if (en)
        PC<=PCNext;
end

endmodule

