`include "mult16.v"

module conv1 (
    input [15:0] data_in, // 16-bit
    input [4:0] row,
    input [1:0] col,
    input reset_n,
    input clk,
    input rdata,    
    output reg [31:0] data_out, // 32-bit
    output reg wdata_fin
);

reg signed [31:0] mem [0:27][0:2][0:8];
wire signed [287:0] mem_pixel;
reg signed [31:0] p00, p01, p02, p10, p11, p12, p20, p21, p22;
wire signed [31:0] conv_result;
reg [4:0] cycle;

integer i;
reg signed [31:0] tmp1;
reg wdata;

reg [4:0] xxxx;
reg [4:0] row_delay_1d;
reg [4:0] row_delay_2d;
reg [1:0] col_delay_1d;
reg [1:0] col_delay_2d;
reg [1:0] wdata_delay;

// reset
always@(negedge reset_n) begin
    wdata <= 1'b0;
    cycle <= -32'd1;
end


// wdata signal
always@(row or col) begin
    cycle <= (row == 5'd0 && col == 2'd0)? cycle + 1 : cycle;
    if (cycle == 5'b0) begin
        if (col == 2'd2)
            wdata <= (row >= 5'd2 && row <= 5'd27) ? 1 : 0;
        else
            wdata <= 0;
    end
    else
        wdata <= (row >= 5'd2 && row <= 5'd27) ? 1 : 0;
end

always@(posedge clk) begin
    row_delay_1d <= row;
    col_delay_1d <= col;
    row_delay_2d <= row_delay_1d;
    col_delay_2d <= col_delay_1d;

    wdata_delay[0] <= wdata;
    wdata_delay[1] <= wdata_delay[0];
    wdata_fin <= wdata_delay[1];
end

// stage 0
kernel_pixel u0(
    .clk(clk),
    .pixel(data_in),
    .weighted_pixel(mem_pixel)
);


always@(*) begin 
    for(i=0; i<9; i=i+1) begin
        mem[row_delay_1d][col_delay_1d][i] <= mem_pixel[32*i +: 32];
        tmp1 <= mem_pixel[32*i +: 32];
    end
end

// stage 1
always@(posedge clk) begin
    if (wdata_delay[0] == 1) begin
        if (col_delay_1d == 2'd2) begin
            p00 <= mem[row_delay_1d-2][col_delay_1d-2][0]; p01 <= mem[row_delay_1d-1][col_delay_1d-2][1]; p02 <= mem[row_delay_1d][col_delay_1d-2][2];
            p10 <= mem[row_delay_1d-2][col_delay_1d-1][3]; p11 <= mem[row_delay_1d-1][col_delay_1d-1][4]; p12 <= mem[row_delay_1d][col_delay_1d-1][5];
            p20 <= mem[row_delay_1d-2][col_delay_1d][6]; p21 <= mem[row_delay_1d-1][col_delay_1d][7]; p22 <= mem[row_delay_1d][col_delay_1d][8];       
        end
        else if (col_delay_1d == 2'd0) begin            
            p00 <= mem[row_delay_1d-2][col_delay_1d][6]; p01 <= mem[row_delay_1d-1][col_delay_1d][7]; p02 <= mem[row_delay_1d][col_delay_1d][8];
            p10 <= mem[row_delay_1d-2][col_delay_1d+1][0]; p11 <= mem[row_delay_1d-1][col_delay_1d+1][1]; p12 <= mem[row_delay_1d][col_delay_1d+1][2];
            p20 <= mem[row_delay_1d-2][col_delay_1d+2][3]; p21 <= mem[row_delay_1d-1][col_delay_1d+2][4]; p22 <= mem[row_delay_1d][col_delay_1d+2][5];                  
        end
        else if (col_delay_1d == 2'd1) begin
            p00 <= mem[row_delay_1d-2][col_delay_1d-1][3]; p01 <= mem[row_delay_1d-1][col_delay_1d-1][4]; p02 <= mem[row_delay_1d][col_delay_1d-1][5];
            p10 <= mem[row_delay_1d-2][col_delay_1d][6]; p11 <= mem[row_delay_1d-1][col_delay_1d][7]; p12 <= mem[row_delay_1d][col_delay_1d][8];
            p20 <= mem[row_delay_1d-2][col_delay_1d+1][0]; p21 <= mem[row_delay_1d-1][col_delay_1d+1][1]; p22 <= mem[row_delay_1d][col_delay_1d+1][2];  
        end
        else begin
            p00 <= 0; p01 <= 0; p02 <= 0;
            p10 <= 0; p11 <= 0; p12 <= 0;
            p20 <= 0; p21 <= 0; p22 <= 0;       
        end
    end

    else begin
        p00 <= 0; p01 <= 0; p02 <= 0;
        p10 <= 0; p11 <= 0; p12 <= 0;
        p20 <= 0; p21 <= 0; p22 <= 0;       
    end
end

// stage 2
add_weighted u1(
    .clk(clk),
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


always@(conv_result) begin
    data_out <= conv_result;
end

endmodule



module kernel_pixel(
    input clk,
    input signed [15:0] pixel,
    output reg signed [32*3*3-1:0] weighted_pixel
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
            always@ (posedge clk)
                weighted_pixel[96*i+32*(j+1)-1: 96*i+32*j] <= weight[i][j] * pixel;
        end
    end
endgenerate

endmodule


module add_weighted(
    input clk,
    input [31:0] p0,
    input [31:0] p1,
    input [31:0] p2,
    input [31:0] p3,
    input [31:0] p4,
    input [31:0] p5,
    input [31:0] p6,
    input [31:0] p7,
    input [31:0] p8,
    output reg [31:0] conv_result
);

wire signed [31:0] bias;

wire [31:0] tmp [0:8];
wire [8:0] ov;

assign bias = -32'd58730196;

csa32 u0(p0,p1,tmp[0], ov[0]);
csa32 u1(p2,p3,tmp[1], ov[1]);
csa32 u2(p4,p5,tmp[2], ov[2]);
csa32 u3(p6,p7,tmp[3], ov[3]);
csa32 u4(p8, bias, tmp[4], ov[4]);
csa32 u5(tmp[0], tmp[1], tmp[5], ov[5]);
csa32 u6(tmp[2], tmp[3], tmp[6], ov[6]);
csa32 u7(tmp[5], tmp[6], tmp[7], ov[7]);
csa32 u8(tmp[4], tmp[7], tmp[8], ov[8]);

always@(posedge clk)
    conv_result <= tmp[8];



endmodule