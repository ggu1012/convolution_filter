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

    initial
    begin       

file_input[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_00.txt", "r"); 
file_input[1] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_01.txt", "r");
file_input[2] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_02.txt", "r");
file_input[3] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_03.txt", "r");
file_input[4] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_04.txt", "r");
file_input[5] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_05.txt", "r");
file_input[6] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_06.txt", "r");
file_input[7] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_07.txt", "r");
file_input[8] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_08.txt", "r");
file_input[9] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_09.txt", "r");
file_input[10] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_10.txt", "r");
file_input[11] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_11.txt", "r");
file_input[12] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_12.txt", "r");
file_input[13] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_13.txt", "r");
file_input[14] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_14.txt", "r");
file_input[15] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_15.txt", "r");
file_input[16] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_16.txt", "r");
file_input[17] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_17.txt", "r");
file_input[18] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_18.txt", "r");
file_input[19] = $fopen("C:/altera/16.0/project/conv/convolution/batch/input_19.txt", "r");

file_output[1] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_01.txt", "r");
file_output[2] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_02.txt", "r");
file_output[3] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_03.txt", "r");
file_output[4] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_04.txt", "r");
file_output[5] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_05.txt", "r");
file_output[6] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_06.txt", "r");
file_output[7] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_07.txt", "r");
file_output[8] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_08.txt", "r");
file_output[9] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_09.txt", "r");
file_output[10] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_10.txt", "r");
file_output[11] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_11.txt", "r");
file_output[12] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_12.txt", "r");
file_output[13] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_13.txt", "r");
file_output[14] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_14.txt", "r");
file_output[15] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_15.txt", "r");
file_output[16] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_16.txt", "r");
file_output[17] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_17.txt", "r");
file_output[18] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_18.txt", "r");
file_output[19] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_19.txt", "r");


        for (i=0; i<20; i=i+1) begin
            

            file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "r");

            #50 rst = 1'b0;
            #100 rst = 1'b1;
            #50 rdata_r = 1;
            repeat (784) begin
                din = #100 $fscanf(file_input[i], "%6d", data_in);
                if (wdata_r == 1)     
                    $fdisplay(file_output[i], "%12d", data_out); 
            end
            rdata_r = 0;

            file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "a");

            #50 rst = 1'b0;
            #100 rst = 1'b1;
            #50 rdata_r = 1;
            repeat (784) begin
                din = #100 $fscanf(file_input[i], "%6d", data_in);
                if (wdata_r == 1)     
                    $fdisplay(file_output[i], "%12d", data_out); 
            end
            rdata_r = 0;

            file_output[0] = $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "a");
            #50 rst = 1'b0;
            #100 rst = 1'b1;
            #50 rdata_r = 1;
            repeat (784) begin
                din = #100 $fscanf(file_input[i], "%6d", data_in);
                if (wdata_r == 1)     
                    $fdisplay(file_output[i], "%12d", data_out); 
            end
            rdata_r = 0;


            $fclose(file_input[i]);
            $fclose(file_output[i]);
            $finish();
        end

    end

endmodule

