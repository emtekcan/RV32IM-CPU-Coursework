module Execute#(
    parameter DATA_WIDTH=32,
    parameter ROM_WIDTH=12,
    parameter RF_WIDTH=5
)(
    //signals passing through
    input logic clk,
    input logic regWriteE,
    input logic [1:0] resultSelE,
    input logic memWriteE,
    input logic [2:0] memCtrlE,

    input logic [1:0] _pcSelE,
    input logic [3:0] aluCtrlE,
    input logic aluSelE,
    input logic branchE,

    input logic [DATA_WIDTH-1:0] dout1E,
    input logic [DATA_WIDTH-1:0] dout2E,
    input logic [ROM_WIDTH-1:0] pcE, 
    input logic [RF_WIDTH-1:0] regAddr3E, 
    input logic [DATA_WIDTH-1:0] immExtE,

    //hazard control
    input logic [1:0] forward1E,
    input logic [1:0] forward2E,
    input logic [DATA_WIDTH-1:0] regDin3W,
    input logic isMulE,
    input logic stallM,
    input logic [6:0] opE,

    output logic isDone,
    output logic [1:0] pcSelE,
    output logic regWriteM,
    output logic [1:0] resultSelM,
    output logic memWriteM,
    output logic [2:0] memCtrlM,
    output logic [DATA_WIDTH-1:0] immExtM,
    output logic [DATA_WIDTH-1:0] aluResultM,
    
    output logic [DATA_WIDTH-1:0] memDinM,
    output logic [RF_WIDTH-1:0] regAddr3M,
    output logic [ROM_WIDTH-1:0] pcM,
    output logic [6:0] opM

);

logic [DATA_WIDTH-1:0] aluMuxOut;
logic [DATA_WIDTH-1:0] aluResultE;
logic zeroE;
logic [DATA_WIDTH-1:0] memDinE;

logic [DATA_WIDTH-1:0] regFWD1;
logic [DATA_WIDTH-1:0] regFWD2;
logic [DATA_WIDTH-1:0] aluOut;
logic [DATA_WIDTH-1:0] mulOut;
assign memDinE=regFWD2;
assign aluResultE = isMulE ? mulOut : aluOut;
MUL #(DATA_WIDTH) mul(
    .clk(clk),
    .isMulE(isMulE),
    .A(regFWD1),
    .B(aluMuxOut),
    .OUT(mulOut),
    .isDone(isDone),
    .aluCtrlE(aluCtrlE)
);

MUXN #(2,DATA_WIDTH) fwdMux1(
    .bus({aluResultM,aluResultM,regDin3W,dout1E}),
    .sel(forward1E),
    .out(regFWD1)
);
MUXN #(2,DATA_WIDTH) fwdMux2(
    .bus({aluResultM,aluResultM,regDin3W,dout2E}),
    .sel(forward2E),
    .out(regFWD2)
);
MUXN #(1,DATA_WIDTH) aluMux(
    .bus({immExtE,regFWD2}),
    .sel(aluSelE),
    .out(aluMuxOut)
);

MUXN #(1,2) pcSelMux(
    .bus({{1'b0,zeroE},_pcSelE}),
    .sel(branchE),
    .out(pcSelE)
);
ALU alu(
    .op1(regFWD1),
    .op2(aluMuxOut),
    .ctrl(aluCtrlE),
    .sum(aluOut),
    .Zero(zeroE)
);


// ExecuteReg executeReg(
//     //inputs
//     .clk(clk),
//     .regWriteE(regWriteE),
//     .resultSelE(resultSelE),
//     .memWriteE(memWriteE),
//     .aluResultE(aluResultE),
//     .memDinE(memDinE),
//     .regAddr3E(regAddr3E),
//     .pcE(pcE),
//     .immExtE(immExtE),
//     .memCtrlE(memCtrlE),
//     //outputs
//     .regWriteM(regWriteM),
//     .resultSelM(resultSelM),
//     .memWriteM(memWriteM),
//     .aluResultM(aluResultM),
//     .memDinM(memDinM),
//     .regAddr3M(regAddr3M),
//     .pcM(pcM),
//     .immExtM(immExtM),
//     .memCtrlM(memCtrlM)

// );
always_ff @(posedge clk) begin
    if(!stallM)begin
        regWriteM<= regWriteE;
        resultSelM<= resultSelE;
        memWriteM<= memWriteE;
        aluResultM<= aluResultE;
        memDinM<= memDinE;
        regAddr3M<= regAddr3E;
        pcM<= pcE;
        immExtM<=immExtE;
        memCtrlM<=memCtrlE;
        opM<=opE;
    end
end
endmodule

