module control_unit (
    input clk,
    input rst,
    input start,
    input [1:0] op,
    input q0, qminus1,
    input a7,
    input cnt_ok,

    output c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
    output internal_rst,
    output final,
    output ready,
    output [3:0] state,
    output c3_debug,
    output [1:0] op_latched_debug
);

    

    wire [3:0] state_curr;
    wire [3:0] state_next_add_sub, state_next_mul, state_next_div;

    assign state = state_curr;
    
    // === Latch op la start ===
    reg [1:0] op_latched;
    always @(posedge clk or posedge rst) begin
        if (rst)
            op_latched <= 2'b00;
        else if (start && state_curr == 4'd0) begin
            op_latched <= op; 
        end
    end
    assign op_latched_debug = op_latched;
    assign c3_debug = c3;

    // === Instan?iere FSM-uri ===
    wire c0_add_sub, c1_add_sub, c2_add_sub, c3_add_sub, c4_add_sub, c5_add_sub, c6_add_sub, c7_add_sub, c8_add_sub, c9_add_sub, c10_add_sub;
    wire c0_mul, c1_mul, c2_mul, c3_mul, c4_mul, c5_mul, c6_mul, c7_mul, c8_mul, c9_mul, c10_mul;
    wire c0_div, c1_div, c2_div, c3_div, c4_div, c5_div, c6_div, c7_div, c8_div, c9_div, c10_div;

    wire ready_add_sub, ready_mul, ready_div;

    // === ADD/SUB FSM ===
    add_sub_fsm add_sub_unit (
        .clk(clk),
        .rst(rst),
        .enable(op_latched[1] == 0),
        .start(start),
        .op_bit(op_latched[0]),
        .state_curr(state_curr),
        .state_next(state_next_add_sub),
        .c0(c0_add_sub), .c1(c1_add_sub), .c2(c2_add_sub), .c3(c3_add_sub),
        .c4(c4_add_sub), .c5(c5_add_sub), .c6(c6_add_sub), .c7(c7_add_sub),
        .c8(c8_add_sub), .c9(c9_add_sub), .c10(c10_add_sub),
        .ready(ready_add_sub)
    );

    // === MUL FSM ===
    mul_fsm mul_unit (
        .clk(clk),
        .rst(rst),
        .enable(op_latched == 2'b10),
        .start(start),
        .q0(q0),
        .qminus1(qminus1),
        .a7(a7),
        .cnt_ok(cnt_ok),
        .state_curr(state_curr),
        .state_next(state_next_mul),
        .c0(c0_mul), .c1(c1_mul), .c2(c2_mul), .c3(c3_mul),
        .c4(c4_mul), .c5(c5_mul), .c6(c6_mul), .c7(c7_mul),
        .c8(c8_mul), .c9(c9_mul), .c10(c10_mul),
        .ready(ready_mul)
    );

    // === DIV FSM ===
    div_fsm div_unit (
        .clk(clk),
        .rst(rst),
        .enable(op_latched == 2'b11),
        .start(start),
        .a7(a7),
        .cnt_ok(cnt_ok),
        .state_curr(state_curr),
        .state_next(state_next_div),
        .c0(c0_div), .c1(c1_div), .c2(c2_div), .c3(c3_div),
        .c4(c4_div), .c5(c5_div), .c6(c6_div), .c7(c7_div),
        .c8(c8_div), .c9(c9_div), .c10(c10_div),
        .ready(ready_div)
    );

    // === Select FSM activ ===
    assign ready = (op_latched[1] == 0)  ? ready_add_sub :
                   (op_latched == 2'b10) ? ready_mul :
                   (op_latched == 2'b11) ? ready_div :
                   1'b0;

    // === Stare curent? ===
    reg4bit state_reg (
        .clk(clk),
        .rst(rst),
        .load(1'b1),
        .d((op_latched[1] == 0)  ? state_next_add_sub :
           (op_latched == 2'b10) ? state_next_mul :
           (op_latched == 2'b11) ? state_next_div :
           4'b0000),
        .q(state_curr)
    );
    
    wire [3:0] state_next_selected =
    (op_latched[1] == 0)  ? state_next_add_sub :
    (op_latched == 2'b10) ? state_next_mul :
    (op_latched == 2'b11) ? state_next_div :
    4'b0000;





    // === Multiplexare semnale de control ===
    assign c0  = (op_latched[1] == 0) ? c0_add_sub :
                 (op_latched == 2'b10) ? c0_mul :
                 (op_latched == 2'b11) ? c0_div : 1'b0;

    assign c1  = (op_latched[1] == 0) ? c1_add_sub :
                 (op_latched == 2'b10) ? c1_mul :
                 (op_latched == 2'b11) ? c1_div : 1'b0;

    assign c2  = (op_latched[1] == 0) ? c2_add_sub :
                 (op_latched == 2'b10) ? c2_mul :
                 (op_latched == 2'b11) ? c2_div : 1'b0;

    assign c3  = (op_latched[1] == 0) ? c3_add_sub :
                 (op_latched == 2'b10) ? c3_mul :
                 (op_latched == 2'b11) ? c3_div : 1'b0;

    assign c4  = (op_latched == 2'b10) ? c4_mul :
                 (op_latched == 2'b11) ? c4_div : 1'b0;

    assign c5  = (op_latched[1] == 0) ? c5_add_sub :
                 (op_latched == 2'b10) ? c5_mul :
                 (op_latched == 2'b11) ? c5_div : 1'b0;

    assign c6  = (op_latched[1] == 0) ? c6_add_sub :
                 (op_latched == 2'b10) ? c6_mul :
                 (op_latched == 2'b11) ? c6_div : 1'b0;

    assign c7  = (op_latched[1] == 0) ? c7_add_sub :
                 (op_latched == 2'b10) ? c7_mul :
                 (op_latched == 2'b11) ? c7_div : 1'b0;

    assign c8  = (op_latched[1] == 0) ? c8_add_sub :
                 (op_latched == 2'b10) ? c8_mul :
                 (op_latched == 2'b11) ? c8_div : 1'b0;

    assign c9  = (op_latched[1] == 0) ? c9_add_sub :
                 (op_latched == 2'b10) ? c9_mul :
                 (op_latched == 2'b11) ? c9_div : 1'b0;

    assign c10 = (op_latched[1] == 0) ? c10_add_sub :
                 (op_latched == 2'b10) ? c10_mul :
                 (op_latched == 2'b11) ? c10_div : 1'b0;

    // === Final FSMs ===
    wire is_addsub_done = (op_latched[1] == 0)  && (state_curr == 4'd4);
    wire is_mul_done    = (op_latched == 2'b10) && (state_curr == 4'd8);
    wire is_div_done    = (op_latched == 2'b11) && (state_curr == 4'd8);

    assign final = is_addsub_done | is_mul_done | is_div_done;

    // === Reset intern pentru AQ etc. ===
    assign internal_rst = (state_curr == 4'd0);

endmodule
