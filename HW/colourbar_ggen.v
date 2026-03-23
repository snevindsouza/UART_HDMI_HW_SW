module colourbar_gen(
  input   wire [$clog2(1650)-1:0] vga_col,
  input   wire [$clog2(750)-1:0]  vga_row,
  input   wire                    vde,
  input   wire [1:0]              pattern_sel, 
  output  reg  [7:0]              red, green, blue
);

wire [10:0] x = vga_col;
wire [9:0]  y = vga_row;

// Vertical bars
wire [2:0] bar = x / 160;

// Checkerboard
wire [4:0] x_block = x >> 6; // ~64 pixels (faster than /80)
wire [4:0] y_block = y >> 6;
wire checker = x_block[0] ^ y_block[0];

always @(*) begin
  red = 0; green = 0; blue = 0;
  if(vde) begin
    case(pattern_sel)
      // 0 → WHITE
      2'd0: begin
        red   = 8'hFF;
        green = 8'hFF;
        blue  = 8'hFF;
      end
      // 1 → VERTICAL BARS
      2'd1: begin
        case(bar)
          3'd0: begin red=8'hFF; green=0;     blue=0;     end
          3'd1: begin red=8'hFF; green=8'h7F; blue=0;     end
          3'd2: begin red=8'hFF; green=8'hFF; blue=0;     end
          3'd3: begin red=0;     green=8'hFF; blue=0;     end
          3'd4: begin red=0;     green=0;     blue=8'hFF; end
          3'd5: begin red=8'h4B; green=0;     blue=8'h82; end
          3'd6: begin red=8'h8F; green=0;     blue=8'hFF; end
          3'd7: begin red=8'hFF; green=8'hFF; blue=8'hFF; end
        endcase
      end
      // 2 → CHECKERBOARD
      2'd2: begin
        if(checker) begin
          red   = 8'hFF;
          green = 8'hFF;
          blue  = 8'hFF;
        end
      end
      // 3 → CUSTOM (placeholder)
      2'd3: begin
        red   = x[7:0];   // gradient example
        green = y[7:0];
        blue  = 8'h00;
      end
    endcase
  end
end

endmodule