module DecodeMIPS 
        (
                input logic clock,
                input logic resetMachine,
                //From Fetch
                input logic [31:0] programCounterPlus4_Fetch,
                input logic [31:0] instruction_Fetch,
                //To fetch
                output logic enableJumpProgramCounter_Decode,
                output logic [31:0] nextProgramCounterJump_Decode,
                //From Write back
                input logic [31:0] dataToWriteRegisterFile_WriteBack,
                input logic enableWriteRegisterFile_WriteBack,
                input logic [4:0] addressWriteRegisterFile_WriteBack,
                //From hazard unit
                input logic controlSignalSendNoOperation_HazardUnit,
                input logic flushDecode_HazardUnit,
                //To Execute
                        //Decoder
                output logic enableAndBranchProgramCounter_Decode,
                output logic enableReadDataMemory_Decode,                
                output logic enableWriteDataMemory_Decode,
                output logic controlSignalIsSignExtendedALU_Decode,
                output logic [1:0] opCodeALU_Decode,
                        //Register file
                output logic enableWriteRegisterFile_Decode,
                output logic [4:0] addressWriteRegisterFile_Decode,
                output logic [4:0] addressReadARegisterFile_Decode,
                output logic [31:0] dataReadARegisterFile_Decode,
                output logic [4:0] addressReadBRegisterFile_Decode,
                output logic [31:0] dataReadBRegisterFile_Decode,
                output logic controlSignalWriteFromDataMemoryRegisterFile_Decode,
                        //Instruction
                output logic [31:0] instruction_Decode,
                output logic [31:0] resultSignExtender_Decode,
                output logic [31:0] programCounterPlus4_Decode
        );

        //Register file
        logic controlSignalIsInstructionTypeRRegisterFile;
        logic [4:0] addressWriteRegisterFile;
        logic enableWriteRegisterFile;
        logic [4:0] addressReadARegisterFile;
        logic [4:0] addressReadBRegisterFile;
        logic [31:0] dataReadARegisterFile;
        logic [31:0] dataReadBRegisterFile;
        //Sign extender
        logic [31:0] resultSignExtender;
        logic [31:0] nextProgramCounterJump;
        //ALU
        logic [1:0] opCodeALU;
        
        logic resetFlipFlop_Decode;

        //Address to read
        assign addressReadARegisterFile = instruction_Fetch [25:21];
        assign addressReadBRegisterFile = instruction_Fetch [20:16];

        Decoder Decoder
        (
                //inputs
                .opCodeDecoder(instruction_Fetch [31:26]),
                .resetMachine(resetMachine),
                //Outputs
                .enableAndBranchProgramCounter(enableAndBranchProgramCounter),
                .enableReadDataMemory(enableReadDataMemory),
                .controlSignalWriteFromDataMemoryRegisterFile(controlSignalWriteFromDataMemoryRegisterFile),
                .enableWriteDataMemory(enableWriteDataMemory),
                .controlSignalIsSignExtendedALU(controlSignalIsSignExtendedALU),
                .enableWriteRegisterFile(enableWriteRegisterFile),
                .controlSignalIsInstructionTypeRRegisterFile(controlSignalIsInstructionTypeRRegisterFile),
                .enableJumpProgramCounter(enableJumpProgramCounter),
                .opCodeALU(opCodeALU) 
        );

        Mux2To1 #(.WIDTH(5)) MuxRegisterFile 
        (
                //inputs
                .dataIn0_Mux2To1(instruction_Fetch [20:16]),
                .dataIn1_Mux2To1(instruction_Fetch [15:11]),
                .selector_Mux2To1(controlSignalIsInstructionTypeRRegisterFile),
                //output
                .dataOut_Mux2To1(addressWriteRegisterFile)
        );

        RegisterFile RegisterFile
        (
                //inputs
                .clock(clock),
                .reset(resetMachine),
                .addressReadARegisterFile(addressReadARegisterFile),
                .addressReadBRegisterFile(addressReadBRegisterFile),
                .addressWriteRegisterFile(addressWriteRegisterFile_WriteBack),
                .enableWriteRegisterFile(enableWriteRegisterFile_WriteBack),
                .enableReadARegisterFile('1),
                .enableReadBRegisterFile('1),
                .dataToWriteRegisterFile(dataToWriteRegisterFile_WriteBack),
                //outputs
                .dataReadARegisterFile(dataReadARegisterFile),
                .dataReadBRegisterFile(dataReadBRegisterFile)
        );

        SignExtender SignExtenderALU
        (
                .dataInSignExtender(instruction_Fetch[15:0]),
                .dataOutSignExtender(resultSignExtender)
        );

        assign enableJumpProgramCounter_Decode = (resetMachine) ? 0: enableJumpProgramCounter;
        assign nextProgramCounterJump_Decode = (resetMachine) ? 0: (enableJumpProgramCounter_Decode) ? {programCounterPlus4_Fetch[31:28], instruction_Fetch[25:0]}<<2 : 0;

        assign resetFlipFlop_Decode = controlSignalSendNoOperation_HazardUnit | flushDecode_HazardUnit;

        always @ (posedge clock, posedge resetMachine) begin
                if (resetMachine) begin
                        //To execute
                        enableAndBranchProgramCounter_Decode <= 0;
                        enableReadDataMemory_Decode <= 0;                
                        controlSignalWriteFromDataMemoryRegisterFile_Decode <= 0;
                        enableWriteDataMemory_Decode <= 0;
                        controlSignalIsSignExtendedALU_Decode <= 0;
                        opCodeALU_Decode <= 0;
                        //Register file
                        enableWriteRegisterFile_Decode <= 0;
                        addressWriteRegisterFile_Decode <= 0;
                        addressReadARegisterFile_Decode <= 0;
                        dataReadARegisterFile_Decode <= 0;
                        addressReadBRegisterFile_Decode <= 0;
                        dataReadBRegisterFile_Decode <= 0;
                        //Instruction
                        instruction_Decode <= 0;
                        resultSignExtender_Decode <= 0;
                        programCounterPlus4_Decode <= 0;
                end
                else if (resetFlipFlop_Decode) begin
                        //To execute
                        enableAndBranchProgramCounter_Decode <= 0;
                        enableReadDataMemory_Decode <= 0;                
                        controlSignalWriteFromDataMemoryRegisterFile_Decode <= 0;
                        enableWriteDataMemory_Decode <= 0;
                        controlSignalIsSignExtendedALU_Decode <= 0;
                        opCodeALU_Decode <= 0;
                        //Register file
                        enableWriteRegisterFile_Decode <= 0;
                        addressWriteRegisterFile_Decode <= 0;
                        addressReadARegisterFile_Decode <= 0;
                        dataReadARegisterFile_Decode <= 0;
                        addressReadBRegisterFile_Decode <= 0;
                        dataReadBRegisterFile_Decode <= 0;
                        //Instruction
                        instruction_Decode <= 0;
                        resultSignExtender_Decode <= 0;
                        programCounterPlus4_Decode <= 0;
                end
                else begin
                        //To execute
                        enableAndBranchProgramCounter_Decode <= enableAndBranchProgramCounter;
                        enableReadDataMemory_Decode <= enableReadDataMemory;                
                        controlSignalWriteFromDataMemoryRegisterFile_Decode <= controlSignalWriteFromDataMemoryRegisterFile;
                        enableWriteDataMemory_Decode <= enableWriteDataMemory;
                        controlSignalIsSignExtendedALU_Decode <= controlSignalIsSignExtendedALU;
                        opCodeALU_Decode <= opCodeALU;
                        //Register file
                        enableWriteRegisterFile_Decode <= enableWriteRegisterFile;
                        addressWriteRegisterFile_Decode <= addressWriteRegisterFile;
                        addressReadARegisterFile_Decode <= addressReadARegisterFile;
                        dataReadARegisterFile_Decode <= dataReadARegisterFile;
                        addressReadBRegisterFile_Decode <= addressReadBRegisterFile;
                        dataReadBRegisterFile_Decode <= dataReadBRegisterFile;
                        //Instruction
                        instruction_Decode <= instruction_Fetch;
                        resultSignExtender_Decode <= resultSignExtender;
                        programCounterPlus4_Decode <= programCounterPlus4_Fetch;
                end 
        end
        
endmodule : DecodeMIPS