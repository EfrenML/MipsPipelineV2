module SignExtender 
        #(
                parameter ORIGINAL_WIDTH = 16,
                parameter FINAL_WIDTH = 32
        ) 
        (
                input logic [ORIGINAL_WIDTH-1:0] dataInSignExtender,
                output logic [FINAL_WIDTH-1:0] dataOutSignExtender
        );

        localparam NUM_BITS_TO_EXTEND = FINAL_WIDTH - ORIGINAL_WIDTH;

        assign dataOutSignExtender = {{NUM_BITS_TO_EXTEND{dataInSignExtender[ORIGINAL_WIDTH-1]}}, dataInSignExtender};
        
endmodule : SignExtender