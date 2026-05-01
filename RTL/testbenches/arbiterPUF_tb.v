`timescale 1ns / 1ps

module arbiterPUF_simple_tb;

    parameter STAGES = 32;

    // Inputs
    reg start;
    reg [STAGES-1:0] challenge;

    // Output
    wire response;

    // DUT (Device Under Test)
    arbiterPUF #(.STAGES(STAGES)) dut (
        .start(start),
        .challenge(challenge),
        .response(response)
    );

    initial begin

        // Display header
        $display("Time (ns)\tChallenge\t\t\tPUF Response");

        // Initialize signals
        start = 0;
        challenge = 32'b0;
        #20;  // wait 20ns before first test

        // --- TEST 1: all zeros ---
        challenge = 32'b00000000000000000000000000000000;
        #10 start = 1;   // trigger race
        #10 start = 0;
        #30;             // wait to observe response
        $display("%0t\t%b\t%b", $time, challenge, response);

        // --- TEST 2: all ones ---
        challenge = 32'b11111111111111111111111111111111;
        #10 start = 1;
        #10 start = 0;
        #30;
        $display("%0t\t%b\t%b", $time, challenge, response);

        // --- TEST 3: alternating bits ---
        challenge = 32'b10101010101010101010101010101010;
        #10 start = 1;
        #10 start = 0;
        #30;
        $display("%0t\t%b\t%b", $time, challenge, response);

        // --- TEST 4: alternating inverted bits ---
        challenge = 32'b01010101010101010101010101010101;
        #10 start = 1;
        #10 start = 0;
        #30;
        $display("%0t\t%b\t%b", $time, challenge, response);

        // --- TEST 5: random pattern ---
        challenge = 32'b11001100110011001100110011001100;
        #10 start = 1;
        #10 start = 0;
        #30;
        $display("%0t\t%b\t%b", $time, challenge, response);

        // End simulation
        $finish;
    end

endmodule
