`timescale 1ns/1ns
module async_FIFO_tb();

    parameter WIDTH = 8 ;
    parameter ADDR  = 4 ;

    reg                 rst_tb         ;

    reg                 wr_clk_tb      ;
    reg                 wr_en_tb       ;
    reg  [WIDTH-1:0]    wr_data_tb     ;
    
    reg                 rd_clk_tb      ;
    reg                 rd_en_tb       ;

    wire  [WIDTH-1:0]   rd_data_tb     ;

initial begin
    // Save Waveform
    $dumpfile("async_fifo.vcd") ;       
    $dumpvars ; 
        
    // Initialization
    initialize() ;

    // Reset
    reset() ;

    $monitor("Read Data = %h @ Address = %d  ", rd_data_tb, DUT.rd_add);

    write_data('h11) ;
    write_data('h22) ;
    write_data('h33) ;
    write_data('h44) ;
    write_data('h55) ;
    write_data('h66) ;
    write_data('h77) ;
    write_data('h88) ;
    write_data('h99) ;
    write_data('hAA) ;
    write_data('hBB) ;
    write_data('hCC) ;
    write_data('hDD) ;
    write_data('hEE) ;
    write_data('hFF) ;
    write_data('hCD) ;

    write_data('hBC) ; // the full flag is high, so this data is not written

    #30
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;

    read_data() ; // the empty flag is high, so there is no data to be read


    write_data('h10) ;
    write_data('h20) ;
    write_data('h30) ;
    write_data('h40) ;
    write_data('h50) ;
    write_data('h60) ;
    write_data('h70) ;

    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;
    read_data() ;    
    
    #10000
    
    $finish ; 
end  

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

/*  Generate read clock & write clock
    write clock is faster than read clock
    T_wr = 40ns
    T_rd = 50ns
*/
always #20 wr_clk_tb = !wr_clk_tb ; // 25 MHz

always #25 rd_clk_tb = !rd_clk_tb ; // 20 MHz


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

task reset;
begin
    rst_tb =  'b1 ;
    #1
    rst_tb  = 'b0 ;
    #1
    rst_tb  = 'b1 ;
end
endtask

task initialize;
begin
    wr_clk_tb   = 1'b1 ;
    rd_clk_tb   = 1'b1 ;

    wr_en_tb    = 1'b0 ;
    rd_en_tb    = 1'b0 ;
end
endtask

task write_data;
input [WIDTH-1:0] data ;
begin
    wr_en_tb = 1'b1;
    
    wr_data_tb = data ;

    #40
    wr_en_tb = 1'b0;
end
endtask

task read_data;
begin
    rd_en_tb = 1'b1;
    #50
    rd_en_tb = 1'b0;
end
endtask


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////

async_FIFO_top #(WIDTH, ADDR) DUT (
    .rst        (rst_tb    ), 

    .wr_clk     (wr_clk_tb ), 
    .wr_en      (wr_en_tb  ), 
    .wr_data    (wr_data_tb), 

    .rd_clk     (rd_clk_tb ), 
    .rd_en      (rd_en_tb  ), 
        
    .rd_data    (rd_data_tb),
    .full_flag  (full_flag ),
    .empty_flag (empty_flag)
);

endmodule