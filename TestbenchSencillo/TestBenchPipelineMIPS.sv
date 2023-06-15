module TestBenchMIPS ();

        logic clock;
        logic resetMachine;

        localparam NO_OPERATION = 32'h0000_0020;        //      add $0, $0, $0
        localparam SORT_ALGORITHM = 1'b0;

        WrapperMIPS DUT (.clock(clock), .resetMachine(resetMachine));

        initial begin
                clock = 0;
                forever begin
                        #5;
                        clock = ~clock;
                end
        end

        initial begin
                #3000;
                //$finish ();   //Para EDA
                //$dumpfile("dump.vcd");
                //$dumpvars;
                $stop(0);       //Para ModelSim
        end

        initial begin
                resetMachine = 1;
                #5;
                resetMachine = 1;
                #10;
                resetMachine = 0;

                //----Algortim-----
                if (SORT_ALGORITHM) begin
                //Load data memory for sorting algorithm
                DUT.MemoryAccessMIPS.DataMemory.memory[0] = 32'h0010_abcf;
                DUT.MemoryAccessMIPS.DataMemory.memory[1] = 32'h1042_0010;
                DUT.MemoryAccessMIPS.DataMemory.memory[2] = 32'hf000_0029;
                DUT.MemoryAccessMIPS.DataMemory.memory[3] = 32'hffff_ffff;
                DUT.MemoryAccessMIPS.DataMemory.memory[4] = 32'ha0bf_5978;
                DUT.MemoryAccessMIPS.DataMemory.memory[5] = 32'hb023_1234;
                DUT.MemoryAccessMIPS.DataMemory.memory[6] = 32'h1024_1548;
                DUT.MemoryAccessMIPS.DataMemory.memory[7] = 32'h7015_abcd;
                DUT.MemoryAccessMIPS.DataMemory.memory[8] = 32'h8000_0000;		//Número más chico
                DUT.MemoryAccessMIPS.DataMemory.memory[9] = 32'h1042_aabb;
                DUT.MemoryAccessMIPS.DataMemory.memory[11] = 32'h0000_000b;
                //Load instruction memory
			//Sorting algorithm
		DUT.FetchMIPS.InstructionMemory.memory[0]   = 32'h2000_ffff;     //start:addi $0, $0, 65535
                DUT.FetchMIPS.InstructionMemory.memory[1]   = 32'h0000_0820;     //      add $1, $0, $0
                DUT.FetchMIPS.InstructionMemory.memory[2]   = 32'h2002_0009;     //      addi $2, $0, 9
                DUT.FetchMIPS.InstructionMemory.memory[3]   = 32'h8c23_0000;     //      lw $3, 0 ($1)
                DUT.FetchMIPS.InstructionMemory.memory[4]   = 32'h1022_0006;     //loop: beq $1, $2, done
                DUT.FetchMIPS.InstructionMemory.memory[5]   = 32'h2021_0001;     //      addi $1, $1, 1
                DUT.FetchMIPS.InstructionMemory.memory[6]   = 32'h8c24_0000;     //      lw $4, 0 ($1)
                DUT.FetchMIPS.InstructionMemory.memory[7]   = 32'h0083_282a;     //      slt $5, $4, $3
                DUT.FetchMIPS.InstructionMemory.memory[8]   = 32'h10a0_fffb;     //      beq $5, $0, loop
                DUT.FetchMIPS.InstructionMemory.memory[9]   = 32'h0080_1820;     //      add $3, $4, $0
                DUT.FetchMIPS.InstructionMemory.memory[10]  = 32'h0800_0004;     //      j loop
                DUT.FetchMIPS.InstructionMemory.memory[11]  = 32'hac23_0004;     //done: sw $3, 4($1)
                DUT.FetchMIPS.InstructionMemory.memory[12]  = 32'h0800_000c;     //end:  j end
                end
                else begin
                //Load data memory for load algorithm
                DUT.MemoryAccessMIPS.DataMemory.memory[0] = 32'h0010_abcf;
                DUT.MemoryAccessMIPS.DataMemory.memory[2] = 32'hf000_0029;
                DUT.MemoryAccessMIPS.DataMemory.memory[8] = 32'h8f02_f214;
                DUT.MemoryAccessMIPS.DataMemory.memory[9] = 32'h1042_aabb;
                DUT.MemoryAccessMIPS.DataMemory.memory[10] = 32'hc0ca_c01a;
                //Load instruction memory
                        //Load algorithm
		DUT.FetchMIPS.InstructionMemory.memory[0]   = 32'h8c00_0000;     //start:lw $0, 0($0)
                DUT.FetchMIPS.InstructionMemory.memory[1]   = 32'h8c02_0008;     //      lw $2, 8($0)         
                DUT.FetchMIPS.InstructionMemory.memory[2]   = 32'h8c04_0009;     //      lw $4, 9($0)
                DUT.FetchMIPS.InstructionMemory.memory[3]   = 32'h0044_1020;     //      add $2, $2, $4
                DUT.FetchMIPS.InstructionMemory.memory[4]   = 32'h0044_1824;     //      and $3, $2, $4
                DUT.FetchMIPS.InstructionMemory.memory[5]   = 32'h8c05_000a;     //      lw $5, 10($0)
                DUT.FetchMIPS.InstructionMemory.memory[6]   = 32'h00a0_3825;     //      or $7, $5, $0
                DUT.FetchMIPS.InstructionMemory.memory[7]   = 32'h8c06_0002;     //      lw $6, 2($0)
                DUT.FetchMIPS.InstructionMemory.memory[8]   = 32'h00e6_3825;     //      or $7, $7, $6
                DUT.FetchMIPS.InstructionMemory.memory[9]   = 32'h0007_502a;     //      slt $10, $0, $7
                DUT.FetchMIPS.InstructionMemory.memory[10]  = 32'h00e0_582a;     //      slt $11, $7, $0
                DUT.FetchMIPS.InstructionMemory.memory[11]  = 32'h201f_ffff;     //      addi $31, $0, -1
                DUT.FetchMIPS.InstructionMemory.memory[12]  = 32'h0800_000e;     //      j labelOne
                DUT.FetchMIPS.InstructionMemory.memory[13]  = 32'h1000_ffff;     //labelTwo: beq $0, $0, labelTwo      
                DUT.FetchMIPS.InstructionMemory.memory[14]  = 32'h0800_000e;     //labelOne: j labalOne      
                end
        end

endmodule