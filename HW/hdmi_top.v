`default_nettype none
module hdmi_top(
  input   wire        clk,
  input   wire        rst,
  input   wire  [1:0] pattern_sel,
  output  wire        hdmi_clk_n,
  output  wire        hdmi_clk_p,
  output  wire  [2:0] hdmi_tx_n,
  output  wire  [2:0] hdmi_tx_p
);

wire        clk_74_25MHz, clk_371_25MHz;
wire        locked;
wire        hsync, vsync, vde, vga_hsync, vga_vsync;
wire  [7:0] red, green, blue;
wire  [$clog2(1650)-1:0] vga_col;
wire  [$clog2(750)-1:0]  vga_row;

//clock wizard configured with a 1x and 5x clock
clk_wiz_0 clk_wiz (
  .clk_out1 (clk_74_25MHz),
  .clk_out2 (clk_371_25MHz),
  .reset    (rst),
  .locked   (locked),
  .clk_in1  (clk)
);

//Real Digital VGA to HDMI converter
hdmi_tx_0 vga_to_hdmi (
  //Clocking and Reset
  .pix_clk        (clk_74_25MHz),
  .pix_clkx5      (clk_371_25MHz),
  .pix_clk_locked (locked),
  //Reset is active HIGH
  .rst            (rst),
  //Color and Sync Signals
  .red            (red),
  .green          (green),
  .blue           (blue),
  .hsync          (hsync),
  .vsync          (vsync),
  .vde            (vde),
  //aux Data (unused)
  .aux0_din       (4'b0),
  .aux1_din       (4'b0),
  .aux2_din       (4'b0),
  .ade            (1'b0),
  //Differential outputs
  .TMDS_CLK_P     (hdmi_clk_p),          
  .TMDS_CLK_N     (hdmi_clk_n),          
  .TMDS_DATA_P    (hdmi_tx_p),         
  .TMDS_DATA_N    (hdmi_tx_n)          
);

//VGA Sync signal generator
//Dimensions: 1280x720 
vga_timing_720 #(
  .HVID (1280),
  .HFP  (110),
  .HS   (40),
  .HBP  (220),
  .VVID (720),
  .VFP  (5),
  .VS   (5),
  .VBP  (20)
) vga (
  .clk        (clk_74_25MHz),
  .reset      (rst),
  .hsync      (vga_hsync),
  .vsync      (vga_vsync),
  .col        (vga_col),
  .row        (vga_row),
  .vid_active (vde)
);

colourbar_gen bars(
  .vga_col      (vga_col),
  .vga_row      (vga_row),
  .vde          (vde),
  .pattern_sel  (pattern_sel),
  .red          (red),
  .green        (green),
  .blue         (blue)
);

assign hsync = vga_hsync;      // Polarity of horizontal sync pulse is negative.
assign vsync = vga_vsync;      // Polarity of vertical sync pulse is negative.
endmodule 
