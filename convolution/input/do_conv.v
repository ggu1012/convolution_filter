module do_conv;

    reg clk;
    reg rst;
    wire signed [31:0] data_out;
    reg [15:0] data_in;
    reg rdata_r;


    integer file_input [0:19];
    integer file_output [0:19];
    integer din, dout;

    conv1 k1(.data_in(data_in),
             .data_out(data_out),
             .clk(clk),
             .resetn(rst),
             .rdata_r(rdata_r),
             .wdata_r(wdata_r)
            );


    initial
    begin
        clk <= 1'b0;
        forever
            #50 clk = ~clk;
    end

    initial
    begin
        #100
         rst = 1'b1;
        #100
         rst = 1'b0;


        file_input[0] = $fopen("../batch/input_00.txt", "r");
        

        rdata_r = 1;

        repeat (768) begin
            #100 din = $fscanf(file_input[0], "%6d", data_in);
        end

        rdata_r = 0;

        


        file_output[0] = $fopen("../batch/output_00.txt", "w");



        repeat (676)
            #100 $fdisplay(file_output[0], "%12d", data_out);



        $fclose(file_input[0]);
        // $fclose(file_output);
        $finish();

    end

endmodule

