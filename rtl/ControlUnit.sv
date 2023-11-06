module ControlUnit #(
    parameter DATA_WIDTH=32
)(
    input logic[DATA_WIDTH-1:0] Instr,
 
    output logic [1:0] PCSel,
    output logic [1:0] ResultSel,
    output logic MemWrite,
    output logic [3:0] ALUCtrl,
    output logic ALUSel,
    output logic [2:0] ImmSel,
    output logic RegWrite,
    output logic Branch,
    output logic [2:0] MemCtrl,
    output logic Mul

); 

logic [6:0] op = Instr[6:0];
logic [2:0] funct3 = Instr[14:12];
logic [6:0] funct7 = Instr[31:25];


assign MemCtrl = funct3;

always_latch
    casez (op)
 

        //I and S type load and store instructions
        7'b0?00011: begin              
            RegWrite = !op[5];
            ResultSel = {1'b0, !op[5]};  
            MemWrite = op[5];            
            PCSel = 2'b00;
            ALUSel = 1;
            ImmSel = {2'b0, op[5]}; 
            ALUCtrl = 4'b0000; 
            Branch=0;     
            Mul=0;  
        end


        //I & R type logic and arithmetics instructions
        7'b0?10011: begin
            /*for these instrcuctions the result is stored in the 
            so the RegWrite is 1 and and the MemWrite is 0. 
            ALUSel depends on wether instruction is Immediate or Register
            ResultSel should always select the register result because we 
            are not using memory*/
            Mul=funct7[0]&op[5];
            ALUSel=!op[5]; 
            ALUCtrl = {(( funct3==3'b101 | ((funct3==3'b000)&(op[5])) )&funct7[5]),funct3};
            RegWrite=1;
            ImmSel=3'b000;
            PCSel=2'b00;
            MemWrite = 0;
            ResultSel=0;
            Branch=0;

        end

        //B type instructions: PC-relative Branches
        7'b1100011: begin
            RegWrite = 0;
            ResultSel = 0;
            MemWrite = 0;
            PCSel = {2'b00};
            ALUSel = 0;
            ImmSel = 3'b010;
            ALUCtrl={1'b0,funct3};
            Branch=1;
            Mul=0; 
        end

        //U type 
        7'b0?10111: begin
            RegWrite = 1;
            ResultSel = {!op[5], 1'b0};// 10 for auipc and 00 for lui
            MemWrite = 0;
            PCSel = 2'b00;//needs ettending to
            ALUSel = 1;
            ImmSel = 3'b011;
            ALUCtrl=4'b1111;//needs attending to
            Branch=0;
            Mul=0; 
        end
        //I/J (JAL or JALR)
        7'b110?111: begin 
            PCSel = op[3] ? 2'b01 : 2'b10 ; //01 for JAL and 10 for JALR
            ImmSel = op[3] ? 3'b100 : 3'b000 ;
            ALUCtrl = 4'b0010;
            MemWrite = 0;
            RegWrite = 1;
            ResultSel = 2'b11; //11 for jal and jar
            Branch=0;
            Mul=0; 
        end
              
        default: begin    
            RegWrite = 0;
            ResultSel = 0;  
            MemWrite = 0;            
            PCSel = 0;
            ALUSel = 0;
            ImmSel = 0; 
            ALUCtrl = 0; 
            Branch=0;   
            Mul=0; 
             
        end

    endcase

endmodule

