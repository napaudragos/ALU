module arithmetic_unit (
    input clk,
    input rst,
    input [7:0] inbus,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input c0,  // încarc? operandul în registrul M
    input c1,  // încarc? operandul în registrul Q
    input c2,  // încarc? rezultatul adderului în A
    input c3,  // semnal care selecteaz? între adunare (0) ?i sc?dere (1)
    input c4,  // activeaz? opera?ia de shift
    input c5,  // incrementeaz? contorul
    input c6,  // bit de intrare pentru shift
    input c7,  // încarca partea superioara din AQ în outbus
    input c8,  // încarca partea inferioara din AQ în outbus
    input c9,  // încarca direct operandul în A
    input c10, // forteaza Q[0] si ia valoarea din c6
    input internal_rst,

    output [15:0] outbus,
    output cnt_ok,
    output q0,
    output qminus1,
    output a7,
    output[23:0] AQM_debug
);

    wire [7:0] aq_in;
    wire [15:0] aq_out;
    wire [7:0] m_out;
    wire [7:0] add_in1, add_in2;
    wire [8:0] add_temp_result;
    wire [2:0] cnt_out;
    wire aq_bit_out;
    assign AQM_debug = {aq_out, m_out};
    // cnt_ok este activat când toti cei 3 biti ai contorului sunt 1
    assign cnt_ok = &cnt_out;

    // q0 este bitul cel mai putin semnificativ din registrul Q
    assign q0 = aq_out[0];

    // a7 este bitul cel mai semnificativ din registrul A
    assign a7 = aq_out[15];

    // selecteaz? A sau Q ca intrare în adder, în func?ie de operatie (op[1])
    assign add_in1 = op[1] ? aq_out[15:8] : aq_out[7:0];

    // al doilea operand al adderului este întotdeauna M
    assign add_in2 = m_out;

    // dac? c2 este activ, încarcam rezultatul din adder în A; altfel, încarcam inbus
    assign aq_in = c2 ? {8'b0, add_temp_result[7:0]} : {inbus, 8'b0};

    // selectam iesirea (A sau Q) în functie de c7/c8
    assign outbus = aq_out;
    wire [1:0] load_sel;
    assign load_sel = {(c2 | c9), c1}; // A ?i Q
    wire [7:0] reg_input;
    assign reg_input = (c9) ? inbus : // A
                   (c1) ? inbus : // Q
                   (c2) ? add_temp_result[7:0] : 8'b0;
    shift_reg_16 AQ (
        .clk(clk),
        .rst(rst | internal_rst),
        .in(reg_input),
        .load({(c2 | c9), c1}),
        .bit_in(c6),
        .sel({c4, ~op[0]}),
        .force_q0(c10),
        .out(aq_out),
        .bit_out(aq_bit_out)
    );

    reg1bit Qminus1 (
        .in(aq_bit_out),
        .load(c4),
        .clk(clk),
        .rst(rst | internal_rst),
        .out(qminus1)
    );

    reg_8 M (
        .clk(clk),
        .rst(rst | internal_rst),
        .in(inbus),
        .load(c0),
        .out(m_out)
    );

    rca8bit adder (
        .x(add_in1),
        .y(add_in2),
        .op(c3),
        .z(add_temp_result[7:0])
    );

    counter3bit counter (
        .clk(clk),
        .rst(rst | internal_rst),
        .incr(c5),
        .out(cnt_out)
    );
 

endmodule

