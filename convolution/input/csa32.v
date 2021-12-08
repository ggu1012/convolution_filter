module csa32(
    input [31:0] a,
    input [31:0] b,
    output [31:0] out,
    output overflow
  );

// 2 2 3 4 5 7 9

wire [5:0] c;
wire [1:0] tmp2 [0:1];
wire [1:0] tmp22 [0:1];
wire [2:0] tmp3 [0:1];
wire [3:0] tmp4 [0:1];
wire [4:0] tmp5 [0:1];
wire [6:0] tmp7 [0:1];
wire [8:0] tmp9 [0:1];

wire [1:0] ctmp2, ctmp22, ctmp3, ctmp4, ctmp5, ctmp7, ctmp9;

add2 u20 (a[1:0], b[1:0], 1'b0, out[1:0], c[0]);

add2 u220 (a[3:2], b[3:2], 1'b0, tmp22[0], ctmp22[0]);
add2 u221 (a[3:2], b[3:2], 1'b1, tmp22[1], ctmp22[1]);
assign c[1] = c[0] ? ctmp22[1] : ctmp22[0];
assign out[3:2] = c[0] ? tmp22[1] : tmp22[0];

add3 u30 (a[6:4], b[6:4], 1'b0, tmp3[0], ctmp3[0]);
add3 u31 (a[6:4], b[6:4], 1'b1, tmp3[1], ctmp3[1]);
assign c[2] = c[1] ? ctmp3[1] : ctmp3[0];
assign out[6:4] = c[1] ? tmp3[1] : tmp3[0];

add4 u40 (a[10:7], b[10:7], 1'b0, tmp4[0], ctmp4[0]);
add4 u41 (a[10:7], b[10:7], 1'b1, tmp4[1], ctmp4[1]);
assign c[3] = c[2] ? ctmp4[1] : ctmp4[0];
assign out[10:7] = c[2] ? tmp4[1] : tmp4[0];

add5 u50 (a[15:11], b[15:11], 1'b0, tmp5[0], ctmp5[0]);
add5 u51 (a[15:11], b[15:11], 1'b1, tmp5[1], ctmp5[1]);
assign c[4] = c[3] ? ctmp5[1] : ctmp5[0];
assign out[15:11] = c[3] ? tmp5[1] : tmp5[0];

add7 u70 (a[22:16], b[22:16], 1'b0, tmp7[0], ctmp7[0]);
add7 u71 (a[22:16], b[22:16], 1'b1, tmp7[1], ctmp7[1]);
assign c[5] = c[4] ? ctmp7[1] : ctmp7[0];
assign out[22:16] = c[4] ? tmp7[1] : tmp7[0];

add9 u90 (a[31:23], b[31:23], 1'b0, tmp9[0], ctmp9[0]);
add9 u91 (a[31:23], b[31:23], 1'b1, tmp9[1], ctmp9[1]);
assign overflow = c[5] ? ctmp9[1] : ctmp9[0];
assign out[31:23] = c[5] ? tmp9[1] : tmp9[0];

endmodule


module add2(
  input [1:0] a,
  input [1:0] b,
  input cin,
  output [1:0] sum,
  output cout
);

  wire c;

  fullad u20(a[0], b[0], cin, sum[0], c);
  fullad u21(a[1], b[1], c, sum[1], cout);

endmodule

module add3(
  input [2:0] a,
  input [2:0] b,
  input cin,
  output [2:0] sum,
  output cout
);

  wire [2:0] c;
  assign c[0] = cin;

  generate
    genvar i;
    for(i=0; i<3; i=i+1) begin
      if (i != 2)
        fullad u3(a[i], b[i], c[i], sum[i], c[i+1]);
      else 
        fullad u3(a[i], b[i], c[i], sum[i], cout);
    end
  endgenerate

endmodule

module add4(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);

  wire [3:0] c;
  assign c[0] = cin;

  generate
    genvar i;
    for(i=0; i<4; i=i+1) begin
      if (i != 3)
        fullad u4(a[i], b[i], c[i], sum[i], c[i+1]);
      else 
        fullad u4(a[i], b[i], c[i], sum[i], cout);
    end
  endgenerate

endmodule

module add5(
  input [4:0] a,
  input [4:0] b,
  input cin,
  output [4:0] sum,
  output cout
);

  wire [4:0] c;
  assign c[0] = cin;

  generate
    genvar i;
    for(i=0; i<5; i=i+1) begin
      if (i != 4)
        fullad u5(a[i], b[i], c[i], sum[i], c[i+1]);
      else 
        fullad u5(a[i], b[i], c[i], sum[i], cout);
    end
  endgenerate

endmodule

module add7(
  input [6:0] a,
  input [6:0] b,
  input cin,
  output [6:0] sum,
  output cout
);

  wire [6:0] c;
  assign c[0] = cin;

  generate
    genvar i;
    for(i=0; i<7; i=i+1) begin
      if (i != 6)
        fullad u5(a[i], b[i], c[i], sum[i], c[i+1]);
      else 
        fullad u5(a[i], b[i], c[i], sum[i], cout);
    end
  endgenerate

endmodule

module add9(
  input [8:0] a,
  input [8:0] b,
  input cin,
  output [8:0] sum,
  output cout
);

  wire [8:0] c;
  assign c[0] = cin;

  generate
    genvar i;
    for(i=0; i<9; i=i+1) begin
      if (i != 8)
        fullad u5(a[i], b[i], c[i], sum[i], c[i+1]);
      else 
        fullad u5(a[i], b[i], c[i], sum[i], cout);
    end
  endgenerate

endmodule



module fullad(
    input a,
    input b,
    input cin,
    output y,
    output cout
  );

  assign y = a ^ b ^ cin;
  assign cout = (a & b) ^ ((a ^ b) & cin);

endmodule

module halfad(
    input in1,
    input in2,
    output sum,
    output carry
);

assign carry = in1 & in2;
assign sum = in1 ^ in2;

endmodule