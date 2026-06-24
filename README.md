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

Roughly:
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
module fifo
# (parameter W = 32, D = 16)
  (input cs, rd_en, wt_en, clk, rst
  input [W-1:0] data_in,
  output reg full, empty, output reg [W-1:0] data_out
  );
  // internal variables 
  reg [W-1:0] mem [0:D-1];   // memory array (Width: 32-bit, Depth: 16)
  reg [$clog(D)-1:0] rd_ptr;        // Read pointer (4 bits to address 0-15)
  reg [$clog(D)-1:0] wr_ptr;        // Write pointer (4 bits to address 0-15)
  reg [$clog(D):0] count;         // tracks no. of items to easily set flags

  // loop declaration for writing
  always @ (posedge clk) begin
    if (!rst) begin // considering active-low reset
      wr_ptr <= 0;
    end
    else begin
      if (wt_en & !full) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
      end
    end
  end

  // 
endmodule

```
