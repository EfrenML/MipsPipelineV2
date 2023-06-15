module ExecuteMIPS 
        (
                input clock,
                input resetMachine,
                //From Execute
                        //Decoder
                input logic enableAndBranchProgramCounter_Decode,
                input logic enableReadDataMemory_Decode,                
                input logic enableWriteDataMemory_Decode,
                input logic controlSignalIsSignExtendedALU_Decode,
                input logic [1:0] opCodeALU_Decode,
                        //Register file
                input logic [31:0] dataReadARegisterFile_Decode,
                input logic [31:0] dataReadBRegisterFile_Decode,
                input logic controlSignalWriteFromDataMemoryRegisterFile_Decode,
                input logic enableWriteRegisterFile_Decode,
                input logic [4:0] addressWriteRegisterFile_Decode,
                        //Instruction
                input logic [31:0] instruction_Decode,
                input logic [31:0] resultSignExtender_Decode,
                input logic [31:0] programCounterPlus4_Decode,
                //From Data Forwarding Unit
                input logic [31:0] fowardADataALU_FowardingUnit,
                input logic [31:0] fowardBDataALU_FowardingUnit,
                input logic controlSignalFowardA_FowardingUnit,
                input logic controlSignalFowardB_FowardingUnit,
                //To Memory access
                        //Register file
                output logic enableWriteRegisterFile_Execute,
                output logic [4:0] addressWriteRegisterFile_Execute,
                output logic controlSignalWriteFromDataMemoryRegisterFile_Execute,
                        //Program counter
                output logic enableBranchProgramCounter_Execute,
                output logic [31:0] nextProgramCounterBranch_Execute,
                        //ALU
                output logic [31:0] resultALU_Execute,
                        //Data memory
                output logic enableReadDataMemory_Execute,            
                output logic enableWriteDataMemory_Execute,
                output logic [31:0] dataToWriteDataMemory_Execute,
                        //Intruction
                output logic [31:0] instruction_Execute,
                //To Data Fowarding Unit
                output logic [4:0] addressReadBRegisterFile_Execute,
                output logic [31:0] addressWriteDataMemory_Execute
        );

        //Mux 2 to 1 Sign extender
        logic [31:0] dataReadBMuxSignExtended;
        //ALU
        logic [3:0] controlOpALU;
        logic [31:0] resultALU;
        logic isZeroResultALU;
        //Program counter
        logic enableBranchProgramCounter;
        logic [31:0] nextProgramCounterBranch;
        logic controlSignalIsJumpOrBranch;
        //Mux 2 to 1 Foward unit to ALU
        logic [31:0] numberAALU;
        logic [31:0] resultFowardB;
        logic [31:0] numberBALU;

        ControlALU ControlALU
        (
                //inputs
                .opCodeALU(opCodeALU_Decode),
                .functionALU(instruction_Decode[5:0]),
                //outputs
                .controlOpALU(controlOpALU)
        );

        Mux2To1 MuxFowardUnitA
        (
                //inputs
                .dataIn0_Mux2To1(dataReadARegisterFile_Decode),
                .dataIn1_Mux2To1(fowardADataALU_FowardingUnit),
                .selector_Mux2To1(controlSignalFowardA_FowardingUnit),
                //output
                .dataOut_Mux2To1(numberAALU)
        );

        Mux2To1 MuxFowardUnitB
        (
                //inputs
                .dataIn0_Mux2To1(dataReadBRegisterFile_Decode),
                .dataIn1_Mux2To1(fowardBDataALU_FowardingUnit),
                .selector_Mux2To1(controlSignalFowardB_FowardingUnit),
                //outputs
                .dataOut_Mux2To1(resultFowardB)
        );

        Mux2To1 MuxSignExtender
        (
                //inputs
                .dataIn0_Mux2To1(resultFowardB),
                .dataIn1_Mux2To1(resultSignExtender_Decode),
                .selector_Mux2To1(controlSignalIsSignExtendedALU_Decode),
                //outputs
                .dataOut_Mux2To1(numberBALU)
        );

        ALU ALU
        (
                //inputs
                .controlOpALU(controlOpALU),
                .numberAALU(numberAALU),
                .numberBALU(numberBALU),
                //outputs
                .resultALU(resultALU),
                .isZeroResultALU(isZeroResultALU)
        );

        assign addressWriteDataMemory_Execute = resultALU;

        //Branch
        assign enableBranchProgramCounter_Execute = isZeroResultALU && enableAndBranchProgramCounter_Decode;
        assign nextProgramCounterBranch_Execute = (resetMachine) ? 0:
                                        (enableBranchProgramCounter_Execute) ? programCounterPlus4_Decode + (resultSignExtender_Decode<<2):
                                        0;

        always @ (posedge clock, posedge resetMachine) begin
                if (resetMachine) begin
                        //ALU
                        resultALU_Execute <= 0;
                        //Data memory
                        enableReadDataMemory_Execute <= 0;
                        enableWriteDataMemory_Execute <= 0;
                        dataToWriteDataMemory_Execute <= 0;
                        controlSignalWriteFromDataMemoryRegisterFile_Execute <= 0;
                        //Register file
                        enableWriteRegisterFile_Execute <= 0;
                        addressWriteRegisterFile_Execute <= 0;
                        instruction_Execute <= 0;
                        //Data Fowarding Unit
                        addressReadBRegisterFile_Execute <= 0;
                end   
                else begin
                        //ALU
                        resultALU_Execute <= resultALU;
                        //Data memory
                        enableReadDataMemory_Execute <= enableReadDataMemory_Decode;
                        enableWriteDataMemory_Execute <= enableWriteDataMemory_Decode;
                        dataToWriteDataMemory_Execute <= dataReadBRegisterFile_Decode; //numberBALU or dataReadBMuxSignExtender
                        controlSignalWriteFromDataMemoryRegisterFile_Execute <= controlSignalWriteFromDataMemoryRegisterFile_Decode;
                        //Register file
                        enableWriteRegisterFile_Execute <= enableWriteRegisterFile_Decode;
                        addressWriteRegisterFile_Execute <= addressWriteRegisterFile_Decode;
                        instruction_Execute <= instruction_Decode;
                        //Data Fowarding Unit
                        addressReadBRegisterFile_Execute <= instruction_Decode[20:16];
                end             
        end
        

endmodule : ExecuteMIPS