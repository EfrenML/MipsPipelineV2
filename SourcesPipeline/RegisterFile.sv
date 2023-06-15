module RegisterFile
        #(
                parameter WIDTH = 32,   //Tamaño de palabra
                parameter DEPTH = 5    //Cantidad de bits de direccionamiento
        )
        (
        input clock,
        input reset,
        input [DEPTH-1:0] addressReadARegisterFile,
        input [DEPTH-1:0] addressReadBRegisterFile,
        input [DEPTH-1:0] addressWriteRegisterFile,
        input enableWriteRegisterFile,
        input enableReadARegisterFile,
        input enableReadBRegisterFile,
        input  logic [WIDTH-1:0] dataToWriteRegisterFile,
        output logic [WIDTH-1:0] dataReadARegisterFile,
        output logic [WIDTH-1:0] dataReadBRegisterFile
        );

logic [WIDTH-1:0] registerFile [2**DEPTH-1:0];  //2**5 = 32 vectores de 32 bits

always @ (*) begin
        if (enableReadARegisterFile)
                dataReadARegisterFile = registerFile[addressReadARegisterFile];
        if (enableReadBRegisterFile)
                dataReadBRegisterFile = registerFile[addressReadBRegisterFile];
end

integer index;
always @(posedge clock, posedge reset) begin
        if (reset)
                for (index = 0; index < (2**DEPTH); index = index +1)
                        registerFile[index] <= 32'b0;
        else
                if (enableWriteRegisterFile && (addressWriteRegisterFile != 0)) begin
                        registerFile[addressWriteRegisterFile] <= dataToWriteRegisterFile;
                end
end

endmodule : RegisterFile
