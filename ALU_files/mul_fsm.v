module mul_fsm (
    input clk,
    input rst,
    input enable,
    input start,
    input q0,
    input qminus1,
    input a7,
    input cnt_ok,
    input [3:0] state_curr,

    output reg [3:0] state_next,

    output reg c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
    output reg ready
);


    always @(*) begin
        // Reset semnale control
        {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10} = 11'd0;
        state_next = state_curr;
        ready = (state_curr == 4'd0);

        if (!enable) begin
            state_next = 4'd0;
        end else begin
            case (state_curr)

                // IDLE ? asteapta start
                4'd0: begin
                    if (start)
                        state_next = 4'd10; // asteapta caderea lui start
                end

                // WAIT_START_FALL
                4'd10: begin
                    if (!start) begin
                        c0 = 1;              // încarc? M
                        state_next = 4'd1;
                    end
                end

                // LOAD Q
                4'd1: begin
                    c1 = 1;
                    state_next = 4'd2;
                end

                // DECIZIE BOOTH
                4'd2: begin
                    if (~q0 && qminus1) begin
                        c2 = 1;
                        state_next = 4'd5;
                    end else if (q0 && ~qminus1) begin
                        c2 = 1;
                        c3 = 1;
                        state_next = 4'd5;
                    end else begin
                        state_next = 4'd5;
                    end
                end

                // SHIFT
                4'd5: begin
                    c6 = a7;
                    c4 = 1;
                    state_next = 4'd6;
                end

                // INCREMENT + CHECK COUNTER
                4'd6: begin
                    c5 = 1;
                    if (!cnt_ok) begin
                        state_next = 4'd2;
                    end else begin
                        state_next = 4'd7;
                    end
                end

                // OUTPUT HIGH BYTE
                4'd7: begin
                    c8 = 1;
                    state_next = 4'd8;
                end

                // OUTPUT LOW BYTE
                4'd8: begin
                    c7 = 1;
                    state_next = 4'd0;
                end

                default: state_next = 4'd0;

            endcase
        end
    end

endmodule


