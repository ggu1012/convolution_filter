`include "mult16_booth.v"

module mult_tb;

reg signed [15:0] data1;
reg signed [15:0] data2;
wire signed [31:0] out;
wire signed [31:0] outx;

assign outx = data1 * data2;
mult16 mult_(data1, data2, out);
initial begin

    data1 <= 16'd22322;
    data2 <= -16'd40119;   

    #100
    $display("%b * %b = %b_%b_%b_%b_%b_%b_%b_%b??", data1, data2, out[31:28], out[27:24], out[23:20], out[19:16], out[15:12], out[11:8], out[7:4], out[3:0]);
    $display("%b * %b = %b_%b_%b_%b_%b_%b_%b_%b??", data1, data2, outx[31:28], outx[27:24], outx[23:20], outx[19:16], outx[15:12], outx[11:8], outx[7:4], outx[3:0]);
    if (out == data1 * data2) begin
        $display("RIGHT");    
    end
    else begin
        $display("False");
    end


end 


endmodule
