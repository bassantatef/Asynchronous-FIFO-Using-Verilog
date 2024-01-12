module async_FIFO_top #(parameter       WIDTH = 8 ,
                                        ADDR  = 4) 
( 
    input  wire                 rst         ,

    input  wire                 wr_clk      ,
    input  wire                 wr_en       ,
    input  wire  [WIDTH-1:0]    wr_data     ,

    input  wire                 rd_clk      ,
    input  wire                 rd_en       ,

    output wire  [WIDTH-1:0]    rd_data     ,
    output wire                 full_flag   ,
    output wire                 empty_flag  
);

    wire   [ADDR-1 :0]      wr_add      ;
    wire   [ADDR-1 :0]      rd_add      ;

    wire   [ADDR   :0]      sync_wr_ptr ;
    wire   [ADDR   :0]      sync_rd_ptr ;

    wire   [ADDR   :0]      gr_wr_ptr   ;
    wire   [ADDR   :0]      gr_rd_ptr   ;

    



FIFO_mem #(WIDTH,ADDR) U0_FIFO_mem  (
    .clk            (wr_clk     ),
    //.rst            (rst        ),
     
    .wr_en          (wr_en      ),
    .wr_add         (wr_add     ),
    .wr_data        (wr_data    ),
    .full_flag      (full_flag  ),
     
    //.rd_en        (rd_en      ),
    .rd_add         (rd_add     ),
    //.empty_flag     (empty_flag ),
     
    .rd_data        (rd_data    )
);

full_flag_calc #(ADDR) U1_full_flag_calc (
    .wr_clk         (wr_clk     ),
    .rst            (rst        ),
    
    .wr_en          (wr_en      ),
    
    .sync_rd_ptr    (sync_rd_ptr),
    
    .wr_add         (wr_add     ),
    .gr_wr_ptr      (gr_wr_ptr  ),
    
    .full_flag      (full_flag  )
);

empty_flag_calc #(ADDR) U2_empty_flag_calc (
    .rd_clk         (rd_clk     ),
    .rst            (rst        ),

    .rd_en          (rd_en      ),

    .sync_wr_ptr    (sync_wr_ptr),

    .rd_add         (rd_add     ),
    .gr_rd_ptr      (gr_rd_ptr  ),

    .empty_flag     (empty_flag )
);

sync_wr2rd #(ADDR) U3_sync_wr2rd (
    .rd_clk         (rd_clk     ),
    .rst            (rst        ),

    .gr_wr_ptr      (gr_wr_ptr  ),

    .sync_wr_ptr    (sync_wr_ptr)
);

sync_rd2wr #(ADDR) U4_sync_rd2wr (
    .wr_clk         (wr_clk     ),
    .rst            (rst        ),

    .gr_rd_ptr      (gr_rd_ptr  ),

    .sync_rd_ptr    (sync_rd_ptr)
);

endmodule