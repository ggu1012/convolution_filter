module do_conv;

    reg clk;
    reg rst;
    wire signed [31:0] data_out;
    reg [15:0] data_in;
    reg rdata_r;
    integer i;


    integer file_input [0:19];
    integer file_output [0:19];
    integer din, dout;

    conv1 k1(.data_in(data_in),
             .data_out(data_out),
             .clk(clk),
             .reset_n(rst),
             .rdata_r(rdata_r),
             .wdata_r(wdata_r)
            );


    initial
    begin
        clk <= 1'b1;
        rdata_r <= 1'b0;
        rst <= 1'b1;
        forever
            #50 clk = ~clk;
    end

    reg wr_delay;

    always@(wdata_r)
        #100 wr_delay <= wdata_r;


    initial
    begin       

        file_input[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_00.txt", "r"); 
        file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "w");

        #50 rst = 1'b0;
        #100 rst = 1'b1;
        #50 rdata_r = 1;
        repeat (785) begin
            din = #100 $fscanf(file_input[0], "%6d", data_in);
            if (wr_delay == 1)     
                $fdisplay(file_output[0], "%12d", data_out); 
        end
        rdata_r = 0;

        // file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "a");

        // #50 rst = 1'b0;
        // #100 rst = 1'b1;
        // #50 rdata_r = 1;
        // repeat (784) begin
        //     din = #100 $fscanf(file_input[0], "%6d", data_in);
        //     if (wdata_r == 1)     
        //         $fdisplay(file_output[0], "%12d", data_out); 
        // end
        // rdata_r = 0;

        // file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "a");
        // #50 rst = 1'b0;
        // #100 rst = 1'b1;
        // #50 rdata_r = 1;
        // repeat (784) begin
        //     din = #100 $fscanf(file_input[0], "%6d", data_in);
        //     if (wdata_r == 1)     
        //         $fdisplay(file_output[0], "%12d", data_out); 
        // end
        // rdata_r = 0;


        $fclose(file_input[0]);
        $fclose(file_output[0]);
        $finish();
    end
endmodule

