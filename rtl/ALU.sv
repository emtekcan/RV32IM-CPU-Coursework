module ALU #(parameter DATA_WIDTH=32)(
    input logic [DATA_WIDTH-1:0] op1, 
    input logic [DATA_WIDTH-1:0] op2,
    input logic [3:0] ctrl,
    output logic [DATA_WIDTH-1:0] sum,
    output logic Zero
);


always_comb begin

    case (ctrl[2:0])
        3'b000: sum = !ctrl[3] ?  (op1 + op2) : (op1 - op2);
        3'b001: sum = op1 << op2[4:0];
        3'b010: sum = {{31'b0}, {($signed(op1) < $signed(op2))}}; 
        3'b011: sum =  {{31'b0}, {(op1 < op2)}}; // need to be unsigned
        3'b100: sum = op1 ^ op2;
        3'b101: sum = !ctrl[3] ? (op1 >> op2[4:0]) : (op1 >>> op2[4:0]);
        3'b110: sum = op1 | op2;
        3'b111: sum = !ctrl[3] ? (op1 & op2) : op2; //(1111 for load and store instructions)
       
    endcase

    case (ctrl[2:0])
        3'b000: Zero = (op1 == op2);
        3'b001: Zero = (op1 != op2);
        3'b100: Zero = ($signed(op1) < $signed(op2));
        3'b101: Zero = ($signed(op1) >= $signed(op2));
        3'b110: Zero = (op1 < op2);
        3'b111: Zero = (op1 >= op2);
        default: Zero = 0;
       
    endcase
end


endmodule

