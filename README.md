# FIFO-MEMORY
First-In-First-Out Principle, Synchronous FSM controller
Synchronous FIFOs are primarily used to buffer data when the rate of data transfer exceeds the rate of data processing. This is particularly important in high-speed systems where timing discrepancies can lead to data loss or corruption.
A standard FIFO is a circular buffer that stores data in a queue-like structure, composed of two main parts: 
- the memory array and
- the controller (the FSM)
  
The FSM manages this flow through a few key mechanisms:
- Read and Write Pointers: The FSM updates a write pointer when data enters, and a read pointer when data leaves.
- Once a pointer reaches the end of the memory, the FSM wraps it back to zero.
- Status Flags: The FSM monitors the pointers to determine buffer status.
  - Empty: Occurs when the read and write pointers are identical. The FSM prevents reading to avoid returning junk data.
  - Full: Occurs when the pointers meet, but the write pointer has wrapped around to fill the buffer. The FSM prevents writing to avoid overwriting unread data.

Elaborately:
1. Fifo has two operations - read and write. 
2. `CS` signal : chip select should be one, to operate fifo
3. Read enable : `rd_en` 1 for read allowing
4. Write enable : `wt_en` 1 for write operation
5. clock : `clk`
6. `data_in`: the data we want to write in the memory.
7. `data_out` : The data being read from the memory during a read operation.
8. read pointer : The internal address register pointing to the next memory location to be read.
9. write pointer : The internal address register pointing to the next memory location to be written.
10. When the read and write pointers catch up with each other, then depending on the direction, either flag should activate:
    - full flag: Indicates the FIFO is full, so data cannot be written unless something is read out.
    - empty flag: Indicates the FIFO is empty, so data can not be read.
11. Width and Depth of FIFO : Width refers to the no. of bits that can be stored in a single entry, while Depth refers to the number of entries which can be accomodated in the memory buffer.
12. Depth Calculation :    Depth = (Writing Rate - Reading Rate)/Clock Frequency

# Code (main)
```verilog
`timescale 1ns/1ps
module synchronous_fifo
# (parameter W = 32, D = 16)
  (input cs, rd_en, wt_en, clk, rst,
  input [W-1:0] data_in,
  output full, empty,
  output reg [W-1:0] data_out);

  // internal variables 
  reg [W-1:0] mem [0:D-1];   
  reg [$clog2(D)-1:0] rd_ptr;        
  reg [$clog2(D)-1:0] wr_ptr;        
  reg [$clog2(D):0] count;           

  always @ (posedge clk) begin
    if (!rst) begin 
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
    end
    else if (cs) begin
      // Write logic
      if (wt_en & !full) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
      end
      
      // Read logic
      if (rd_en & !empty) begin
        data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end

      // Count logic to determine flag
      case ({wt_en & !full, rd_en & !empty})
        2'b10: count <= count + 1; // Write only
        2'b01: count <= count - 1; // Read only
        default: count <= count;
      endcase
    end
  end

  
  assign full = (count == D);
  assign empty = (count == 0);
  
endmodule
```
# Code (TestBench)
```verilog
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
```
