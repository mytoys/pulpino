module arty_top (
    input xtal_in, // 100MHz

    input [3:0] sw,  // Switches
    input [3:0] btn, // Buttons
    output [3:0] led, // LEDs

    output uart_tx, 
    input  uart_rx

);


// JTAG
wire tck_i   = 1'b0; 
wire trst_ni = 1'b0; 
wire tms_i   = 1'b0; 
wire td_i    = 1'b0; 
wire td_o    ; 

// SPI slave 
wire spi_clk = 1'b0;
wire spi_cs = 1'b0;
wire [3:0] spi_din = 4'd0;
wire [3:0] spi_dout;
wire [1:0] spi_mode;

// SPI Master
wire spi_master_clk;
wire [3:0] spi_master_cs_n;
wire [3:0] spi_master_din = 4'd0;
wire [3:0] spi_master_dout;
wire [1:0] spi_master_mode;

// I2C
wire scl_in = 1'b0;
wire scl_out;
wire scl_oen;
wire sda_in = 1'b0;
wire sda_out;
wire sda_oen;

// GPIO
wire [31:0] gpio_in = 32'd0;
wire [31:0] gpio_out;
wire [31:0] gpio_dir;

// UART
wire uart_rts;
wire uart_dtr;
wire uart_cts = 1'b0;
wire uart_dsr = 1'b0;

// Switches
wire fetch_en = sw[3]; // sw[3] : fetech enable, high active
// wire = sw[2]; // sw[2] : 
// wire = sw[1]; // sw[1] : 
// wire = sw[0]; // sw[0] : 

wire reset_n = ~btn[3]; // btn[3] : global hardware reset, low active
// wire = btn[2]; // btn[2] : 
// wire = btn[1]; // btn[1] : 
// wire = btn[0]; // btn[0] : 

// LEDs
assign led[3] = pll_locked; // LED[3]: pll clocked
assign led[2] = uart_tx;    // LED[2]: uart tx
assign led[1] = 1'b0;
assign led[0] = 1'b0;

wire clk_cpu;

// clk_wiz
arty_mmcm u_mmcm (
    .clk_in1  ( xtal_in     ) ,
    .clk_out1 ( clk_cpu     ) , // 50MHz
    .resetn   ( reset_n     ) ,
    .locked   ( pll_locked  ) 
 );
  

// PULPino SoC
pulpino u_pulpino (
    .clk               ( clk_cpu             ) ,
    .rst_n             ( reset_n             ) ,

    .fetch_enable_i    ( fetch_en            ) ,

    .tck_i             ( tck_i               ) ,
    .trstn_i           ( trst_ni             ) ,
    .tms_i             ( tms_i               ) ,
    .tdi_i             ( td_i                ) ,
    .tdo_o             ( td_o                ) ,

    .spi_clk_i         ( spi_clk             ) ,
    .spi_cs_i          ( spi_cs              ) ,
    .spi_mode_o        ( spi_mode            ) ,
    .spi_sdi0_i        ( spi_din[0]          ) ,
    .spi_sdi1_i        ( spi_din[1]          ) ,
    .spi_sdi2_i        ( spi_din[2]          ) ,
    .spi_sdi3_i        ( spi_din[3]          ) ,
    .spi_sdo0_o        ( spi_dout[0]         ) ,
    .spi_sdo1_o        ( spi_dout[1]         ) ,
    .spi_sdo2_o        ( spi_dout[2]         ) ,
    .spi_sdo3_o        ( spi_dout[3]         ) ,

    .spi_master_clk_o  ( spi_master_clk      ) ,
    .spi_master_csn0_o ( spi_master_cs_n[0]  ) ,
    .spi_master_csn1_o ( spi_master_cs_n[1]  ) ,
    .spi_master_csn2_o ( spi_master_cs_n[2]  ) ,
    .spi_master_csn3_o ( spi_master_cs_n[3]  ) ,
    .spi_master_mode_o ( spi_master_mode     ) ,
    .spi_master_sdi0_i ( spi_master_din[0]  ) ,
    .spi_master_sdi1_i ( spi_master_din[1]  ) ,
    .spi_master_sdi2_i ( spi_master_din[2]  ) ,
    .spi_master_sdi3_i ( spi_master_din[3]  ) ,
    .spi_master_sdo0_o ( spi_master_dout[0] ) ,
    .spi_master_sdo1_o ( spi_master_dout[1] ) ,
    .spi_master_sdo2_o ( spi_master_dout[2] ) ,
    .spi_master_sdo3_o ( spi_master_dout[3] ) ,

    .scl_i             ( scl_in              ) ,
    .scl_o             ( scl_out             ) ,
    .scl_oen_o         ( scl_oen             ) ,
    .sda_i             ( sda_in              ) ,
    .sda_o             ( sda_out             ) ,
    .sda_oen_o         ( sda_oen             ) ,

    .gpio_in           ( gpio_in             ) ,
    .gpio_out          ( gpio_out            ) ,
    .gpio_dir          ( gpio_dir            ) ,

    .uart_tx           ( uart_tx             ) , // output
    .uart_rx           ( uart_rx             ) , // input
    .uart_rts          ( uart_rts            ) , // output
    .uart_dtr          ( uart_dtr            ) , // output
    .uart_cts          ( uart_cts            ) , // input
    .uart_dsr          ( uart_dsr            )   // input
);

endmodule

