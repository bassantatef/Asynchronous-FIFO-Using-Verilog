module FIFO_mem #(parameter     WIDTH = 8 ,
                                ADDR  = 4) 
(
    input  wire                 clk         ,
    //input  wire                 rst         ,

    input  wire                 wr_en       ,
    input  wire  [ADDR-1 :0]    wr_add      ,
    input  wire  [WIDTH-1:0]    wr_data     ,
    input  wire                 full_flag   ,

    //input  wire                 rd_en       ,
    input  wire  [ADDR-1 :0]    rd_add      ,
    //input  wire                 empty_flag  ,

    output wire  [WIDTH-1:0]    rd_data     
);

    localparam MEM_DEPTH = 1 << ADDR ;
    
    reg [WIDTH-1:0] mem [0:MEM_DEPTH-1] ;

always @(posedge clk) begin
    if(wr_en && !full_flag) begin
        mem[wr_add] <= wr_data ;
    end
end

assign rd_data = mem[rd_add] ;

endmodule