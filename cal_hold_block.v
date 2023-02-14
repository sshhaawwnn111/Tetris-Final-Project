`include "definitions.vh"

module cal_hold_block(
    input wire [`BITS_PER_BLOCK-1:0] piece,
    input wire view,
    output reg [`BITS_BLK_POS:0] blk_1_x,
    output reg [`BITS_BLK_POS:0] blk_1_y,
    output reg [`BITS_BLK_POS:0] blk_2_x,
    output reg [`BITS_BLK_POS:0] blk_2_y,
    output reg [`BITS_BLK_POS:0] blk_3_x,
    output reg [`BITS_BLK_POS:0] blk_3_y,
    output reg [`BITS_BLK_POS:0] blk_4_x,
    output reg [`BITS_BLK_POS:0] blk_4_y 
    );
    always @ (*) begin
      if(view) begin
        case (piece)
            `EMPTY_BLOCK: begin
                 blk_1_x <= 0;
                 blk_1_y <= 0;
                 blk_2_x <= 0;
                 blk_2_y <= 0;
                 blk_3_x <= 0;
                 blk_3_y <= 0;
                 blk_4_x <= 0;
                 blk_4_y <= 0;
            end
            `I_BLOCK: begin
                 blk_1_x <= 450;
                 blk_1_y <= 80;
                 blk_2_x <= 470;
                 blk_2_y <= 80;
                 blk_3_x <= 490;
                 blk_3_y <= 80;
                 blk_4_x <= 510;
                 blk_4_y <= 80;
            end
            `O_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 70;
                 blk_2_x <= 500;
                 blk_2_y <= 70;
                 blk_3_x <= 480;
                 blk_3_y <= 90;
                 blk_4_x <= 500;
                 blk_4_y <= 90;
            end
            `T_BLOCK: begin
                 blk_1_x <= 460;
                 blk_1_y <= 70;
                 blk_2_x <= 480;
                 blk_2_y <= 70;
                 blk_3_x <= 500;
                 blk_3_y <= 70;
                 blk_4_x <= 480;
                 blk_4_y <= 90;
            end
            `S_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 70;
                 blk_2_x <= 500;
                 blk_2_y <= 70;
                 blk_3_x <= 460;
                 blk_3_y <= 90;
                 blk_4_x <= 480;
                 blk_4_y <= 90;
            
            end
            `Z_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 90;
                 blk_2_x <= 500;
                 blk_2_y <= 90;
                 blk_3_x <= 460;
                 blk_3_y <= 70;
                 blk_4_x <= 480;
                 blk_4_y <= 70;                   
            end
            `J_BLOCK: begin
                 blk_1_x <= 460;
                 blk_1_y <= 70;
                 blk_2_x <= 460;
                 blk_2_y <= 90;
                 blk_3_x <= 480;
                 blk_3_y <= 90;
                 blk_4_x <= 500;
                 blk_4_y <= 90;
            end
            `L_BLOCK: begin
                 blk_1_x <= 500;
                 blk_1_y <= 70;
                 blk_2_x <= 460;
                 blk_2_y <= 90;
                 blk_3_x <= 480;
                 blk_3_y <= 90;
                 blk_4_x <= 500;
                 blk_4_y <= 90;                      
            end
        endcase
      end
    end
endmodule

