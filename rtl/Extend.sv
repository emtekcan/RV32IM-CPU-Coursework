module Extend #(parameter INSTR_WIDTH = 32)(
    input logic [INSTR_WIDTH-1:0] Instr,
    input logic [2:0] ImmSel,
    output logic [INSTR_WIDTH-1:0] ImmExt 
);

always_comb 
    case (ImmSel)
        // Immediate 
        3'b000 : ImmExt={{20{Instr[31]}},Instr[31:20]}; 
        // Store
        3'b001 : ImmExt={{20{Instr[31]}},Instr[31:25],Instr[11:7]};
        // Branch
        3'b010 : ImmExt={{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
        // Upper Immediate
        3'b011 : ImmExt={{Instr[31:12]},12'b0};
        // Jump 
        3'b100 : ImmExt={{12{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0};
        default: ImmExt={{20{Instr[31]}},Instr[31:20]};
    endcase

    
endmodule

