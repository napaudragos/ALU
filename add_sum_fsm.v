module add_sub_fsm (
    input clk,
    input rst,
    input enable,
    input start,
    input op_bit,                 // 0 = ADD, 1 = SUB
    input [3:0] state_curr,

    output reg [3:0] state_next,

    output reg c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
    output reg ready
);

    always @(*) begin
        // Reset semnale
        {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10} = 11'd0;
        state_next = state_curr;
        ready = 0;

        if (!enable) begin
            state_next = 4'd0;
        end else begin
            case (state_curr)

                // IDLE ? a?teapt? start
                4'd0: begin
                    if (start)
                        state_next = 4'd10; // A?teapt? c?derea lui start
                    ready = 1;
                end

                // WAIT_FOR_START_FALL
                4'd10: begin
                    if (!start) begin
                        c0 = 1;            // încarc? M <= in1
                        state_next = 4'd11;
                    end
                end

                // WAIT_STABILIZE: 1 ciclu pentru ca op_latched[0] s? fie sigur
                4'd11: begin
                    state_next = 4'd1;
                end

                // LOAD Q
                4'd1: begin
                    c1 = 1;               // Q <= in2
                    state_next = 4'd2;
                end

                // EXECUTE A <= Q (+/-) M
                4'd2: begin
                    c2 = 1;
                    c3 = op_bit;          // aici e SUB sau ADD corect acum
                    state_next = 4'd3;
                end

                // OUTPUT HIGH BYTE
                4'd3: begin
                    c7 = 1;
                    state_next = 4'd4;
                end

                // OUTPUT LOW BYTE
                4'd4: begin
                    c8 = 1;
                    state_next = 4'd0;
                end

                default: state_next = 4'd0;
            endcase
        end
    end

endmodule
