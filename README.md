# FIFO-MEMORY
First-In-First-Out Principle, Synchronous FSM controller
A standard FIFO is a circular buffer that stores data in a queue-like structure, composed of two main parts: 
  - the memory array and
  - the controller (the FSM)
The FSM manages this flow through a few key mechanisms:
  - Read and Write Pointers: The FSM updates a write pointer when data enters, and a read pointer when data leaves.
  - Once a pointer reaches the end of the memory, the FSM wraps it back to zero.
  - Status Flags: The FSM monitors the pointers to determine buffer status.
      -- Empty: Occurs when the read and write pointers are identical. The FSM prevents reading to avoid returning junk data.
      -- Full: Occurs when the pointers meet, but the write pointer has wrapped around to fill the buffer. The FSM prevents writing to avoid overwriting unread data.
