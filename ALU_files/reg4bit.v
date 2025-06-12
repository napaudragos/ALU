module reg4bit (
    input clk,
    input rst,
    input load,
    input [3:0] d,       // datele de intrare
    output reg [3:0] q   // datele de ie?ire
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= d;
    end

endmodule
