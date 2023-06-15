module WrapperMIPS 
        (
                input logic clock,
                input logic resetMachine
        );

        //FetchMIPS
        logic [31:0] programCounterPlus4_Fetch;
        logic [31:0] instruction_Fetch;

        //DecodeMIPS
                //Decoder
        logic enableAndBranchProgramCounter_Decode;
        logic enableReadDataMemory_Decode;                
        logic controlSignalWriteFromDataMemoryRegisterFile_Decode;
        logic enableWriteDataMemory_Decode;
        logic controlSignalIsSignExtendedALU_Decode;
        logic [1:0] opCodeALU_Decode;
                //Register file
        logic enableWriteRegisterFile_Decode;
        logic [4:0] addressWriteRegisterFile_Decode;
        logic [31:0] dataReadARegisterFile_Decode;
        logic [31:0] dataReadBRegisterFile_Decode;
                        //To data foward unit
        logic [4:0] addressReadARegisterFile_Decode;
        logic [4:0] addressReadBRegisterFile_Decode;
                //Instruction
        logic [31:0] instruction_Decode;
        logic [31:0] resultSignExtender_Decode;
        logic [31:0] programCounterPlus4_Decode;
                //To Fetch
        logic enableJumpProgramCounter_Decode;
        logic [31:0] nextProgramCounterJump_Decode;
        
        //ExecuteMIPS
                //Register file
        logic controlSignalWriteFromDataMemoryRegisterFile_Execute;
                        //To Data Foward Unit
        logic [4:0] addressWriteRegisterFile_Execute;
        logic enableWriteRegisterFile_Execute;
                //Program counter
        logic enableBranchProgramCounter_Execute;       //was: logic controlSignalIsJumpOrBranch_Execute;
        logic [31:0] nextProgramCounterBranch_Execute;
                //ALU
        logic [31:0] resultALU_Execute;
                //Data memory
        logic enableReadDataMemory_Execute;            
        logic enableWriteDataMemory_Execute;
        logic [31:0] dataToWriteDataMemory_Execute;
                //Instruction
        logic [31:0] instruction_Execute;
                //Data Fowarding Unit;
        logic [4:0] addressReadBRegisterFile_Execute;
        logic [31:0] addressWriteDataMemory_Execute;

        //Memory access
                //To Write back
        logic [31:0] dataReadDataMemory_MemoryAccess;
        logic [31:0] resultALU_MemoryAccess;
        logic controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess;
        logic enableWriteRegisterFile_MemoryAccess;
                //To Data Foward Unit
        logic [4:0] addressWriteRegisterFile_MemoryAccess;
        logic enableReadDataMemory_MemoryAccess;
                //Instruction
        logic [31:0] instruction_MemoryAccess;

        //Write back
        logic [31:0] dataToWriteRegisterFile_WriteBack;
        logic enableWriteRegisterFile_WriteBack;
        logic [4:0] addressWriteRegisterFile_WriteBack;

        //Data fowarding unit
        logic [31:0] fowardADataALU_FowardingUnit;
        logic [31:0] fowardBDataALU_FowardingUnit;
        logic [31:0] fowardDataToWriteDataMemory_FowardingUnit;
        logic controlSignalFowardA_FowardingUnit;
        logic controlSignalFowardB_FowardingUnit;
        logic controlSignalFowardDataReadDataMemory_FowardingUnit;

        //HazardUnitMIPS
        logic enableProgramCounter_HazardUnit;
        logic enableFetch_HazardUnit;
        logic controlSignalSendNoOperation_HazardUnit;
        logic flushFetch_HazardUnit;
        logic flushDecode_HazardUnit;

        FetchMIPS FetchMIPS //This will recieve the Jump instruction from the program counter
        (
                .clock(clock),
                .resetMachine(resetMachine),
                //ProgramCounter
                        //From Decode
                .enableJumpProgramCounter_Decode(enableJumpProgramCounter_Decode),
                .nextProgramCounterJump_Decode(nextProgramCounterJump_Decode),
                        //From Execute
                .enableBranchProgramCounter_Execute(enableBranchProgramCounter_Execute),
                .nextProgramCounterBranch_Execute(nextProgramCounterBranch_Execute),
                //From Hazard Unit
                .enableProgramCounter_HazardUnit(enableProgramCounter_HazardUnit),
                .enableFetch_HazardUnit(enableFetch_HazardUnit),
                .flushFetch_HazardUnit(flushFetch_HazardUnit),
                        //To Decode
                .programCounterPlus4_Fetch(programCounterPlus4_Fetch),
                .instruction_Fetch(instruction_Fetch)
        );

        DecodeMIPS DecodeMIPS
        (
                .clock(clock),
                .resetMachine(resetMachine),
                //From Fetch
                .programCounterPlus4_Fetch(programCounterPlus4_Fetch),
                .instruction_Fetch(instruction_Fetch),
                //To fetch
                .enableJumpProgramCounter_Decode(enableJumpProgramCounter_Decode),
                .nextProgramCounterJump_Decode(nextProgramCounterJump_Decode),
                //From Write back
                .dataToWriteRegisterFile_WriteBack(dataToWriteRegisterFile_WriteBack),
                .enableWriteRegisterFile_WriteBack(enableWriteRegisterFile_WriteBack),
                .addressWriteRegisterFile_WriteBack(addressWriteRegisterFile_WriteBack),
                //From Hazard unit
                .controlSignalSendNoOperation_HazardUnit(controlSignalSendNoOperation_HazardUnit),
                .flushDecode_HazardUnit(flushDecode_HazardUnit),
                //To Execute
                        //Decoder
                .enableAndBranchProgramCounter_Decode(enableAndBranchProgramCounter_Decode),
                .enableReadDataMemory_Decode(enableReadDataMemory_Decode),                
                .enableWriteDataMemory_Decode(enableWriteDataMemory_Decode),
                .controlSignalIsSignExtendedALU_Decode(controlSignalIsSignExtendedALU_Decode),
                .opCodeALU_Decode(opCodeALU_Decode),
                        //Register file
                .enableWriteRegisterFile_Decode(enableWriteRegisterFile_Decode),
                .dataReadARegisterFile_Decode(dataReadARegisterFile_Decode),
                .dataReadBRegisterFile_Decode(dataReadBRegisterFile_Decode),
                .addressWriteRegisterFile_Decode(addressWriteRegisterFile_Decode),
                .addressReadARegisterFile_Decode(addressReadARegisterFile_Decode),
                .addressReadBRegisterFile_Decode(addressReadBRegisterFile_Decode),
                .controlSignalWriteFromDataMemoryRegisterFile_Decode(controlSignalWriteFromDataMemoryRegisterFile_Decode),
                        //Instruction
                .instruction_Decode(instruction_Decode),
                .resultSignExtender_Decode(resultSignExtender_Decode),
                .programCounterPlus4_Decode(programCounterPlus4_Decode) 
        );

        ExecuteMIPS ExecuteMIPS
        (
                .clock(clock),
                .resetMachine(resetMachine),
                //From Execute
                        //Decoder
                .enableAndBranchProgramCounter_Decode(enableAndBranchProgramCounter_Decode),
                .enableReadDataMemory_Decode(enableReadDataMemory_Decode),                
                .enableWriteDataMemory_Decode(enableWriteDataMemory_Decode),
                .controlSignalIsSignExtendedALU_Decode(controlSignalIsSignExtendedALU_Decode),
                .opCodeALU_Decode(opCodeALU_Decode),
                        //Register file
                .dataReadARegisterFile_Decode(dataReadARegisterFile_Decode),
                .dataReadBRegisterFile_Decode(dataReadBRegisterFile_Decode),
                .controlSignalWriteFromDataMemoryRegisterFile_Decode(controlSignalWriteFromDataMemoryRegisterFile_Decode),
                .enableWriteRegisterFile_Decode(enableWriteRegisterFile_Decode),
                .addressWriteRegisterFile_Decode(addressWriteRegisterFile_Decode),
                        //Instruction
                .instruction_Decode(instruction_Decode),
                .resultSignExtender_Decode(resultSignExtender_Decode),
                .programCounterPlus4_Decode(programCounterPlus4_Decode),
                //From Data forwarding unit
                .fowardADataALU_FowardingUnit(fowardADataALU_FowardingUnit),
                .fowardBDataALU_FowardingUnit(fowardBDataALU_FowardingUnit),
                .controlSignalFowardA_FowardingUnit(controlSignalFowardA_FowardingUnit),
                .controlSignalFowardB_FowardingUnit(controlSignalFowardB_FowardingUnit),
                //To Memory access
                        //Register file
                .enableWriteRegisterFile_Execute(enableWriteRegisterFile_Execute),
                .addressWriteRegisterFile_Execute(addressWriteRegisterFile_Execute),
                .controlSignalWriteFromDataMemoryRegisterFile_Execute(controlSignalWriteFromDataMemoryRegisterFile_Execute),
                        //Program counter
                .enableBranchProgramCounter_Execute(enableBranchProgramCounter_Execute),
                .nextProgramCounterBranch_Execute(nextProgramCounterBranch_Execute),
                        //ALU
                .resultALU_Execute(resultALU_Execute),
                        //Data memory
                .enableReadDataMemory_Execute(enableReadDataMemory_Execute),            
                .enableWriteDataMemory_Execute(enableWriteDataMemory_Execute),
                .dataToWriteDataMemory_Execute(dataToWriteDataMemory_Execute),
                        //Instruction
                .instruction_Execute(instruction_Execute),
                //To Data Fowarding Unit
                .addressReadBRegisterFile_Execute(addressReadBRegisterFile_Execute),
                .addressWriteDataMemory_Execute(addressWriteDataMemory_Execute)
        );

        MemoryAccessMIPS MemoryAccessMIPS
        (
                .clock(clock),
                .resetMachine(resetMachine),
                //From execute
                        //Register file
                .enableWriteRegisterFile_Execute(enableWriteRegisterFile_Execute),
                .addressWriteRegisterFile_Execute(addressWriteRegisterFile_Execute),
                .controlSignalWriteFromDataMemoryRegisterFile_Execute(controlSignalWriteFromDataMemoryRegisterFile_Execute),
                        //ALU
                .resultALU_Execute(resultALU_Execute),
                        //Data memory
                .enableReadDataMemory_Execute(enableReadDataMemory_Execute),            
                .enableWriteDataMemory_Execute(enableWriteDataMemory_Execute),
                .dataToWriteDataMemory_Execute(dataToWriteDataMemory_Execute),
                        //Instruction
                .instruction_Execute(instruction_Execute),
                //From Data Fowarding Unit
                .controlSignalFowardDataReadDataMemory_FowardingUnit(controlSignalFowardDataReadDataMemory_FowardingUnit),
                .fowardDataToWriteDataMemory_FowardingUnit(fowardDataToWriteDataMemory_FowardingUnit),
                //To Write back
                .dataReadDataMemory_MemoryAccess(dataReadDataMemory_MemoryAccess),
                .resultALU_MemoryAccess(resultALU_MemoryAccess),
                .controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess(controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess),
                //To hazard unit
                .enableWriteRegisterFile_MemoryAccess(enableWriteRegisterFile_MemoryAccess),
                .addressWriteRegisterFile_MemoryAccess(addressWriteRegisterFile_MemoryAccess),
                //To Data Fowarding Unit
                .enableReadDataMemory_MemoryAccess(enableReadDataMemory_MemoryAccess),
                //Instruction
                .instruction_MemoryAccess(instruction_MemoryAccess)
        );

        WriteBackMIPS WriteBackMIPS
        (
                //From data memory
                .controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess(controlSignalWriteFromDataMemoryRegisterFile_MemoryAccess),
                .dataReadDataMemory_MemoryAccess(dataReadDataMemory_MemoryAccess),
                .resultALU_MemoryAccess(resultALU_MemoryAccess),
                .enableWriteRegisterFile_MemoryAccess(enableWriteRegisterFile_MemoryAccess),
                .addressWriteRegisterFile_MemoryAccess(addressWriteRegisterFile_MemoryAccess),
                //To Decode
                .dataToWriteRegisterFile_WriteBack(dataToWriteRegisterFile_WriteBack),
                .addressWriteRegisterFile_WriteBack(addressWriteRegisterFile_WriteBack),
                //To hazard unit and Decode
                .enableWriteRegisterFile_WriteBack(enableWriteRegisterFile_WriteBack)
        );


        DataForwardingUnitMIPS ForwardingUnitMIPS
        (
                //From Decode
                .addressReadARegisterFile_Decode(addressReadARegisterFile_Decode),
                .addressReadBRegisterFile_Decode(addressReadBRegisterFile_Decode),
                .enableWriteDataMemory_Decode(enableWriteDataMemory_Decode),
                //From Execute
                .enableWriteRegisterFile_Execute(enableWriteRegisterFile_Execute),
                .addressWriteRegisterFile_Execute(addressWriteRegisterFile_Execute),
                .resultALU_Execute(resultALU_Execute),
                        //Memory read to write
                .enableWriteDataMemory_Execute(enableWriteDataMemory_Execute),
                .addressReadBRegisterFile_Execute(addressReadBRegisterFile_Execute),
                .addressWriteDataMemory_Execute(addressWriteDataMemory_Execute),
                //From Memory Access
                .enableWriteRegisterFile_MemoryAccess(enableWriteRegisterFile_MemoryAccess),
                .addressWriteRegisterFile_MemoryAccess(addressWriteRegisterFile_MemoryAccess),
                .dataToWriteRegisterFile_WriteBack(dataToWriteRegisterFile_WriteBack), 
                        //Memory read to write
                .enableReadDataMemory_MemoryAccess(enableReadDataMemory_MemoryAccess),

                //Foward A
                .fowardADataALU_FowardingUnit(fowardADataALU_FowardingUnit),
                //Foward B
                .fowardBDataALU_FowardingUnit(fowardBDataALU_FowardingUnit),
                //Foward data memory read to write
                .fowardDataToWriteDataMemory_FowardingUnit(fowardDataToWriteDataMemory_FowardingUnit),
                //Enable foward unit
                .controlSignalFowardA_FowardingUnit(controlSignalFowardA_FowardingUnit),
                .controlSignalFowardB_FowardingUnit(controlSignalFowardB_FowardingUnit),
                        //Memory read to write
                .controlSignalFowardDataReadDataMemory_FowardingUnit(controlSignalFowardDataReadDataMemory_FowardingUnit) 
        );

        HazardUnitMIPS HazardUnitMIPS
        (
                .clock(clock),
                .resetMachine(resetMachine),
                //Memory load hazard -----------------------------------
                //From Decode
                .enableReadDataMemory_Decode(enableReadDataMemory_Decode),
                .addressWriteRegisterFile_Decode(addressWriteRegisterFile_Decode),
                .enableWriteDataMemory_Decode(enableWriteDataMemory_Decode),
                //From Fetch
                .instruction_Fetch(instruction_Fetch),
                //From execute
                .enableReadDataMemory_Execute(enableReadDataMemory_Execute),
                .addressWriteRegisterFile_Execute(addressWriteRegisterFile_Execute),
                //From memory access
                .enableReadDataMemory_MemoryAccess(enableReadDataMemory_MemoryAccess),
                .addressWriteRegisterFile_MemoryAccess(addressWriteRegisterFile_MemoryAccess),
                .enableWriteRegisterFile_MemoryAccess(enableWriteRegisterFile_MemoryAccess),
                //To fetch
                        //Program counter
                .enableProgramCounter_HazardUnit(enableProgramCounter_HazardUnit),
                        //Filp flop Fetch
                .enableFetch_HazardUnit(enableFetch_HazardUnit),
                //To Decode
                .controlSignalSendNoOperation_HazardUnit(controlSignalSendNoOperation_HazardUnit),
                //Jump hazard ------------------------------------------
                //From Decode
                .enableJumpProgramCounter_Decode(enableJumpProgramCounter_Decode),
                //To Fetch
                .flushFetch_HazardUnit(flushFetch_HazardUnit),
                //Branch taken
                //From Execute
                .enableBranchProgramCounter_Execute(enableBranchProgramCounter_Execute),
                .flushDecode_HazardUnit(flushDecode_HazardUnit)

        );
        
endmodule : WrapperMIPS