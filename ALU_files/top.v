module alu_top (
    input clk,
    input rst,
    input [1:0] op, //00 add 01 sub 10 mul 11 div
    input start,
    input [7:0] inbus, // Unicul input de date
    output final,
    output [15:0] outbus,
    output [3:0] state,
    output[7:0] A,// debug stuff
    output[7:0] Q,// debug stuff
    output[7:0] M,// debug stuff
    output wire ready,
    output wire c3_debug,
    output [1:0] op_latched_debug
);
    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, internal_rst;
    wire cnt_ok;
    wire q0,qminus1;
    wire a7;
    
    arithmetic_unit arith_unit (
        .clk(clk),
        .rst(rst),
        .inbus(inbus),
        .op(op),
        .cnt_ok(cnt_ok),
        .c0(c0), 
        .c1(c1),
        .c2(c2),
        .c3(c3), 
        .c4(c4),
        .c5(c5), 
        .c6(c6), 
        .c7(c7), 
        .c8(c8), 
        .c9(c9), 
        .c10(c10),
        .outbus(outbus),
        .q0(q0),
        .qminus1(qminus1),
        .a7(a7),
        .internal_rst(internal_rst),
        .AQM_debug({A, Q, M})
    );
    
    control_unit cu (
        .clk(clk),
        .rst(rst),
        .op(op),
        .cnt_ok(cnt_ok),
        .q0(q0),
        .qminus1(qminus1),
        .a7(a7),
        .start(start),
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4),
        .c5(c5),
        .c6(c6),
        .c7(c7),
        .c8(c8),
        .c9(c9),
        .c10(c10),
        .internal_rst(internal_rst),
        .final(final),
        .state(state),
        .ready(ready),
        .c3_debug(c3_debug),
        .op_latched_debug(op_latched_debug)
    );

endmodule
