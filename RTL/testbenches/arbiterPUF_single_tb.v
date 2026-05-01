// Comprehensive Single PUF Instance Testbench
// This testbench thoroughly tests a single PUF instance with:
// Multiple random challenges
// Reliability testing (same challenge multiple times)
// Data collection for analysis

`timescale 1ns / 1ps

module arbiterPUF_single_tb;
    reg trigger;
    reg [31:0] challenge;
    wire response;
    
    // File handler
    integer f;
    integer i, j;
    reg [31:0] current_chal;
    
    // Single instance
    arbiterPUF #(.STAGES(32), .SEED(12345)) dut (
        .trigger(trigger),
        .challenge(challenge),
        .response(response)
    );
    
    initial begin
        $display("========================================");
        $display("  Generating Reliability Data");
        $display("========================================");
        
        // OPEN FILE: No path, saves to sim directory
        f = $fopen("single_puf_data.txt", "w");
        
        trigger = 0;

        // Test 100 random challenges, 15 times each
        for (i = 0; i < 100; i = i + 1) begin
            current_chal = $random;
            
            for (j = 0; j < 15; j = j + 1) begin
                challenge = current_chal;
                trigger = 0;
                #20;
                
                trigger = 1; // Fire!
                #100;
                
                // Write Format: Challenge Response TestNumber
                $fwrite(f, "%h %b %0d\n", challenge, response, j);
                
                trigger = 0;
            end
        end
        
        $fclose(f);
        $display("\nSUCCESS: single_puf_data.txt generated.");
        $display("Move this file to your 'data' folder before running Python scripts.");
        $finish;
    end
endmodule