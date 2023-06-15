module FetchMIPS
        (
                input logic clock,
                input logic resetMachine,
                //ProgramCounter
                        //From decode
                input logic enableJumpProgramCounter_Decode,
                input logic [31:0] nextProgramCounterJump_Decode,
                        //From Execute
                input  logic enableBranchProgramCounter_Execute,
                input  logic [31:0] nextProgramCounterBranch_Execute,
                //From Hazard Unit
                input logic enableProgramCounter_HazardUnit,
                input logic enableFetch_HazardUnit,
                input logic flushFetch_HazardUnit,
                        //To Decode
                output logic [31:0] programCounterPlus4_Fetch,
                output logic [31:0] instruction_Fetch
        );

        logic [31:0] programCounter;
        logic [31:0] nextProgramCounter;
        logic [31:0] nextProgramCounterAux;
        logic [31:0] instruction;

        Mux2To1 MuxProgramCounterJump_Fetch
        (
                //inputs
                .dataIn0_Mux2To1((programCounter + 4)),
                .dataIn1_Mux2To1(nextProgramCounterJump_Decode),
                .selector_Mux2To1(enableJumpProgramCounter_Decode),
                //output
                .dataOut_Mux2To1(nextProgramCounterAux)
        );

        Mux2To1 MuxProgramCounterBranch_Fetch
        (
                //inputs
                .dataIn0_Mux2To1(nextProgramCounterAux),
                .dataIn1_Mux2To1(nextProgramCounterBranch_Execute),
                .selector_Mux2To1(enableBranchProgramCounter_Execute),
                //output
                .dataOut_Mux2To1(nextProgramCounter)
        );

        FlipFlopD ProgramCounter
        (
                //inputs
                .clock(clock),
                .resetFlipFlopD(resetMachine),
                .enableFlipFlopD(enableProgramCounter_HazardUnit),
                .dataInFlipFlopD(nextProgramCounter),
                //output
                .dataOutFlipFlopD(programCounter)
        );

        GenericMemory InstructionMemory 
        (
	        .clock('0),
                .addressReadGenericMemory(programCounter>>2),
	        .addressWriteGenericMemory('0),	 
                .enableReadGenericMemory('1),
	        .enableWriteGenericMemory('0),
                .dataInGenericMemory('0),
                .dataOutGenericMemory(instruction)
        );

        always @ (posedge clock, posedge resetMachine) begin
                if (resetMachine) begin
                        instruction_Fetch <= 0;
                        programCounterPlus4_Fetch <= 0;
                end
                else if (flushFetch_HazardUnit) begin
                        instruction_Fetch <= 0;
                        programCounterPlus4_Fetch <= 0;
                end
                else if (enableFetch_HazardUnit) begin
                        programCounterPlus4_Fetch <= programCounter + 4;
                        instruction_Fetch <= instruction;
                end
        end
        
endmodule : FetchMIPS