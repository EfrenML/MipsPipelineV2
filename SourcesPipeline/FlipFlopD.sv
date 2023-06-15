module FlipFlopD 
        #(
                WIDTH = 32
        ) 
        (
                input logic clock,
                input logic resetFlipFlopD,
                input logic enableFlipFlopD,
                input logic [WIDTH-1:0] dataInFlipFlopD,
                output logic [WIDTH-1:0] dataOutFlipFlopD
        );

        always @(posedge clock, posedge resetFlipFlopD) begin
                if (resetFlipFlopD)
                        dataOutFlipFlopD <= 0;
                else if (enableFlipFlopD)
                        dataOutFlipFlopD <= dataInFlipFlopD;
        end

endmodule : FlipFlopD