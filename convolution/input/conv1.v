module conv1 (
    input [15:0] data_in, // 16-bit
    input reset_n,
    input clk,
    
    output reg [31:0] data_out // 32-bit
);

reg [15:0] mem [0:27][0:2][0:8];
reg [4:0] row;
reg [1:0] col;



always@ (posedge clk, negedge reset_n) begin
    if (!reset_n)
        data_out <= 0;

    

    row <= (row == 5'd27) ? 0 : row + 1;

    if (row == 5'b0)
        col <= (2'd3)? 0 : col + 1;
        
end



endmodule;
