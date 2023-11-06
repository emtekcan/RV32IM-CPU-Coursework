module HazardUnit #(
    parameter RF_WIDTH=5
)(
    output logic flushD,
    output logic flushE,
    output logic stallF,
    output logic stallD,
    output logic stallE,
    output logic stallM,
    output logic stallW,
    output logic [1:0] forward1E,
    output logic [1:0] forward2E,
    input logic [RF_WIDTH-1:0] addr1D,
    input logic [RF_WIDTH-1:0] addr2D,
    input logic [RF_WIDTH-1:0] addr1E,
    input logic [RF_WIDTH-1:0] addr2E,
    input logic [RF_WIDTH-1:0] regAddr3E,
    input logic [1:0] resultSelE,
    input logic [1:0] pcSelE,
    input logic [RF_WIDTH-1:0] regAddr3M,
    input logic [RF_WIDTH-1:0] regAddr3W,
    input logic regWriteW,
    input logic regWriteM,
    input logic isMulE,
    input logic isDone


);
assign stallF=(((addr1D==regAddr3E)|(addr2D==regAddr3E))&(resultSelE==2'b01)) | (isMulE & !isDone);
assign stallD=stallF;
assign stallE=(isMulE & !isDone);
assign stallM=(stallE);
assign stallW=(0);
assign flushD=(pcSelE!=2'b00);
assign flushE=flushD|stallD;
always_comb begin
    if ((addr1E == regAddr3M) & regWriteM & (addr1E!=0)) 
        forward1E = 2'b10;
    else if ((addr1E == regAddr3W) & regWriteW  & (addr1E!=0)) 
        forward1E = 2'b01;
    else 
        forward1E = 2'b00 ;
    if ((addr2E == regAddr3M) & regWriteM  & (addr2E!=0))
        forward2E = 2'b10 ;
    else if ((addr2E == regAddr3W) & regWriteW  & (addr2E!=0)) 
        forward2E = 2'b01;
    else 
        forward2E = 2'b00;
end

endmodule
