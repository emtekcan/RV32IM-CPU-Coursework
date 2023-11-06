module CPU #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12, RF_WIDTH=5
)(
    input logic clk,
    input logic rst,
   
    output logic [DATA_WIDTH-1:0] a0
);

//Fetch stuff outputs
    
    logic [ROM_WIDTH-1:0] pcD;
    logic [DATA_WIDTH-1:0] instrD;
//Decode stuff outputs
    logic regWriteE;
    logic [1:0] resultSelE;
    logic memWriteE;
    logic [1:0] _pcSelE;
    logic [3:0] aluCtrlE;
    logic aluSelE;
    logic [2:0] memCtrlE;
    logic [DATA_WIDTH-1:0] dout1E;
    logic [DATA_WIDTH-1:0] dout2E;
    logic [ROM_WIDTH-1:0] pcE;
    logic [RF_WIDTH-1:0] regAddr3E;
    logic [DATA_WIDTH-1:0] immExtE;
    logic branchE;
    logic [6:0] opE;

//Execute stuff outputs
    logic [1:0] pcSelE;
    logic regWriteM;
    logic [1:0] resultSelM;
    logic memWriteM;
    logic [DATA_WIDTH-1:0] immExtM;
    logic [DATA_WIDTH-1:0] aluResultM;
    logic [DATA_WIDTH-1:0] memDinM;
    logic [RF_WIDTH-1:0] regAddr3M;
    logic [ROM_WIDTH-1:0] pcM;
    logic [2:0] memCtrlM;
    logic [6:0] opM;
//Memory stuff output 
    logic regWriteW;
    logic [RF_WIDTH-1:0] regAddr3W;
    logic [DATA_WIDTH-1:0] regDin3W;
    logic flushD;
    logic flushE;
    logic stallD;
    logic stallF;
    logic [1:0] forward1E;
    logic [1:0] forward2E;
    logic isMulE;
    logic isDone;
    logic stallE;
    logic stallM;
    logic stallW;
Fetch #(DATA_WIDTH,ROM_WIDTH) fetch(
    //inputs
    .clk(clk),
    .rst(rst),
    .pcSelE(pcSelE),
    .immExtE(immExtE),
    .dout1E(dout1E),
    .pcE(pcE),
    .stallD(stallD),
    .stallF(stallF),
    //outputs
    .instrD(instrD),
    .pcD(pcD),
    .flushD(flushD)
);
Decode #(DATA_WIDTH,ROM_WIDTH,RF_WIDTH) decode(
    .clk(clk),
    .pcD(pcD),
    .regDin3W(regDin3W),
    .regWriteE(regWriteE),
    .regWriteW(regWriteW),
    .resultSelE(resultSelE),
    .memWriteE(memWriteE),
    ._pcSelE(_pcSelE),
    .aluCtrlE(aluCtrlE),
    .aluSelE(aluSelE),
    .instrD(instrD),
    .dout1E(dout1E),
    .dout2E(dout2E),
    .pcE(pcE),
    .regAddr3E(regAddr3E),
    .regAddr3W(regAddr3W),
    .immExtE(immExtE),
    .branchE(branchE),
    .a0(a0),
    .flushE(flushE),
    .memCtrlE(memCtrlE),
    .isMulE(isMulE),
    .stallE(stallE)
);
Execute #(DATA_WIDTH,ROM_WIDTH,RF_WIDTH) execute(
    .clk(clk),
    .regWriteE(regWriteE),
    .resultSelE(resultSelE),
    .memWriteE(memWriteE),
    ._pcSelE(_pcSelE),
    .aluCtrlE(aluCtrlE),
    .aluSelE(aluSelE),
    .dout1E(dout1E),
    .dout2E(dout2E),
    .pcE(pcE),
    .regAddr3E(regAddr3E),
    .immExtE(immExtE),
    .branchE(branchE),
    .pcSelE(pcSelE),
    .memCtrlE(memCtrlE),
    .forward1E(forward1E),
    .forward2E(forward2E),
    .regDin3W(regDin3W),
    .regWriteM(regWriteM),
    .resultSelM(resultSelM),
    .memWriteM(memWriteM),
    .immExtM(immExtM),
    .aluResultM(aluResultM),
    .memDinM(memDinM),
    .regAddr3M(regAddr3M),
    .pcM(pcM),
    .memCtrlM(memCtrlM),
    .isMulE(isMulE),
    .isDone(isDone),
    .stallM(stallM),
    .opE(opE),
    .opM(opM)
 
);
Memory #(DATA_WIDTH,ROM_WIDTH,RF_WIDTH) memory(
    .clk(clk),
    .regWriteM(regWriteM),
    .resultSelM(resultSelM),
    .memWriteM(memWriteM),
    .aluResultM(aluResultM),
    .memDinM(memDinM),
    .regAddr3M(regAddr3M),
    .pcM(pcM),
    .immExtM(immExtM),
    .memCtrlM(memCtrlM),
    .regWriteW(regWriteW),
    .regAddr3W(regAddr3W),
    .regDin3W(regDin3W),
    .stallW(stallW),
    .opM(opM)
);


HazardUnit #(RF_WIDTH) hazardUnit(
    .pcSelE(pcSelE),
    .resultSelE(resultSelE),
    .regAddr3E(regAddr3E),
    .addr1D(instrD[19:15]),
    .addr2D(instrD[24:20]),
    .addr1E(addr1E),
    .addr2E(addr2E),
    .flushD(flushD),
    .flushE(flushE),
    .stallD(stallD),
    .stallF(stallF),
    .stallE(stallE),
    .stallM(stallM),
    .stallW(stallW),
    .regAddr3W(regAddr3W),
    .regAddr3M(regAddr3M),
    .regWriteW(regWriteW),
    .regWriteM(regWriteM),
    .forward1E(forward1E),
    .forward2E(forward2E),
    .isMulE(isMulE),
    .isDone(isDone)

);

logic [RF_WIDTH-1:0] addr1E;
logic [RF_WIDTH-1:0] addr2E;

always_ff @(posedge clk) begin
    if(!stallE)begin
        if(flushE)begin
            addr1E<=0;
            addr2E<=0;
            opE<=0;
        end
        else begin
            addr1E<=instrD[19:15];
            addr2E<=instrD[24:20];
            opE<=instrD[6:0];
        end
    end
end
endmodule

