module sync_wr2rd #( parameter  ADDR = 4 ) 
(
    input  wire                 rd_clk      ,
    input  wire                 rst         ,
    
    input  wire  [ADDR   :0]    gr_wr_ptr   ,

    output reg   [ADDR   :0]    sync_wr_ptr 
);
    
    reg [ADDR :0]    wr_ptr_1 ;

always @(posedge rd_clk or negedge rst) begin
    if(!rst) begin
        wr_ptr_1    <= {ADDR+1{1'b0}} ;
        sync_wr_ptr <= {ADDR+1{1'b0}} ;
    end
    else begin
        wr_ptr_1    <= gr_wr_ptr ;
        sync_wr_ptr <= wr_ptr_1  ;
    end
end

endmodule