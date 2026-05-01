// Multiple PUF Instances Testbench
// This testbench simulates multiple PUF instances (chips) with different
// manufacturing variations to evaluate:
// Inter-chip variation (uniqueness)
// Challenge-Response Pair (CRP) collection

`timescale 1ns / 1ps

module arbiterPUF_multi_tb;
    parameter NUM_CHIPS = 10;
    parameter NUM_CHALLENGES = 1000; // Large sample size for good stats
    
    reg trigger;
    reg [31:0] challenge;
    wire [NUM_CHIPS-1:0] responses;
    
    // File handler
    integer f;
    integer i, j;
    
    // Instantiate 10 PUF instances with DIFFERENT SEEDS
    arbiterPUF #(.STAGES(32), .SEED(1001)) c0 (.trigger(trigger), .challenge(challenge), .response(responses[0]));
    arbiterPUF #(.STAGES(32), .SEED(2002)) c1 (.trigger(trigger), .challenge(challenge), .response(responses[1]));
    arbiterPUF #(.STAGES(32), .SEED(3003)) c2 (.trigger(trigger), .challenge(challenge), .response(responses[2]));
    arbiterPUF #(.STAGES(32), .SEED(4004)) c3 (.trigger(trigger), .challenge(challenge), .response(responses[3]));
    arbiterPUF #(.STAGES(32), .SEED(5005)) c4 (.trigger(trigger), .challenge(challenge), .response(responses[4]));
    arbiterPUF #(.STAGES(32), .SEED(6006)) c5 (.trigger(trigger), .challenge(challenge), .response(responses[5]));
    arbiterPUF #(.STAGES(32), .SEED(7007)) c6 (.trigger(trigger), .challenge(challenge), .response(responses[6]));
    arbiterPUF #(.STAGES(32), .SEED(8008)) c7 (.trigger(trigger), .challenge(challenge), .response(responses[7]));
    arbiterPUF #(.STAGES(32), .SEED(9009)) c8 (.trigger(trigger), .challenge(challenge), .response(responses[8]));
    arbiterPUF #(.STAGES(32), .SEED(1010)) c9 (.trigger(trigger), .challenge(challenge), .response(responses[9]));

    initial begin
        $display("========================================");
        $display("  Generating Multi-Chip Data");
        $display("========================================");
        
        // OPEN FILE: No path, saves to sim directory
        f = $fopen("multi_puf_data.txt", "w");
        
        trigger = 0;
        
        for (i = 0; i < NUM_CHALLENGES; i = i + 1) begin
            // 1. New Random Challenge
            challenge = $random;
            trigger = 0;
            #20;
            
            // 2. Fire Trigger
            trigger = 1; 
            #100; // Wait for race to finish
            
            // 3. Write to File
            // Format: Challenge Chip0 Chip1 ... Chip9
            $fwrite(f, "%h", challenge);
            for (j = 0; j < NUM_CHIPS; j = j + 1) begin
                $fwrite(f, " %b", responses[j]);
            end
            $fwrite(f, "\n");
            
            trigger = 0;
            
            if (i % 100 == 0) $display("Processed %0d/%0d challenges...", i, NUM_CHALLENGES);
        end
        
        $fclose(f);
        $display("\nSUCCESS: multi_puf_data.txt generated.");
        $display("Move this file to your 'data' folder before running Python scripts.");
        $finish;
    end
endmodule