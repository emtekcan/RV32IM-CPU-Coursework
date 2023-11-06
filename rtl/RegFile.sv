     
module RegFile #(
    parameter RF_WIDTH=5,
              DATA_WIDTH=32
)(
    input logic clk, 
    input logic we3,
    input logic[RF_WIDTH-1:0] addr1,
    input logic[RF_WIDTH-1:0] addr2, 
    input logic[RF_WIDTH-1:0] addr3,
    input logic [DATA_WIDTH-1:0] din3,
    output logic[DATA_WIDTH-1:0] dout1, 
    output logic[DATA_WIDTH-1:0] dout2,
    output logic [DATA_WIDTH-1:0] a0
);

logic [DATA_WIDTH-1:0] regArray [2**RF_WIDTH-1:0];

always_ff @(negedge clk) begin
    if(we3&(addr3!=0))begin
        regArray[addr3]<=din3;
    end

    // $display("\n | a0:" ,regArray[10]," | a1:" ,regArray[11]," | a2:" ,regArray[12]," | a3:" ,regArray[13],
    // "\n | a4:" ,regArray[14]," | a5:" ,regArray[15]," | a6:" ,regArray[16],
    // );

    // $display("\n | t0:" ,regArray[5]," | t1:" ,regArray[6]," | t2:" ,regArray[7]," | t3:" ,regArray[28],
    // "\n | t4:" ,regArray[29]," | t5:" ,regArray[30]," | t6:" ,regArray[31],
    // );
end

always_comb begin 
    dout1=regArray[addr1];
    dout2=regArray[addr2];
    a0=regArray[10]; 
end

endmodule

