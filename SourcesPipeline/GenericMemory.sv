module GenericMemory
        #(
                parameter WIDTH = 32,   //Tamaño de palabra
                parameter DEPTH = 32    //Cantidad de bits de direccionamiento
        )   
        (       
	        input  logic clock,
                input  logic [DEPTH-1:0] addressReadGenericMemory,
	        input  logic [DEPTH-1:0] addressWriteGenericMemory,	 
                input  logic enableReadGenericMemory,
	        input  logic enableWriteGenericMemory,
                input  logic [WIDTH-1:0] dataInGenericMemory,
                output logic [WIDTH-1:0] dataOutGenericMemory
        );

        logic [WIDTH-1:0] memory [1024-1:0];      //2^32 = 4 GB vectores de 32 bits

        // Proceso de escritura sincronizado con el reloj
        always @(posedge clock) begin
                if (enableWriteGenericMemory) begin
                        memory[addressWriteGenericMemory] <= dataInGenericMemory;
                end
        end

	assign dataOutGenericMemory = enableReadGenericMemory ? memory[addressReadGenericMemory] : '0;


endmodule : GenericMemory
