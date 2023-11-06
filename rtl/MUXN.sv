module MUXN
    #(parameter RF_WIDTH,DATA_WIDTH)
    (
        input [DATA_WIDTH-1:0] bus [2**RF_WIDTH-1:0],
        input  logic [RF_WIDTH-1:0] sel,

        output logic [DATA_WIDTH-1:0] out
    );

assign out=bus[sel];
endmodule

