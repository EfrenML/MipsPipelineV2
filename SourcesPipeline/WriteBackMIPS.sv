module WriteBackMIPS 
        (
                //From data memory
                input logic controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess,
                input logic [31:0] dataReadDataMemory_MemoryAccess,
                input logic [31:0] resultALU_MemoryAccess,
                input logic enableWriteRegisterFile_MemoryAccess,
                input logic [4:0] addressWriteRegisterFile_MemoryAccess,
                //To Decode
                output logic [31:0] dataToWriteRegisterFile_WriteBack,
                output logic [4:0] addressWriteRegisterFile_WriteBack,
                //To hazard unit and Decode
                output logic enableWriteRegisterFile_WriteBack
        );

        Mux2To1 DataToWriteRegisterFile_WriteBack
        (
                //inputs
                .dataIn0_Mux2To1(resultALU_MemoryAccess),
                .dataIn1_Mux2To1(dataReadDataMemory_MemoryAccess),
                .selector_Mux2To1(controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess),
                //outputs
                .dataOut_Mux2To1(dataToWriteRegisterFile_WriteBack)
        );
        
        assign enableWriteRegisterFile_WriteBack = enableWriteRegisterFile_MemoryAccess;
        assign addressWriteRegisterFile_WriteBack = addressWriteRegisterFile_MemoryAccess;

endmodule : WriteBackMIPS