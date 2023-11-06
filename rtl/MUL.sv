module MUL#(DATA_WIDTH=32)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] B,
    input logic [3:0] aluCtrlE,
    output logic [DATA_WIDTH-1:0] OUT,
    input logic isMulE,
    output logic isDone
);
logic [DATA_WIDTH-1:0] BTEMP; 
logic [DATA_WIDTH-1:0] ATEMP; 
int I =31;
int J=0;
logic [DATA_WIDTH-1:0] Q;
logic [DATA_WIDTH-1:0] R;
always_ff @(posedge isMulE)begin
    // if(B>A)begin
    //     COUNT<=A;
    //     ATEMP<=B;
    // end
    // else begin
    //     COUNT<=B;
    //     ATEMP<=A;
    // end
   ATEMP<=A;
   BTEMP<=B;
end

always_ff @(posedge clk)begin
    if(isMulE)begin
        case (aluCtrlE[2:0])
            3'b000:begin
                if(J<31)begin
                    if(BTEMP[J]==1'b1)begin
                        OUT<=OUT+ATEMP;
                    end
                    J<=J+1;
                    ATEMP<=ATEMP<<1;
                    isDone<=0;
                end

                else begin
                    isDone<=1;

                end
            end
            3'b101:
                if(I>=0) begin
                    I<=I-1;
                    R<=R<<1;
                    R[0]<=A[I];
                    if(R>=B)begin
                        R<=R-B;
                        Q[I]<=1'b1;
                    end
                    isDone<=0;
                end
                else begin
                    isDone<=1;
                    OUT<=Q;
                end
            3'b111:
                if(I>=0) begin
                        I<=I-1;
                        R<=R<<1;
                        R[0]<=A[I];
                        if(R>=B)begin
                            R<=R-B;
                            Q[I]<=1'b1;
                        end
                        isDone<=0;
                    end
                    else begin
                        isDone<=1;
                        OUT<=R;
                    end
            default: begin
                if(J<31)begin
                    if(BTEMP[J]==1'b1)begin
                        OUT<=OUT+ATEMP;
                    end
                    J<=J+1;
                    ATEMP<=ATEMP<<1;
                    isDone<=0;
                end

                else begin
                    isDone<=1;

                end
            end

        endcase
    end   
    if(isDone==1)begin
        isDone<=0; 
        Q<=0;
        R<=0;
        BTEMP<=0;
        ATEMP<=0;
        I<=31;
    end
end

endmodule
