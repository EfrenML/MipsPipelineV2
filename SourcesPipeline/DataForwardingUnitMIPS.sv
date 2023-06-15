module DataForwardingUnitMIPS 
(
        //From Decode
        input logic [4:0] addressReadARegisterFile_Decode,
        input logic [4:0] addressReadBRegisterFile_Decode,
        input logic enableWriteDataMemory_Decode,
        //From Execute
        input logic enableWriteRegisterFile_Execute,
        input logic [4:0] addressWriteRegisterFile_Execute,
        input logic [31:0] resultALU_Execute,
                //Memory read to write
        input logic enableWriteDataMemory_Execute,
        input logic [4:0] addressReadBRegisterFile_Execute,
        input logic [31:0] addressWriteDataMemory_Execute,
        //From Memory Access
        input logic enableWriteRegisterFile_MemoryAccess,
        input logic [4:0] addressWriteRegisterFile_MemoryAccess,
        input logic [31:0] dataToWriteRegisterFile_WriteBack,   
                //Memory read to write
        input logic enableReadDataMemory_MemoryAccess,

        //Foward A
        output logic [31:0] fowardADataALU_FowardingUnit,
        //Foward B
        output logic [31:0] fowardBDataALU_FowardingUnit,
        //Foward data memory read to write 
        output logic [31:0] fowardDataToWriteDataMemory_FowardingUnit,
        //Enable foward unit
        output logic controlSignalFowardA_FowardingUnit,
        output logic controlSignalFowardB_FowardingUnit,
                //Memory read to write
        output logic controlSignalFowardDataReadDataMemory_FowardingUnit
);
        
        always @ (*) begin
                //Foward A
                if (enableWriteRegisterFile_Execute 
                        && (addressWriteRegisterFile_Execute != 0) 
                        && (addressReadARegisterFile_Decode == addressWriteRegisterFile_Execute)) begin

                        controlSignalFowardA_FowardingUnit = 1; 
                        fowardADataALU_FowardingUnit = resultALU_Execute;
                end
                else if (enableWriteRegisterFile_MemoryAccess 
                        && (addressWriteRegisterFile_MemoryAccess != 0) 
                        && (addressWriteRegisterFile_Execute != addressWriteRegisterFile_MemoryAccess) 
                        && (addressReadARegisterFile_Decode == addressWriteRegisterFile_MemoryAccess)) begin

                        controlSignalFowardA_FowardingUnit = 1;
                        fowardADataALU_FowardingUnit = dataToWriteRegisterFile_WriteBack;
                        end
                else begin
                        controlSignalFowardA_FowardingUnit = 0; 
                        fowardADataALU_FowardingUnit = 0;
                end
                //Foward B
                if (enableWriteRegisterFile_Execute 
                        && ~enableWriteDataMemory_Decode 
                        && (addressWriteRegisterFile_Execute != 0) 
                        && (addressReadBRegisterFile_Decode == addressWriteRegisterFile_Execute)) begin

                        controlSignalFowardB_FowardingUnit = 1;
                        fowardBDataALU_FowardingUnit = resultALU_Execute;
                end
                else if (enableWriteRegisterFile_MemoryAccess 
                        && ~enableWriteDataMemory_Decode 
                        && (addressWriteRegisterFile_MemoryAccess != 0) 
                        && (addressWriteRegisterFile_Execute != addressWriteRegisterFile_MemoryAccess) 
                        && (addressReadBRegisterFile_Decode == addressWriteRegisterFile_MemoryAccess)) begin

                        controlSignalFowardB_FowardingUnit = 1;
                        fowardBDataALU_FowardingUnit = dataToWriteRegisterFile_WriteBack;
                        end
                else begin
                        controlSignalFowardB_FowardingUnit = 0; 
                        fowardBDataALU_FowardingUnit = 0;
                end
                //Memory read to memory write
                if (enableReadDataMemory_MemoryAccess 
                        && enableWriteDataMemory_Execute 
                        && (addressWriteRegisterFile_MemoryAccess != 0) 
                        && (addressWriteRegisterFile_MemoryAccess == addressReadBRegisterFile_Execute)) begin

                        controlSignalFowardDataReadDataMemory_FowardingUnit = 1;
                        fowardDataToWriteDataMemory_FowardingUnit = dataToWriteRegisterFile_WriteBack;
                end
                else begin
                        controlSignalFowardDataReadDataMemory_FowardingUnit = 0;
                        fowardDataToWriteDataMemory_FowardingUnit = 0;
                end
        end
endmodule : DataForwardingUnitMIPS
