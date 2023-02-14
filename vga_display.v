`include "definitions.vh"

module vga_display(
    input wire                                   clk,
    input wire                                   sw_we,
    input wire [`BITS_PER_BLOCK-1:0]             cur_piece,
    input wire [`BITS_BLK_POS-1:0]               cur_blk_1,
    input wire [`BITS_BLK_POS-1:0]               cur_blk_2,
    input wire [`BITS_BLK_POS-1:0]               cur_blk_3,
    input wire [`BITS_BLK_POS-1:0]               cur_blk_4,
    input wire [3:0]                             score_1,
    input wire [3:0]                             score_2,
    input wire [3:0]                             score_3,
    input wire [3:0]                             score_4,
    input wire                                   game_over,
    input wire [(`BLOCKS_WIDE*`BLOCKS_HIGH)-1:0] fallen_pieces,
    input wire [`BITS_PER_BLOCK-1:0]             hold_piece,
    input wire                                   is_holding,
    input wire [`BITS_PER_BLOCK-1:0]             next_piece,
    output wire [11:0]                             rgb,
    output wire                                  hsync,
    output wire                                  vsync
    );
    
    wire [3:0] scores[0:3];
    reg [17:0] score_offset;
    assign scores[0] = score_4;
    assign scores[1] = score_3;
    assign scores[2] = score_2;
    assign scores[3] = score_1;
    
    reg [17:0] sram_addr;
    wire [11:0] data_out;
    reg [11:0] rgb_reg;
    
    sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(85200))
      ram0 (.clk(clk), .we(sw_we), .en(1'b1),
            .addr(sram_addr), .data_i(12'b0), .data_o(data_out));
    assign rgb = rgb_reg;
    
    wire [`BITS_BLK_POS:0] hold_blk_1_x;
    wire [`BITS_BLK_POS:0] hold_blk_1_y;
    wire [`BITS_BLK_POS:0] hold_blk_2_x;
    wire [`BITS_BLK_POS:0] hold_blk_2_y;
    wire [`BITS_BLK_POS:0] hold_blk_3_x;
    wire [`BITS_BLK_POS:0] hold_blk_3_y;
    wire [`BITS_BLK_POS:0] hold_blk_4_x;
    wire [`BITS_BLK_POS:0] hold_blk_4_y;
    cal_hold_block hold(.piece(hold_piece), .view(is_holding),
                       .blk_1_x(hold_blk_1_x),
                       .blk_1_y(hold_blk_1_y),
                       .blk_2_x(hold_blk_2_x),
                       .blk_2_y(hold_blk_2_y),
                       .blk_3_x(hold_blk_3_x),
                       .blk_3_y(hold_blk_3_y),
                       .blk_4_x(hold_blk_4_x),
                       .blk_4_y(hold_blk_4_y)); 
    
    wire [`BITS_BLK_POS:0] next_blk_1_x;
    wire [`BITS_BLK_POS:0] next_blk_1_y;
    wire [`BITS_BLK_POS:0] next_blk_2_x;
    wire [`BITS_BLK_POS:0] next_blk_2_y;
    wire [`BITS_BLK_POS:0] next_blk_3_x;
    wire [`BITS_BLK_POS:0] next_blk_3_y;
    wire [`BITS_BLK_POS:0] next_blk_4_x;
    wire [`BITS_BLK_POS:0] next_blk_4_y;
    cal_next_block next(.piece(next_piece),
                        .blk_1_x(next_blk_1_x),
                        .blk_1_y(next_blk_1_y),
                        .blk_2_x(next_blk_2_x),
                        .blk_2_y(next_blk_2_y),
                        .blk_3_x(next_blk_3_x),
                        .blk_3_y(next_blk_3_y),
                        .blk_4_x(next_blk_4_x),
                        .blk_4_y(next_blk_4_y));

    reg [9:0] counter_x = 0;
    reg [9:0] counter_y = 0;
    reg [17:0] hold_offset;
    reg [17:0] next_offset;
    
 
    assign hsync = ~(counter_x >= (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH) &&
                     counter_x < (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH));
    assign vsync = ~(counter_y >= (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH) &&
                     counter_y < (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH));

    // Combinational logic to select the current pixel
    wire [9:0] cur_blk_index = ((counter_x-`BOARD_POS_X)/`BLOCK_SIZE) + (((counter_y-`BOARD_POS_Y)/`BLOCK_SIZE)*`BLOCKS_WIDE);
    
    always @ (*) begin 
      if (game_over && counter_x >= `BANNER_POS_X && counter_y >= `BANNER_POS_Y && counter_x < (`BANNER_POS_X + (`BANNER_WIDTH<<1)) && counter_y < (`BANNER_POS_Y + (`BANNER_HEIGHT<<1))) begin
        sram_addr = `OVER_POS + ((counter_x-`BANNER_POS_X)>>1) + ((counter_y-`BANNER_POS_Y)>>1)*(`BANNER_WIDTH);
      end
      else if (counter_x >= `BOARD_POS_X && counter_y >= `BOARD_POS_Y && 
          counter_y < (`BOARD_POS_Y+`BOARD_HEIGHT) && counter_x < (`BOARD_POS_X+`BOARD_WIDTH)) begin
          if (cur_blk_index == cur_blk_1 ||
              cur_blk_index == cur_blk_2 ||
              cur_blk_index == cur_blk_3 ||
              cur_blk_index == cur_blk_4) begin
              case (cur_piece)
                `I_BLOCK: sram_addr = `BLUE_POS;
                `O_BLOCK: sram_addr = `YELLOW_POS;
                `T_BLOCK: sram_addr = `DRED_POS;
                `S_BLOCK: sram_addr = `GREEN_POS;
                `Z_BLOCK: sram_addr = `RED_POS;
                `J_BLOCK: sram_addr = `DBLUE_POS;
                `L_BLOCK: sram_addr = `DYELLOW_POS;
              endcase
              sram_addr = sram_addr + (counter_x>>1)%10 + ((counter_y>>1)%10)*`BLK_WIDTH;
          end
          else begin
            if (fallen_pieces[cur_blk_index]) begin
              sram_addr = `DGREEN_POS + (counter_x>>1)%10 + ((counter_y>>1)%10)*`BLK_WIDTH;
            end else begin
              sram_addr = `BG_POS + (counter_x>>1)+(counter_y>>1)*`BG_WIDTH;
            end
          end
      end
      else if (counter_x >= `SCORE_POS_X && counter_y >= `SCORE_POS_Y && counter_x < `SCORE_POS_X+`FOUR_SCORE_WIDTH && counter_y < `SCORE_POS_Y+`FOUR_SCORE_HEIGHT) begin
        if ((counter_x>>1) == 49 || (counter_x>>1) == 64 || (counter_x>>1) == 79) sram_addr = `BG_POS + (counter_x>>1)+(counter_y>>1)*`BG_WIDTH;
        else sram_addr = scores[((counter_x-`SCORE_POS_X)>>1)/(`NUM_WIDTH+1)]*(`NUM_WIDTH*`NUM_HEIGHT) + `NUM_POS + score_offset;
      end
      else if ((!game_over) && is_holding && counter_x >= hold_blk_1_x && counter_y >= hold_blk_1_y && counter_x < (hold_blk_1_x + `BLOCK_SIZE) && counter_y < (hold_blk_1_y + `BLOCK_SIZE)) begin
        sram_addr = hold_offset + ((counter_x-hold_blk_1_x)>>1) + ((counter_y-hold_blk_1_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && is_holding && counter_x >= hold_blk_2_x && counter_y >= hold_blk_2_y && counter_x < (hold_blk_2_x + `BLOCK_SIZE) && counter_y < (hold_blk_2_y + `BLOCK_SIZE)) begin
        sram_addr = hold_offset + ((counter_x-hold_blk_2_x)>>1) + ((counter_y-hold_blk_2_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && is_holding && counter_x >= hold_blk_3_x && counter_y >= hold_blk_3_y && counter_x < (hold_blk_3_x + `BLOCK_SIZE) && counter_y < (hold_blk_3_y + `BLOCK_SIZE)) begin
        sram_addr = hold_offset + ((counter_x-hold_blk_3_x)>>1) + ((counter_y-hold_blk_3_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && is_holding && counter_x >= hold_blk_4_x && counter_y >= hold_blk_4_y && counter_x < (hold_blk_4_x + `BLOCK_SIZE) && counter_y < (hold_blk_4_y + `BLOCK_SIZE)) begin
        sram_addr = hold_offset + ((counter_x-hold_blk_4_x)>>1) + ((counter_y-hold_blk_4_y)>>1)*`BLK_WIDTH;
      end  //holdend
      else if ((!game_over) && counter_x >= next_blk_1_x && counter_y >= next_blk_1_y && counter_x < (next_blk_1_x + `BLOCK_SIZE) && counter_y < (next_blk_1_y + `BLOCK_SIZE)) begin
        sram_addr = next_offset + ((counter_x-next_blk_1_x)>>1) + ((counter_y-next_blk_1_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && counter_x >= next_blk_2_x && counter_y >= next_blk_2_y && counter_x < (next_blk_2_x + `BLOCK_SIZE) && counter_y < (next_blk_2_y + `BLOCK_SIZE)) begin
        sram_addr = next_offset + ((counter_x-next_blk_2_x)>>1) + ((counter_y-next_blk_2_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && counter_x >= next_blk_3_x && counter_y >= next_blk_3_y && counter_x < (next_blk_3_x + `BLOCK_SIZE) && counter_y < (next_blk_3_y + `BLOCK_SIZE)) begin
        sram_addr = next_offset + ((counter_x-next_blk_3_x)>>1) + ((counter_y-next_blk_3_y)>>1)*`BLK_WIDTH;
      end
      else if ((!game_over) && counter_x >= next_blk_4_x && counter_y >= next_blk_4_y && counter_x < (next_blk_4_x + `BLOCK_SIZE) && counter_y < (next_blk_4_y + `BLOCK_SIZE)) begin
        sram_addr = next_offset + ((counter_x-next_blk_4_x)>>1) + ((counter_y-next_blk_4_y)>>1)*`BLK_WIDTH;
      end        
      else begin
        sram_addr = `BG_POS + (counter_x>>1) + (counter_y>>1)*`BG_WIDTH;
      end
    end
    
    always @ (*) begin
      case (hold_piece)
                `I_BLOCK: hold_offset = `BLUE_POS;
                `O_BLOCK: hold_offset = `YELLOW_POS;
                `T_BLOCK: hold_offset = `DRED_POS;
                `S_BLOCK: hold_offset = `GREEN_POS;
                `Z_BLOCK: hold_offset = `RED_POS;
                `J_BLOCK: hold_offset = `DBLUE_POS;
                `L_BLOCK: hold_offset = `DYELLOW_POS;
      endcase
    end
    
    always @ (*) begin
      case (next_piece)
                `I_BLOCK: next_offset = `BLUE_POS;
                `O_BLOCK: next_offset = `YELLOW_POS;
                `T_BLOCK: next_offset = `DRED_POS;
                `S_BLOCK: next_offset = `GREEN_POS;
                `Z_BLOCK: next_offset = `RED_POS;
                `J_BLOCK: next_offset = `DBLUE_POS;
                `L_BLOCK: next_offset = `DYELLOW_POS;
      endcase
    end
    
    always @ (*) begin
      score_offset = ((counter_x-`SCORE_POS_X)>>1)%(`NUM_WIDTH+1) + ((counter_y -`SCORE_POS_Y)>>1)*(`NUM_WIDTH);
    end

    always @ (posedge clk) begin
         if (counter_x >= `PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH + `HSYNC_BACK_PORCH) begin
             counter_x <= 0;
             if (counter_y >= `PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH + `VSYNC_BACK_PORCH) begin
                 counter_y <= 0;
             end else begin
                 counter_y <= counter_y + 1;
             end
         end else begin
             counter_x <= counter_x + 1;
         end
    end
   
    always @ (*) begin
        if (counter_x < `PIXEL_WIDTH && counter_y < `PIXEL_HEIGHT)
            rgb_reg = data_out;
        else
            rgb_reg = 12'h000;
    end

endmodule
