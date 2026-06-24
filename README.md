# FIFO-MEMORY
First-In-First-Out Principle, Synchronous FSM controller

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


# Code (main)
```verilog
`timescale 1ns/1ps
module fifo(
  input cs, rd_en, wt_en, clk, rst
  input [31:0] data_in,
  output reg flag_f, flag_em, output reg [31:0] data_out
  );
  // internal variables (fifo depth = 16)
  reg [31:0] mem [0:15];   // memory array (Width: 32-bit, Depth: 16)
  reg [3:0] rd_ptr;        // Read pointer (4 bits to address 0-15)
  reg [3:0] wr_ptr;        // Write pointer (4 bits to address 0-15)
  reg [4:0] count;         // tracks no. of items to easily set flags

  
endmodule

```
