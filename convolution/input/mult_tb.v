`include "mult16.v"

module mult_tb;

reg [15:0] data1;
reg [15:0] data2;
wire [31:0] out;

mult16 mult_(data1, data2, out);
initial begin

    data1 <= 16'd6425;
    data2 <= 16'd65535;



    #100
    $display("%d * %d = %d??", data1, data2, out);

    if (out == data1 * data2) begin
        $display("RIGHT");    
    end
    else begin
        $display("False");
    end


end 


endmodule
