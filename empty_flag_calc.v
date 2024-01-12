module empty_flag_calc #( parameter  ADDR = 4) 
(
    input  wire                 rd_clk      ,
    input  wire                 rst         ,

    input  wire                 rd_en       ,

    input  wire  [ADDR   :0]    sync_wr_ptr ,

    output wire  [ADDR-1 :0]    rd_add      ,
    output wire  [ADDR   :0]    gr_rd_ptr   ,

    output reg                  empty_flag   
);

    wire [ADDR :0]    bin_wr_ptr  ;

    wire [ADDR+1 :0]    rd_add_comb ;

    reg  [ADDR :0]    rd_add_tmp  ;

    wire              empty       ;

// gray encoding to binary converting

genvar i;
generate
    for(i=0 ; i<ADDR+1 ; i=i+1) begin: gray2bin
        assign bin_wr_ptr[i] = ^(sync_wr_ptr >> i) ;
    end
endgenerate

// increment read pointer at rd_en

assign rd_add_comb = rd_add_tmp + (rd_en & !empty_flag) ;

always @(posedge rd_clk or negedge rst) begin
    if(!rst) begin
        rd_add_tmp <= {ADDR{1'b0}} ;
    end
    else if (rd_en && !empty) begin 
        rd_add_tmp <= rd_add_comb[ADDR :0] ;
    end
end


always @(posedge rd_clk or negedge rst) begin
    if(!rst) begin
        empty_flag <= 1'b1 ;
    end
    else begin
        empty_flag <= empty ;
    end      
end

// binary to gray encoding  converting
assign gr_rd_ptr = rd_add_comb[ADDR :0] ^ (rd_add_comb[ADDR :0] >> 1) ;

// full flag calculation
assign empty = (rd_add_comb[ADDR :0] == (bin_wr_ptr)) ;

// send the read address to the memory without the MSB that is used for empty flag only
assign rd_add = rd_add_tmp[ADDR-1:0] ;

endmodule