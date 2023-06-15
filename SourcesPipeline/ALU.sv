module ALU 
        #(
                parameter WIDTH = 32 
        ) 
        (
                input logic [3:0] controlOpALU,
                input logic [WIDTH-1:0] numberAALU,
                input logic [WIDTH-1:0] numberBALU,
                output logic [WIDTH-1:0] resultALU,
                output logic isZeroResultALU
        );
        
        always @(*) begin
                case (controlOpALU)
                        //Bitwise AND
                        4'b0000: resultALU = numberAALU & numberBALU;
                        //Bitwise OR
                        4'b0001: resultALU = numberAALU | numberBALU;
                        //ADD
                        4'b0010: resultALU = numberAALU + numberBALU;
                        //Subtract
                        4'b0110: resultALU = numberAALU - numberBALU;
                        //Set on less than
                        4'b0111: resultALU = ($signed(numberAALU) < $signed(numberBALU)) ? 1: 0;
                        //Bitwise NOR
                        4'b1100: resultALU = ~(numberAALU | numberBALU);
                        default: resultALU = 0;
                endcase
        end

        assign isZeroResultALU = (0 == resultALU) ? 1 : 0;

endmodule : ALU