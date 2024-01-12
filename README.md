# Asynchronous FIFO Using Verilog

An Asynchronous FIFO Design is a FIFO Design where data values are written to the FIFO memory from one clock domain and read from a different clock domain, where the two clock domains are asynchronous to each other. 
Asynchronous FIFO's are widely used to safely pass the data from one clock domain to another clock domain without suffering from metastability. 
In asynchronous FIFO design, full and empty is determined by comparing the read and write pointers. 

**Gray encoding** is used to safely pass the read and write pointers through synchrounizers from one clock domain to another.

![Async_FIFO_Design](https://github.com/bassantatef/Asynchronous-FIFO-Using-Verilog/assets/82764830/98f90e94-1e78-41b3-8ccd-87107634f760)

This design of the async FIFO consists of the following modules:
- async_FIFO_top
- FIFO_mem
- empty_flag_calc
- full_flag_calc
- sync_rd2wr
- sync_wr2rd

And a testbench to verify its functionality:
- async_FIFO_tb

After designing the asynchronous FIFO and verifying its functionality, it's checked using Linting tool and CDC checker of **Synopsys SpyGlass** Tool.
