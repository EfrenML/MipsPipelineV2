module HazardUnitMIPS 
(
        input logic clock,
        input logic resetMachine,
        //Memory load hazard -----------------------------------
        //From Decode
        input logic enableReadDataMemory_Decode,
        input logic [4:0] addressWriteRegisterFile_Decode,
        input logic enableWriteDataMemory_Decode,
        //From Fetch
        input logic [31:0] instruction_Fetch,
        //From execute
        input logic enableReadDataMemory_Execute,
        input logic [4:0] addressWriteRegisterFile_Execute,
        //From memory access
        input logic enableReadDataMemory_MemoryAccess,
        input logic [4:0] addressWriteRegisterFile_MemoryAccess,
        input logic enableWriteRegisterFile_MemoryAccess,
        //To Fetch
                //Program counter
        output logic enableProgramCounter_HazardUnit,
                //Flip flip Fetch
        output logic enableFetch_HazardUnit,
        //To Decode 
        output logic controlSignalSendNoOperation_HazardUnit,

        //Jump hazard ------------------------------------------
        //From decode
        input logic enableJumpProgramCounter_Decode,
        //To Fetch
        output logic flushFetch_HazardUnit,

        //Branch take ------------------------------------------ 
        //From Execute
        input logic enableBranchProgramCounter_Execute,
        //To Decode
        output logic flushDecode_HazardUnit
);

        localparam opCodeWriteDataMemory = 6'b1010_11;

        //From fetch
        logic [5:0] opCode_Fetch;
        logic [4:0] addressReadARegisterFile_Fetch;
        logic [4:0] addressReadBRegisterFile_Fetch;
        //Pipeline stall
        logic willLoadFromMemoryAndNotWriteInMemory;
        logic willWriteInRegisterFileAndReadFromDataMemory;
        logic willLoadFromDataMemoryAndPipelineWasStalled;
        logic stallPipeline;
        logic previousStallPipeline;

        //Conditions to check if we stall the pipeline
        assign willLoadFromDataMemoryAndNotWriteInMemory = enableReadDataMemory_Decode && ~(opCodeWriteDataMemory == opCode_Fetch);
        assign willWriteInRegisterFileAndReadFromDataMemory = enableReadDataMemory_Execute && enableWriteRegisterFile_MemoryAccess;
        assign willLoadFromDataMemoryAndPipelineWasStalled = enableReadDataMemory_MemoryAccess && previousStallPipeline;

        //Get the address to compare the data hazard
        assign opCode_Fetch = instruction_Fetch [31:26];
        assign addressReadARegisterFile_Fetch = instruction_Fetch [25:21];
        assign addressReadBRegisterFile_Fetch = instruction_Fetch [20:16];

        //Efects of pipeline stall
        assign enableProgramCounter_HazardUnit  = (enableBranchProgramCounter_Execute) ? 1 : (stallPipeline) ? 0 : 1;
        assign enableFetch_HazardUnit           = (stallPipeline) ? 0 : 1;
        assign controlSignalSendNoOperation_HazardUnit = stallPipeline;

        //Efects of the flush
        assign flushFetch_HazardUnit = enableJumpProgramCounter_Decode || enableBranchProgramCounter_Execute;
        assign flushDecode_HazardUnit = enableBranchProgramCounter_Execute;

        always @ (*) begin
                stallPipeline = 0;
                if (willLoadFromDataMemoryAndNotWriteInMemory) begin
                        if ((addressWriteRegisterFile_Decode == addressReadARegisterFile_Fetch) 
                                && (0 != addressReadARegisterFile_Fetch)) begin

                                stallPipeline = 1;
                        end
                        if ((addressWriteRegisterFile_Decode == addressReadBRegisterFile_Fetch) 
                                && (0 != addressReadBRegisterFile_Fetch)) begin

                                stallPipeline = 1;
                        end
                end 
                if (willWriteInRegisterFileAndReadFromDataMemory) begin
                        if ((addressWriteRegisterFile_MemoryAccess == addressReadARegisterFile_Fetch) 
                                && (0 != addressReadARegisterFile_Fetch)
                                && ((addressWriteRegisterFile_Execute == addressReadARegisterFile_Fetch) 
                                || (addressWriteRegisterFile_Execute == addressReadBRegisterFile_Fetch))) begin

                                stallPipeline = 1;
                        end
                        if ((addressWriteRegisterFile_MemoryAccess == addressReadBRegisterFile_Fetch) 
                                && (0 != addressReadBRegisterFile_Fetch)
                                && ((addressWriteRegisterFile_Execute == addressReadBRegisterFile_Fetch) 
                                || (addressWriteRegisterFile_Execute == addressReadARegisterFile_Fetch))) begin

                                stallPipeline = 1;
                        end
                end
                if (willLoadFromDataMemoryAndPipelineWasStalled) begin
                        if ((addressWriteRegisterFile_MemoryAccess == addressReadARegisterFile_Fetch) 
                                && (0 != addressReadARegisterFile_Fetch)) begin

                                stallPipeline = 1;
                        end
                        if ((addressWriteRegisterFile_MemoryAccess == addressReadBRegisterFile_Fetch) 
                                && (0 != addressReadBRegisterFile_Fetch)) begin

                                stallPipeline = 1;
                        end
                end  
        end

        always @ (posedge clock, posedge resetMachine) begin
                if(resetMachine) begin
                        previousStallPipeline <= 0;
                end
                else begin
                        previousStallPipeline <= stallPipeline;     
                end
        end
        
endmodule : HazardUnitMIPS