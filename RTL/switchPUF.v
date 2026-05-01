//   Switch element for arbiter PUF chain. 
// Description: Switch element with conditional delays
//              Delays active in simulation, ignored in synthesis

module switchPUF #(
    parameter real TOP_DELAY = 1.0,
    parameter real BOT_DELAY = 1.0
)(
    input top_in,
    input bot_in,
    input sel,
    output top_out,
    output bot_out
);
    
    // For synthesis: pure combinational logic (delays come from physical routing)
    // For simulation: delays modeled explicitly
    `ifdef SYNTHESIS
        assign top_out = sel ? bot_in : top_in;
        assign bot_out = sel ? top_in : bot_in;
    `else
        assign #TOP_DELAY top_out = sel ? bot_in : top_in;
        assign #BOT_DELAY bot_out = sel ? top_in : bot_in;
    `endif
    
endmodule