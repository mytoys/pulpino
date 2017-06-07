`timescale 1ns/10ps

module tb;


logic clk;
logic reset;
logic fetch_en;

//initial begin
//    $display("memory initialazation");
//    $readmemh("/home/fdi/halley/mysoc/fpga/arty_pulpino/mem.txt", tb.DUT.u_pulpino.pulpino_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.mem);
//end

initial begin
    clk = 1'b0;
    reset = 1'b1;
    fetch_en = 1'b0;
    #150
    reset = 1'b0;
    #10000
    fetch_en = 1'b1;
end

always #5 clk = ~clk;

logic uart_tx;
logic uart_rx;
wire pll_locked;

wire [3:0] sw;
wire [3:0] btn;
wire [3:0] led;

assign sw[3] = {fetch_en};
assign sw[2] = 1'b0;
assign sw[1] = 1'b0;
assign sw[0] = 1'b0;

assign btn[3] = {reset};
assign btn[2] = 1'b0;
assign btn[1] = 1'b0;
assign btn[0] = 1'b0;

assign pll_locked = led[3];

arty_top u_DUT (
    .xtal_in ( clk     ) ,
    .led     ( led     ) ,
    .sw      ( sw      ) ,
    .btn     ( btn     ) ,
    .uart_rx ( uart_rx ) ,
    .uart_tx ( uart_tx ) 
);

 parameter  BAUDRATE      = 1562500; // 781250; // 1562500
  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(BAUDRATE),
    .PARITY_EN(0)
  )
  uart
  (
    .rx         ( uart_tx ),
    .tx         ( uart_rx ),
    .rx_en      ( 1'b1    )
  );

endmodule
