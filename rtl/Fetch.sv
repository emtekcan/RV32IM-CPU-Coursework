module Fetch #(
    parameter DATA_WIDTH=32,
    ROM_WIDTH=12
)(
    input logic clk,
    input logic rst,
    input logic [1:0] pcSelE,
    input logic [DATA_WIDTH-1:0] immExtE,
    input logic [DATA_WIDTH-1:0] dout1E,
    input logic [ROM_WIDTH-1:0] pcE,
    input logic flushD,
    input logic stallF,
    input logic stallD,
    output logic [DATA_WIDTH-1:0] instrD,
    output logic [ROM_WIDTH-1:0] pcD
); 
    
logic [DATA_WIDTH-1:0] instrF;
logic [ROM_WIDTH-1:0] pcF;
logic [ROM_WIDTH-1:0] pcNext;

InstrMem instrMem(
    .a(pcF),
    .rd(instrF)
);

MUXN #(2,ROM_WIDTH) pcMux(
    .sel(pcSelE),
    .bus({dout1E[ROM_WIDTH-1:0]+immExtE[ROM_WIDTH-1:0],
        dout1E[ROM_WIDTH-1:0]+immExtE[ROM_WIDTH-1:0],
        (pcE+immExtE[ROM_WIDTH-1:0]),
        (pcF+12'd4)}),
    .out(pcNext)

);

PC pcReg(
    .clk(clk),
    .rst(rst),
    .en(!stallF),
    .PC(pcF),
    .PCNext(pcNext)

);

always_ff @(posedge clk ) begin
    if (flushD)begin
        instrD<=0;
        pcD<=0;
    end
    else if (!stallD) begin
        instrD<=instrF;
        pcD<=pcF;
    end
end

endmodule

