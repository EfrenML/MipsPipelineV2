module Decoder 
        (
                input logic [5:0] opCodeDecoder,
                input logic resetMachine,
                output logic enableAndBranchProgramCounter,
                output logic enableReadDataMemory,
                output logic controlSignalWriteFromDataMemoryRegisterFile,
                output logic enableWriteDataMemory,
                output logic controlSignalIsSignExtendedALU,
                output logic enableWriteRegisterFile,
                output logic controlSignalIsInstructionTypeRRegisterFile,
                output logic enableJumpProgramCounter,
                // 00 -> Suma |||| 01 -> Resta |||| 10 -> functionALU |||| 11 -> Bitwise or
                output logic [1:0] opCodeALU     
        );

        logic [9:0] auxDecoder;

        always @ (*) begin
                if (resetMachine)
                        auxDecoder = 10'b0000_0000_00;
                else 
                        case (opCodeDecoder)
                                //eBPC eRDM cSWFDM eWDM _ cSISEALU eWRF cSIITR eJPC _ opCALU
                                6'b0000_00:  auxDecoder = 10'b0000_0110_10;     //instructiontypeR
                                6'b0010_00:  auxDecoder = 10'b0000_1100_00;     //add immediate
                                6'b1000_11:  auxDecoder = 10'b0110_1100_00;     //load word
                                6'b1010_11:  auxDecoder = 10'b0001_1000_00;     //store word
                                6'b0000_10:  auxDecoder = 10'b0000_0001_00;     //jump
                                6'b0001_00:  auxDecoder = 10'b1000_0000_01;     //branch on equal
                                6'b0011_01:  auxDecoder = 10'b0000_1100_11;     //bitwise or immediate
                                default: auxDecoder = 10'b0000_0000_00;
                        endcase
        end

        assign enableAndBranchProgramCounter                    = auxDecoder[9];
        assign enableReadDataMemory                             = auxDecoder[8];
        assign controlSignalWriteFromDataMemoryRegisterFile     = auxDecoder[7];
        assign enableWriteDataMemory                            = auxDecoder[6];
        assign controlSignalIsSignExtendedALU                   = auxDecoder[5];
        assign enableWriteRegisterFile                          = auxDecoder[4];
        assign controlSignalIsInstructionTypeRRegisterFile      = auxDecoder[3];
        assign enableJumpProgramCounter                         = auxDecoder[2];
        assign opCodeALU                                        = auxDecoder[1:0];

        
endmodule : Decoder