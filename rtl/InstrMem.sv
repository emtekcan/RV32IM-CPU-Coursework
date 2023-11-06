module InstrMem #(
    parameter ROM_WIDTH  = 12,
                DATA_WIDTH = 32
)(
    input logic [ROM_WIDTH-1:0] a,
    output logic [DATA_WIDTH-1:0] rd
);

logic [7:0] rom_array [32'hBFC00FFF:32'hBFC00000];

initial begin 
    $display("Loading ROM...");
    $readmemh("Instr.mem",rom_array);
end;

assign rd = {rom_array[a], rom_array[a+1], rom_array[a+2], rom_array[a+3]};
// assign rd = {rom_array[a+3], rom_array[a+2], rom_array[a+1], rom_array[a]};

endmodule

