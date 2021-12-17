module do_conv;

    reg clk;
    reg rst;

    wire signed [31:0] data_out [0:2];
    reg [15:0] data_in [0:2];

    reg rdata [0:2];
    wire wdata [0:2];
    integer i;

    reg [4:0] row [0:2];
    reg [1:0] col [0:2];


    integer file_input;
    integer file_output;
    integer din;

    // row, col counter
    always@ (negedge rst or posedge clk) begin
        if (!rst) begin
            row[0] <= -1;
            row[1] <= -1;
            row[2] <= -1;
            col[0] <= 0;
            col[1] <= 0;
            col[2] <= 0;
        end
        else begin 
            if (rdata[0] == 1) begin
                if (row[0] == 5'd27) begin
                    row[0] <= 0;
                    col[0] <= (col[0] == 2'd2) ? 0 : col[0] + 1;
                end
                else
                    row[0] <= row[0] + 1;  
            end
            else if (rdata[1] == 1) begin
                if (row[1] == 5'd27) begin
                    row[1] <= 0;
                    col[1] <= (col[1] == 2'd2) ? 0 : col[1] + 1;
                end
                else
                    row[1] <= row[1] + 1;  
            end
            else if (rdata[2] == 1) begin
                if (row[2] == 5'd27) begin
                    row[2] <= 0;
                    col[2] <= (col[2] == 2'd2) ? 0 : col[2] + 1;
                end
                else
                    row[2] <= row[2] + 1;  
            end
        end
    end


    initial
    begin
        clk <= 1'b1;
        rdata[0] <= 1'b0;
        rdata[1] <= 1'b0;
        rdata[2] <= 1'b0;
        rst <= 1'b1;
        forever
            #50 clk <= ~clk;
    end

    initial
    begin       

        i = 0;

        for (i=0; i<20; i=i+1) begin
            if(i < 10) begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_0%1d.txt", i), "r");
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_0%1d.txt", i), "w");  
            end
            else begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_%2d.txt", i), "r"); 
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_%2d.txt", i), "w"); 
            end

            #50 rst <= 1'b0;
            #100 rst <= 1'b1;
            #50 rdata[0] <= 1;
            repeat (788) @(posedge clk) begin // 784+4 for data transmission with 4 clock delays            
                din <= $fscanf(file_input, "%6d", data_in[0]);
                #100;
                if (wdata[0] == 1)     
                    $fdisplay(file_output, "%12d", data_out[0]); 
            end
            rdata[0] <= 0;
            data_in[0] <= 0;

            $fclose(file_input);
            $fclose(file_output);

            #100;

            if(i < 10) begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_0%1d.txt", i), "r");
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_0%1d.txt", i), "a");  
            end
            else begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_%2d.txt", i), "r"); 
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_%2d.txt", i), "a"); 
            end

            #50 rst <= 1'b0;
            #100 rst <= 1'b1;
            #50 rdata[1] <= 1;
            repeat (788) @(posedge clk) begin // 784+4 for data transmission with 4 clock delays            
                din <= $fscanf(file_input, "%6d", data_in[1]);
                #100;
                if (wdata[1] == 1)     
                    $fdisplay(file_output, "%12d", data_out[1]); 
            end
            rdata[1] <= 0;
            data_in[1] <= 0;

            $fclose(file_input);
            $fclose(file_output);

            #100;

            if(i < 10) begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_0%1d.txt", i), "r");
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_0%1d.txt", i), "a");  
            end
            else begin
                file_input <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/input_%2d.txt", i), "r"); 
                file_output <= $fopen($sformatf("C:/altera/16.0/project/conv/convolution/batch/output_%2d.txt", i), "a"); 
            end

            #50 rst <= 1'b0;
            #100 rst <= 1'b1;
            #50 rdata[2] <= 1;
            repeat (788) @(posedge clk) begin // 784+4 for data transmission with 4 clock delays            
                din <= $fscanf(file_input, "%6d", data_in[2]);
                #100;
                if (wdata[2] == 1)     
                    $fdisplay(file_output, "%12d", data_out[2]); 
            end
            rdata[2] <= 0;
            data_in[2] <= 0;

            $fclose(file_input);
            $fclose(file_output);

        end

        $finish();

    end

    conv1 kv1(
        .data_in(data_in[0]),
        .row(row[0]),
        .col(col[0]),
        .data_out(data_out[0]),
        .clk(clk),
        .reset_n(rst),
        .rdata(rdata[0]),
        .wdata_fin(wdata[0])
    );
    
    conv2 kv2(
        .data_in(data_in[1]),
        .row(row[1]),
        .col(col[1]),
        .data_out(data_out[1]),
        .clk(clk),
        .reset_n(rst),
        .rdata(rdata[1]),
        .wdata_fin(wdata[1])
    );

    conv3 kv3(
        .data_in(data_in[2]),
        .row(row[2]),
        .col(col[2]),
        .data_out(data_out[2]),
        .clk(clk),
        .reset_n(rst),
        .rdata(rdata[2]),
        .wdata_fin(wdata[2])
    );
endmodule

