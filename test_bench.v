module sync_fifo_tb;
  parameter W = 32, D = 16;
  reg clk, rst, cs, rd_en, wt_en;
  reg [W-1:0] data_in;
  wire full, empty;
  wire [W-1:0] data_out;
  // dut declaration 
  synchronous_fifo dut1 (.cs(cs), .rd_en(rd_en), .wt_en(wt_en), .clk(clk), .rst(rst), 
    .data_in(data_in), .full(full), .empty(empty), .data_out(data_out));
  // Clock generation 
  always #5 clk = ~clk; 
    
    initial begin
    clk = 0;
    rst = 0; // low reset
    cs = 0;
    rd_en = 0;
    wt_en = 0;
    data_in = 0;
    #20 rst = 1;
    cs = 1;
    wt_en = 1;
    
    data_in = 32'hAAAA;
    #10;
    data_in = 32'hDDDD;
    #10; 
    data_in = 32'h1210;
    #10;
    wt_en = 0;
    rd_en = 1;
    #30;
    rd_en = 0;
    #10 wt_en = 1;
    data_in = 32'hCD24;
    #10 wt_en =0;
    rd_en = 1;
    #20;
    $finish;
    
    end
endmodule
