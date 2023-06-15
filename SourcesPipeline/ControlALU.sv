module ControlALU 
        (
                input logic [1:0] opCodeALU,
                input logic [5:0] functionALU,
                output logic [3:0] controlOpALU
        );

        localparam opCodeAdd   = 2'b00;
        localparam opCodeSub   = 2'b01;
        localparam opCodeFunct = 2'b10;
        localparam opCodeOr    = 2'b11;

        always @ (*) begin
                if (opCodeAdd == opCodeALU)
                        controlOpALU = 4'b0010; //Add
                else if (opCodeSub == opCodeALU)
                        controlOpALU = 4'b0110; //Subtract
                else if (opCodeOr== opCodeALU)
                        controlOpALU = 4'b0001; //Bitwise Or
                else if (opCodeFunct == opCodeALU)
                        case (functionALU)
                                6'b10_0000: controlOpALU =  4'b0010; //ADD
                                6'b10_1010: controlOpALU =  4'b0111; //Set on less than
                                6'b10_0100: controlOpALU =  4'b0000; //Bitwise AND
                                6'b10_0101: controlOpALU =  4'b0001; //Bitwise Or
                                6'b10_0111: controlOpALU =  4'b1100; //Bitwise Nor
                                default: controlOpALU = 4'b0000;
                        endcase
        end
        
endmodule : ControlALU