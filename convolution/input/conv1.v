`include "csa32.v"

module conv1 (
    input [15:0] data_in, // 16-bit
    input [4:0] row, // pixel row
    input [1:0] col, // pixel col
    input reset_n,
    input clk,
    input rdata, // signal for data-in
    output reg [31:0] data_out, // 32-bit
    output reg wdata_fin // signal for data-out
);

/*

input 
    data_in  (16-bit pixel data)
    rdata (data가 들어오는 순간을 알려주는 signal)
    row  (0~27)
    col  (0~27)

output
    data_out (32-bit convolution result)
    wdata_fin (컨볼루션 연산이 완료됐다는 것을 알려주는 signal)   



 -- Structure

  28x3 임시 메모리에 각 픽셀 데이터를 저장했다가 이후 컨볼루션 연산에 사용
  메모리 크기는 3x28x9 ==> 3x28에서 한 칸은 그 픽셀의 weight mult. 결과인 9개 32bit 숫자를 저장

                                    width 28
            ----------------------------------------------------------
           |  0 |  1 |  2 |         .....                             |
           |----------------------------------------------------------
height 3   |  3 |  4 |  5 |         .....                             |
           |----------------------------------------------------------
           |  6 |  7 |  8 |         .....                             |
            ----------------------------------------------------------


  -- 동작 방식
  
  3x28 메모리에는 28x28 데이터가 순차적으로 저장됨. 
  우선 row 방향으로 데이터를 채우고, 한 row에 28개 데이터가 모두 차면 다음 row에 데이터를 저장
  

   image row  0    1    2          ....                           28
     col    ----------------------------------------------------------
      0    |  0 |  1 |  2 |         .....                             |
           |----------------------------------------------------------
      1    |  3 |  4 |  5 |         .....                             |
           |----------------------------------------------------------
      2    |  6 |  7 |  8 |         .....                             |
            ----------------------------------------------------------
  

  컨볼루션 연산은 위 그림의 8번 구역까지 데이터가 채워졌을 때 한번씩 진행됨. 
  (즉, 위 2개의 row가 모두 채워지고 마지막 row에서 8번 구역의 데이터가 들어왔을 때부터 컨볼루션 진행)
  이 때, wdata signal이 1이 되면서 do_conv에서 데이터를 output.txt에 써야할 시점을 알려줌.

  컨볼루션에 사용할 각 픽셀의 weight mult result index는 row, col에 따라 결정됨.
  예를 들어, 세 번째 row의 4번째 위치(8번 옆 위치)에 data가 들어왔을 때는 아래와 같은 index를 사용. 

   image row  0    1    2    3      ....                           28
     col    ----------------------------------------------------------
      0    |    |  0 |  1 |  2 |         .....                        |
           |----------------------------------------------------------
      1    |    |  3 |  4 |  5 |         .....                        |
           |----------------------------------------------------------
      !2   |    |  6 |  7 |  8 |         .....                        |
            ----------------------------------------------------------
  
  이렇게 하나의 데이터가 들어올 때마다 조건이 맞으면 컨볼루션 연산을 진행.

  메모리에 모든 데이터가 다 찼을 경우, 다음 픽셀 데이터가 들어오면 처음 row 부터 데이터를
  다시 덮어씌움. 
  이 때도 마찬가지로, 하나의 row의 3번째 데이터가 들어올 때, 즉 컨볼루션 연산에 필요한 데이터 셋이
  완성됐을 때 부터 컨볼루션을 진행.

  예를 들어, 28x28 이미지의 4번째 row 데이터(image_col=3)가 들어올 때에는 메모리의 1st row를 덮어씌움.

   image row  0    1    2          ....                           28
     col    ----------------------------------------------------------
      !3   |  6 |  7 |  8 |         .....                             |
           |----------------------------------------------------------
      1    |  0 |  1 |  2 |         .....                             |
           |----------------------------------------------------------
      2    |  3 |  4 |  5 |         .....                             |
            ----------------------------------------------------------

  weight mult result index도 col에 따라 변경됨.
  만약 28x28 이미지의 5번째 row 데이터(image_col=4)가 들어올 경우에는 아래와 같이 메모리가 채워짐.

   image row  0    1    2          ....                           28
     col    ----------------------------------------------------------
      3    |  3 |  4 |  5 |         .....                             |
           |----------------------------------------------------------
      !4   |  6 |  7 |  8 |         .....                             |
           |----------------------------------------------------------
      2    |  0 |  1 |  2 |         .....                             |
            ----------------------------------------------------------

    이렇게 row에 데이터를 씌우는 과정을 총 28번 진행하면 모든 이미지 컨볼루션 연산이 끝남.
    
    메모리의 3번째 row (mem_col=2)까지 데이터가 모두 써지면 cycle이 1씩 증가
                    
*/




reg signed [31:0] mem [0:27][0:2][0:8]; // 3x28x9 메모리
wire signed [287:0] mem_pixel; // 32*9-1:0 --> weight multiplication result with 32-bit 9 figures
reg signed [31:0] p00, p01, p02, p10, p11, p12, p20, p21, p22; // 컨볼루션 add에 필요한 9개 데이터
wire signed [31:0] conv_result; // convolution result
reg [4:0] cycle;

integer i;
reg wdata;


// x-clk delayed signals for pseudo-pipeline design
reg [4:0] row_delay_1d;
reg [1:0] col_delay_1d;
reg [4:0] row_delay_2d;
reg [1:0] col_delay_2d;
reg [2:0] wdata_delay;

// wdata signal and reset
always@(row or col or reset_n) begin
    if (!reset_n) begin
        wdata <= 1'b0;
        cycle <= -32'd1;
    end
    else begin
        cycle <= (row == 5'd0 && col == 2'd0)? cycle + 1 : cycle;
        if (cycle == 5'b0) begin
            if (col == 2'd2)
                wdata <= (row >= 5'd2 && row <= 5'd27) ? 1 : 0;
            else
                wdata <= 0;
        end
        else
            wdata <= (row >= 5'd2 && row <= 5'd27) ? 1 : 0;    end
end

// make delayed signals
always@(posedge clk) begin
    row_delay_1d <= row;
    col_delay_1d <= col;
    row_delay_2d <= row_delay_1d;
    col_delay_2d <= col_delay_1d;

    wdata_delay[0] <= wdata;
    wdata_delay[1] <= wdata_delay[0];
    wdata_delay[2] <= wdata_delay[1];
    wdata_fin <= wdata_delay[2];
end

// stage 0
// 한 픽셀 데이터에 9개의 weight 값을 곱해줌.
kernel_pixel_0 u0(
    .clk(clk),
    .pixel(data_in),
    .weighted_pixel(mem_pixel)
);

// stage 1
// 앞에서 구한 weight mult. 결과를 memory의 적정한 위치에 옮김.
always@(posedge clk) begin 
    for(i=0; i<9; i=i+1)
        mem[row_delay_1d][col_delay_1d][i] <= mem_pixel[32*i +: 32];
end

// stage 2
// memory에서 convolution에 필요한 9개 데이터를 가져옴.
always@(posedge clk) begin
    if (wdata_delay[1] == 1) begin
        if (col_delay_2d == 2'd2) begin
            p00 <= mem[row_delay_2d-2][col_delay_2d-2][0]; p01 <= mem[row_delay_2d-1][col_delay_2d-2][1]; p02 <= mem[row_delay_2d][col_delay_2d-2][2];
            p10 <= mem[row_delay_2d-2][col_delay_2d-1][3]; p11 <= mem[row_delay_2d-1][col_delay_2d-1][4]; p12 <= mem[row_delay_2d][col_delay_2d-1][5];
            p20 <= mem[row_delay_2d-2][col_delay_2d][6]; p21 <= mem[row_delay_2d-1][col_delay_2d][7]; p22 <= mem[row_delay_2d][col_delay_2d][8];       
        end
        else if (col_delay_2d == 2'd0) begin            
            p00 <= mem[row_delay_2d-2][col_delay_2d][6]; p01 <= mem[row_delay_2d-1][col_delay_2d][7]; p02 <= mem[row_delay_2d][col_delay_2d][8];
            p10 <= mem[row_delay_2d-2][col_delay_2d+1][0]; p11 <= mem[row_delay_2d-1][col_delay_2d+1][1]; p12 <= mem[row_delay_2d][col_delay_2d+1][2];
            p20 <= mem[row_delay_2d-2][col_delay_2d+2][3]; p21 <= mem[row_delay_2d-1][col_delay_2d+2][4]; p22 <= mem[row_delay_2d][col_delay_2d+2][5];                  
        end
        else if (col_delay_2d == 2'd1) begin
            p00 <= mem[row_delay_2d-2][col_delay_2d-1][3]; p01 <= mem[row_delay_2d-1][col_delay_2d-1][4]; p02 <= mem[row_delay_2d][col_delay_2d-1][5];
            p10 <= mem[row_delay_2d-2][col_delay_2d][6]; p11 <= mem[row_delay_2d-1][col_delay_2d][7]; p12 <= mem[row_delay_2d][col_delay_2d][8];
            p20 <= mem[row_delay_2d-2][col_delay_2d+1][0]; p21 <= mem[row_delay_2d-1][col_delay_2d+1][1]; p22 <= mem[row_delay_2d][col_delay_2d+1][2];  
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

// stage 3
// 앞에서 가져온 9개 데이터와 bias 값을 모두 더해줌.
add_weighted_0 u1(
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
// conv_result를 data_out으로 옮김.
always@(conv_result)
    data_out <= conv_result;

endmodule


/*
kernel_pixel

모든 weight 값은 wire에 assign 되고 이를 multiplication에 사용
결과는 9개의 32-bit 데이터를 이어 붙인 32*9 크기의 register에 옮겨짐

*/
module kernel_pixel_0(
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


/*
add_weighted

bias까지 포함하여 총 10개 데이터의 add 연산 진행
tree 구조로 빠른 연산
따로 작성한 32-bit carry-select-adder 모듈을 사용

*/

module add_weighted_0(
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