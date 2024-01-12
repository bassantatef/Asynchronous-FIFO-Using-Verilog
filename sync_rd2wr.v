module sync_rd2wr #( parameter  ADDR = 4 ) 
(
    input  wire                 wr_clk      ,
    input  wire                 rst         ,
    
    input  wire  [ADDR   :0]    gr_rd_ptr   ,

    output reg   [ADDR   :0]    sync_rd_ptr 
);
    
    reg [ADDR :0]    rd_ptr_1 ;

always @(posedge wr_clk or negedge rst) begin
    if(!rst) begin
        rd_ptr_1    <= {ADDR+1{1'b0}} ;
        sync_rd_ptr <= {ADDR+1{1'b0}} ;
    end
    else begin
        rd_ptr_1    <= gr_rd_ptr ;
        sync_rd_ptr <= rd_ptr_1  ;
    end
end

endmodule