module full_flag_calc #( parameter  ADDR = 4) 
(
    input  wire                 wr_clk      ,
    input  wire                 rst         ,

    input  wire                 wr_en       ,

    input  wire  [ADDR   :0]    sync_rd_ptr ,

    output wire  [ADDR-1 :0]    wr_add      ,
    output wire  [ADDR   :0]    gr_wr_ptr   ,

    output reg                  full_flag   
);

    wire [ADDR :0]    bin_rd_ptr ;

    wire [ADDR+1:0]    wr_add_comb ;

    reg  [ADDR :0]    wr_add_tmp ;

    wire              full       ;

// gray encoding to binary converting

genvar i;
generate
    for(i=0 ; i<ADDR+1 ; i=i+1) begin: gray2bin
        assign bin_rd_ptr[i] = ^(sync_rd_ptr >> i) ;
    end
endgenerate

// increment write pointer at wr_en

assign wr_add_comb = wr_add_tmp + (wr_en && !full_flag) ;

always @(posedge wr_clk or negedge rst) begin
    if(!rst) begin
        wr_add_tmp <= {ADDR{1'b0}} ;
    end
    else if (wr_en && !full_flag) begin
        wr_add_tmp <= wr_add_comb[ADDR :0] ;
    end
end


always @(posedge wr_clk or negedge rst) begin
    if(!rst) begin
        full_flag <= 1'b0 ;
    end
    else begin
        full_flag <= full ;
    end      
end

// binary to gray encoding  converting
assign gr_wr_ptr = wr_add_comb[ADDR :0] ^ (wr_add_comb[ADDR :0] >> 1) ;

// full flag calculation
assign full = (wr_add_comb[ADDR] != bin_rd_ptr[ADDR]) &&(wr_add_comb[ADDR-1:0] == bin_rd_ptr[ADDR-1:0]) ;

// send the write address to the memory without the MSB that is used for full flag only
assign wr_add = wr_add_tmp[ADDR-1:0] ;

endmodule