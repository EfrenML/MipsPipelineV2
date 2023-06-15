module MemoryAccessMIPS 
        (
                input clock,
                input resetMachine,
                //From execute
                        //Register file
                input logic enableWriteRegisterFile_Execute,
                input logic [4:0] addressWriteRegisterFile_Execute,
                input logic controlSignalWriteFromDataMemoryRegisterFile_Execute,
                        //ALU
                input logic [31:0] resultALU_Execute,
                        //Data memory
                input logic enableReadDataMemory_Execute,            
                input logic enableWriteDataMemory_Execute,
                input logic [31:0] dataToWriteDataMemory_Execute,
                        //Instruction
                input logic [31:0] instruction_Execute,
                //From Data Fowarding Unit
                input logic controlSignalFowardDataReadDataMemory_FowardingUnit,
                input logic [31:0] fowardDataToWriteDataMemory_FowardingUnit,
                //To Write back
                output logic [31:0] dataReadDataMemory_MemoryAccess,
                output logic [31:0] resultALU_MemoryAccess,
                output logic controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess,
                //To hazard unit
                output logic enableWriteRegisterFile_MemoryAccess,
                output logic [4:0] addressWriteRegisterFile_MemoryAccess,
                //To Data Fowarding Unit
                output logic enableReadDataMemory_MemoryAccess,
                //Instruction
                output logic [31:0] instruction_MemoryAccess
        );

        logic [31:0] dataReadDataMemory;
        logic [31:0] dataToWriteDataMemory;
        logic [31:0] addressWriteGenericMemory;

        Mux2To1 FowardDataMemory
        (
                //Inputs
                .dataIn0_Mux2To1(dataToWriteDataMemory_Execute),
                .dataIn1_Mux2To1(fowardDataToWriteDataMemory_FowardingUnit),
                .selector_Mux2To1(controlSignalFowardDataReadDataMemory_FowardingUnit),
                //Output
                .dataOut_Mux2To1(dataToWriteDataMemory)
        );
        
        GenericMemory DataMemory
        (
	        .clock(clock),
                .addressReadGenericMemory(resultALU_Execute),
	        .addressWriteGenericMemory(resultALU_Execute),	 
                .enableReadGenericMemory(enableReadDataMemory_Execute),
	        .enableWriteGenericMemory(enableWriteDataMemory_Execute),
                .dataInGenericMemory(dataToWriteDataMemory),
                .dataOutGenericMemory(dataReadDataMemory)
        );

        always @ (posedge clock, posedge resetMachine) begin
                if (resetMachine) begin
                        //To write back
                        dataReadDataMemory_MemoryAccess <= 0;
                        resultALU_MemoryAccess <= 0;
                        controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess <= 0;
                        //To data frowarding unit
                        enableWriteRegisterFile_MemoryAccess <= 0;
                        addressWriteRegisterFile_MemoryAccess <= 0;
                        instruction_MemoryAccess <= 0;
                        enableReadDataMemory_MemoryAccess <= 0;
                end
                else begin
                        //To write back
                        dataReadDataMemory_MemoryAccess <= dataReadDataMemory;
                        resultALU_MemoryAccess <= resultALU_Execute;
                        controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess <= controlSignalWriteFromDataMemoryRegisterFile_Execute;
                        //To data frowarding unit
                        enableWriteRegisterFile_MemoryAccess <= enableWriteRegisterFile_Execute;
                        addressWriteRegisterFile_MemoryAccess <= addressWriteRegisterFile_Execute;
                        instruction_MemoryAccess <= instruction_Execute;
                        enableReadDataMemory_MemoryAccess <= enableReadDataMemory_Execute;
                end
        end

                
endmodule : MemoryAccessMIPS