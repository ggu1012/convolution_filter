module do_conv;

    reg clk;
    reg rst;
    wire signed [31:0] data_out;
    reg [15:0] data_in;
    reg rdata;
    wire wdata;
    integer i;

    reg [4:0] row;
    reg [1:0] col;


    integer file_input [0:19];
    integer file_output [0:19];
    integer din, dout;

    conv1 k1(
        .data_in(data_in),
        .row(row),
        .col(col),
        .data_out(data_out),
        .clk(clk),
        .reset_n(rst),
        .rdata(rdata),
        .wdata_fin(wdata)
    );


    // row, col counter
    always@ (negedge rst or posedge clk) begin
        if (!rst) begin
            row <= -1;
            col <= 0;
        end
        else begin 
            if (rdata == 1) begin
                if (row == 5'd27) begin
                    row <= 0;
                    col <= (col == 2'd2) ? 0 : col + 1;
                end
                else
                    row <= row + 1;  
            end
            else begin
                row <= -1;
                col <= 0;
            end
        end
    end


    initial
    begin
        clk <= 1'b1;
        rdata <= 1'b0;
        rst <= 1'b1;
        forever
            #50 clk <= ~clk;
    end

    initial
    begin       

        file_input[0] <= $fopen("C:/altera/16.0/project/conv/convolution/batch/input_00.txt", "r"); 
        file_output[0] <= $fopen("C:/altera/16.0/project/conv/convolution/batch/output_00.txt", "w");

        #50 rst <= 1'b0;
        #100 rst <= 1'b1;
        #50 rdata <= 1;
        repeat (787) @(posedge clk) begin // 784+1 for data transmission with 1 clock delay            
            din <= $fscanf(file_input[0], "%6d", data_in);
            #100;
            if (wdata == 1)     
                $fdisplay(file_output[0], "%12d", data_out); 
        end
        rdata <= 0;

        $fclose(file_input[0]);
        $fclose(file_output[0]);
        $finish();
    end
endmodule

