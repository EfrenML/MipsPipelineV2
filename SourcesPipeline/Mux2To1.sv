module Mux2To1 
        #(
                WIDTH = 32
        )
        (
                input logic [WIDTH-1:0] dataIn0_Mux2To1,
                input logic [WIDTH-1:0] dataIn1_Mux2To1,
                input selector_Mux2To1,
                output logic [WIDTH-1:0] dataOut_Mux2To1
        );

        assign dataOut_Mux2To1 = selector_Mux2To1 ? dataIn1_Mux2To1 : dataIn0_Mux2To1;
        
endmodule : Mux2To1