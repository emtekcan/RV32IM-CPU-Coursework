module Decode #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12,RF_WIDTH=5
)(
    input logic clk, 
    input logic [DATA_WIDTH-1:0] instrD,
    input logic [ROM_WIDTH-1:0] pcD,
    input logic [DATA_WIDTH-1:0] regDin3W,
    input logic [RF_WIDTH-1:0] regAddr3W, 
    input logic regWriteW,
    input logic flushE,
    input logic stallE,
    output logic regWriteE,
    output logic [1:0] resultSelE,
    output logic memWriteE,
    output logic [1:0] _pcSelE,
    output logic [3:0] aluCtrlE,
    output logic aluSelE,
    output logic [DATA_WIDTH-1:0] dout1E,
    output logic [DATA_WIDTH-1:0] dout2E,
    output logic [ROM_WIDTH-1:0] pcE,
    output logic [RF_WIDTH-1:0] regAddr3E,
    output logic [DATA_WIDTH-1:0] immExtE,
    output logic branchE,
    output logic [2:0] memCtrlE,
    output logic isMulE,
    output logic [DATA_WIDTH-1:0] a0
);

 logic regWriteD;
 logic [1:0] resultSelD;
 logic memWriteD;
 logic [1:0] _pcSelD;
 logic [3:0] aluCtrlD;
 logic aluSelD;
logic [2:0] memCtrlD;
 logic [DATA_WIDTH-1:0] dout1D;
 logic [DATA_WIDTH-1:0] dout2D;

 logic [RF_WIDTH-1:0] regAddr3D;
 logic [DATA_WIDTH-1:0] immExtD;
 logic branchD;
 logic [2:0] immSel;
 logic isMulD;
assign regAddr3D=instrD[11:7];
ControlUnit controlUnit(
    //inputs
    .Instr(instrD),
    //outputs
    .PCSel(_pcSelD),
    .ResultSel(resultSelD),
    .MemWrite(memWriteD),
    .ALUCtrl(aluCtrlD),
    .ALUSel(aluSelD),
    .ImmSel(immSel),
    .RegWrite(regWriteD),
    .Branch(branchD),
    .MemCtrl(memCtrlD),
    .Mul(isMulD)
    );

RegFile #(RF_WIDTH,DATA_WIDTH) regFile(
    .clk(clk),
    .addr1(instrD[19:15]),
    .addr2(instrD[24:20]),
    .addr3(regAddr3W),
    .we3(regWriteW),
    .din3(regDin3W),
    .dout1(dout1D),
    .dout2(dout2D),
    .a0(a0)
);
Extend extend(
     //inputs
    .ImmSel(immSel),
    .Instr(instrD),
    //output
    .ImmExt(immExtD)
);

always_ff @(posedge clk) begin
    if(!stallE)begin
        if(flushE)begin
            regWriteE<=0;
            resultSelE<=0;
            memWriteE<=0;
            _pcSelE<=0;
            aluCtrlE<=0;
            aluSelE<=0;
            dout1E<=0;
            dout2E<=0;
            pcE<=0;
            regAddr3E<=0;
            branchE<=0;
            immExtE<=0;
            memCtrlE<=0;
            isMulE<=0;
        end
        else begin
            regWriteE<=regWriteD;
            resultSelE<=resultSelD;
            memWriteE<=memWriteD;
            _pcSelE<=_pcSelD;
            aluCtrlE<=aluCtrlD;
            aluSelE<=aluSelD;
            dout1E<=dout1D;
            dout2E<=dout2D;
            pcE<=pcD;
            regAddr3E<=regAddr3D;
            branchE<=branchD;
            immExtE<=immExtD;
            memCtrlE<=memCtrlD;
            isMulE<=isMulD;
        end
    end
end

endmodule

