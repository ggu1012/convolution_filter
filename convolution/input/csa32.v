module csa32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] out
  );

  wire  tmp;
  wire dummy;
  csa16 u0(A[15:0], B[15:0], 1'b0, out[15:0], tmp);
  csa16 u2(A[31:16], B[31:16], tmp, out[31:16], dummy);

endmodule


module csa16(
  input [15:0] a,
  input [15:0] b,
  input cin,
  output [15:0] out,
  output cout
);

// 2 2 3 4 5

wire [5:0] c;
assign cout = c[5];

wire [1:0] tmp2 [0:1];
wire [1:0] tmp22 [0:1];
wire [2:0] tmp3 [0:1];
wire [3:0] tmp4 [0:1];
wire [4:0] tmp5 [0:1];

wire [1:0] ctmp2, ctmp22, ctmp3, ctmp4, ctmp5;

add2 u20 (a[1:0], b[1:0], 1'b0, tmp2[0], ctmp2[0]);
add2 u21 (a[1:0], b[1:0], 1'b1, tmp2[1], ctmp2[1]);
assign c[1] = cin ? ctmp2[1] : ctmp2[0];
assign out[1:0] = cin ? tmp2[1] : tmp2[0];

add2 u220 (a[3:2], b[3:2], 1'b0, tmp22[0], ctmp22[0]);
add2 u221 (a[3:2], b[3:2], 1'b1, tmp22[1], ctmp22[1]);
assign c[2] = c[1] ? ctmp22[1] : ctmp22[0];
assign out[3:2] = c[1] ? tmp22[1] : tmp22[0];

add3 u30 (a[6:4], b[6:4], 1'b0, tmp3[0], ctmp3[0]);
add3 u31 (a[6:4], b[6:4], 1'b1, tmp3[1], ctmp3[1]);
assign c[3] = c[2] ? ctmp3[1] : ctmp3[0];
assign out[6:4] = c[2] ? tmp3[1] : tmp3[0];

add4 u40 (a[10:7], b[10:7], 1'b0, tmp4[0], ctmp4[0]);
add4 u41 (a[10:7], b[10:7], 1'b1, tmp4[1], ctmp4[1]);
assign c[4] = c[3] ? ctmp4[1] : ctmp4[0];
assign out[10:7] = c[3] ? tmp4[1] : tmp4[0];

add5 u50 (a[15:11], b[15:11], 1'b0, tmp5[0], ctmp5[0]);
add5 u51 (a[15:11], b[15:11], 1'b1, tmp5[1], ctmp5[1]);
assign c[5] = c[4] ? ctmp5[1] : ctmp5[0];
assign out[15:11] = c[4] ? tmp5[1] : tmp5[0];

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