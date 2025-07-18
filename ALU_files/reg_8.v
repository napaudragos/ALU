// generated by digital
module reg_8 (
  input clk,
  input rst,
  input [7:0] in,
  input load,
  output [7:0] out
);

  wire s0;
  wire s1;
  wire [7:0] s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire s11;
  wire s12;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  wire [7:0] out_temp;
  assign s0 = ~ rst;
  assign s1 = (s2[0] & s0);
  assign s16 = (s2[1] & s0);
  assign s11 = (s2[2] & s0);
  assign s13 = (s2[3] & s0);
  assign s7 = (s2[4] & s0);
  assign s9 = (s2[5] & s0);
  assign s3 = (s2[6] & s0);
  assign s5 = (s2[7] & s0);
  Mux_2x1_NBits #(
    .Bits(8)
  )
  Mux_2x1_NBits_i0 (
    .sel( load ),
    .in_0( out_temp ),
    .in_1( in ),
    .out( s2 )
  );
  d_ff d_ff_i1 (
    .d( s3 ),
    .clk( clk ),
    .q( s4 )
  );
  d_ff d_ff_i2 (
    .d( s5 ),
    .clk( clk ),
    .q( s6 )
  );
  d_ff d_ff_i3 (
    .d( s7 ),
    .clk( clk ),
    .q( s8 )
  );
  d_ff d_ff_i4 (
    .d( s9 ),
    .clk( clk ),
    .q( s10 )
  );
  d_ff d_ff_i5 (
    .d( s11 ),
    .clk( clk ),
    .q( s12 )
  );
  d_ff d_ff_i6 (
    .d( s13 ),
    .clk( clk ),
    .q( s14 )
  );
  d_ff d_ff_i7 (
    .d( s1 ),
    .clk( clk ),
    .q( s15 )
  );
  d_ff d_ff_i8 (
    .d( s16 ),
    .clk( clk ),
    .q( s17 )
  );
  assign out_temp[0] = s15;
  assign out_temp[1] = s17;
  assign out_temp[2] = s12;
  assign out_temp[3] = s14;
  assign out_temp[4] = s8;
  assign out_temp[5] = s10;
  assign out_temp[6] = s4;
  assign out_temp[7] = s6;
  assign out = out_temp;
endmodule
