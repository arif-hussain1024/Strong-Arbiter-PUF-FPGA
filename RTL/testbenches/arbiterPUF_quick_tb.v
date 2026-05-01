// Quick Verification Testbench
// Simple testbench to verify basic PUF functionality

`timescale 1ns / 1ps

module arbiterPUF_quick_tb;

    parameter STAGES = 32;
    
    reg start;
    reg [STAGES-1:0] challenge;
    wire response;
    
    // Instantiate PUF
    arbiterPUF #(
        .STAGES(STAGES),
        .SEED(42)
    ) dut (
        .start(start),
        .challenge(challenge),
        .response(response)
    );
    
    initial begin
        $display("Time\t\tChallenge\t\t\t\t\tResponse");
        $display("====\t\t=========\t\t\t\t\t========");
        
        start = 0;
        challenge = 0;
        #20;
        
        // Test 1: All zeros
        challenge = 32'h00000000;
        #10 start = 1; #10 start = 0; #100;
        $display("%0t\t%h\t%b", $time, challenge, response);
        
        // Test 2: All ones
        challenge = 32'hFFFFFFFF;
        #10 start = 1; #10 start = 0; #100;
        $display("%0t\t%h\t%b", $time, challenge, response);
        
        // Test 3: Alternating pattern
        challenge = 32'hAAAAAAAA;
        #10 start = 1; #10 start = 0; #100;
        $display("%0t\t%h\t%b", $time, challenge, response);
        
        // Test 4: Inverted alternating
        challenge = 32'h55555555;
        #10 start = 1; #10 start = 0; #100;
        $display("%0t\t%h\t%b", $time, challenge, response);
        
        // Test 5-10: Random patterns
        repeat(6) begin
            challenge = $random;
            #10 start = 1; #10 start = 0; #100;
            $display("%0t\t%h\t%b", $time, challenge, response);
        end
        
        $display("\nQuick test complete!");
        $finish;
    end

endmodule
