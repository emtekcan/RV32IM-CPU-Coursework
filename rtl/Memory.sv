module Memory #(
    parameter DATA_WIDTH=32,ROM_WIDTH=12,RF_WIDTH=5
)(
   input logic clk,
   input logic regWriteM,
   input logic [1:0] resultSelM,
   input logic memWriteM,
   input logic [DATA_WIDTH-1:0] aluResultM,
   input logic [DATA_WIDTH-1:0] memDinM,
   input logic [RF_WIDTH-1:0] regAddr3M,
   input logic [ROM_WIDTH-1:0] pcM,
   input logic [DATA_WIDTH-1:0] immExtM,
   input logic [2:0] memCtrlM,
   input logic stallW,
   input logic [6:0] opM,
   output logic regWriteW,
   output logic [RF_WIDTH-1:0] regAddr3W,
   output logic [DATA_WIDTH-1:0] regDin3W
);

logic [DATA_WIDTH-1:0] regDin3M;
logic [DATA_WIDTH-1:0] memDout;
logic [DATA_WIDTH-1:0] cacheRd;
logic [DATA_WIDTH-1:0] dataMemRd;
logic [63:0]           blockRd;
logic                  hit;

DataMem #(DATA_WIDTH) dataMem(
    .a(aluResultM),
    .func3(memCtrlM),
    .we(memWriteM),
    .wd(memDinM),
    .clk(clk),
    .readData(dataMemRd),
    .blockRd(blockRd)
);

Cache #(DATA_WIDTH) cacheMem(
    .a(aluResultM),
    .func3(memCtrlM),
    .readData(cacheRd),
    .we(memWriteM),
    .wd(memDinM),
    .hit(hit),
    .clk(clk),
    .blockRd(blockRd),
    .op(opM)
);

MUXN #(1,DATA_WIDTH) memSel(
    .sel(hit),
    .bus({cacheRd,dataMemRd}),
    .out(memDout)
);

MUXN #(2,DATA_WIDTH) regMux(
    .bus({
        ({{DATA_WIDTH-ROM_WIDTH{1'b0}}, pcM+12'd4}),
        (immExtM+{{DATA_WIDTH-ROM_WIDTH{1'b0}},pcM}),
        memDout,
        aluResultM}),
    .sel(resultSelM),
    .out(regDin3M)
);


always_ff @(posedge clk) begin
    if(!stallW)begin
        regWriteW<=regWriteM;
        regAddr3W<=regAddr3M;
        regDin3W<=regDin3M;
    end
end
endmodule


