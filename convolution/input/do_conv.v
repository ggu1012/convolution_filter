`include "mult16.v"

module conv1 (
    input [15:0] data_in, // 16-bit
    input reset_n,
    input clk,
    input rdata_r,    
    output reg [31:0] data_out, // 32-bit
    output reg wdata_r
);

reg signed [15:0] mem [0:27][0:2][0:8];
reg [4:0] row;
reg [1:0] col;
reg [2:0] cycle;
integer i;
wire signed [287:0] mem_pixel;

reg [31:0] p00, p01, p02, p10, p11, p12, p20, p21, p22;
wire [31:0] conv_result;


kernel_pixel u0(
    .pixel(data_in),
    .weighted_pixel(mem_pixel)
);

add_weighted u1(
    .p0(p00),
    .p1(p01),
    .p2(p02),
    .p3(p10),
    .p4(p11),
    .p5(p12),
    .p6(p20),
    .p7(p21),
    .p8(p22),
    .conv_result(conv_result)
);

always@ (posedge clk or negedge reset_n) 
begin
    if (!reset_n) begin
        data_out <= 0; 
        row <= -1;     
    end  

    else begin    
        if (rdata_r == 1'b1) begin
            row <= (row == 5'd27) ? 0 : row + 1;            
            if (row >= 2 && col >=2) wdata_r <= 1;
            else wdata_r <= 0;
        end
    end
    
end

always@(row) begin
    if (row == 5'b0)
        col <= (col == 2'd3)? 0 : col + 1;
end

always@(col) begin
    if (col == 2'b0)
        cycle <= cycle + 1;
end

always@ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        col <= -1;
        cycle <= -1;        
    end       

    if (rdata_r == 1'b1) begin
        for(i=0; i<9; i=i+1)
            mem[row][col][i] <= mem_pixel[32*i +: 32];  
    end    
end

endmodule



module kernel_pixel(
    input signed [15:0] pixel,
    output signed [287:0] weighted_pixel
);

wire signed [15:0] weight [0:2][0:2];
assign weight[0][0] = -16'd4972;
assign weight[0][1] = -16'd622;
assign weight[0][2] = 16'd2988;
assign weight[1][0] = -16'd2478;
assign weight[1][1] = 16'd1703;
assign weight[1][2] = 16'd2519;
assign weight[2][0] = 16'd2008;
assign weight[2][1] = 16'd1748;
assign weight[2][2] = 16'd79;

generate
    genvar i, j;
    for(i=0; i<3; i=i+1) begin : weight_col
        for(j=0;j<3;j=j+1) begin : weight_row
            assign weighted_pixel[96*i+32*(j+1)-1: 96*i+32*j] = weight[i][j] * pixel;
        end
    end
endgenerate

endmodule


module add_weighted(
    input [31:0] p0,
    input [31:0] p1,
    input [31:0] p2,
    input [31:0] p3,
    input [31:0] p4,
    input [31:0] p5,
    input [31:0] p6,
    input [31:0] p7,
    input [31:0] p8,
    output [31:0] conv_result
);

wire [31:0] tmp [0:6];
wire [7:0] ov;

csa32 u0(p0,p1,tmp[0], ov[0]);
csa32 u1(p2,p3,tmp[1], ov[1]);
csa32 u2(p4,p5,tmp[2], ov[2]);
csa32 u3(p6,p7,tmp[3], ov[3]);
csa32 u01(tmp[0], tmp[1], tmp[4], ov[4]);
csa32 u23(tmp[1], tmp[2], tmp[5], ov[5]);
csa32 u45(tmp[4], tmp[5], tmp[6], ov[6]);
csa32 ufinal(tmp[6], p8, conv_result, ov[7]);

endmodule