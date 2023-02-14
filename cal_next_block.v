`include "definitions.vh"

module cal_next_block(
    input wire [`BITS_PER_BLOCK-1:0] piece,
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
                 blk_1_y <= 180;
                 blk_2_x <= 470;
                 blk_2_y <= 180;
                 blk_3_x <= 490;
                 blk_3_y <= 180;
                 blk_4_x <= 510;
                 blk_4_y <= 180;
            end
            `O_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 170;
                 blk_2_x <= 500;
                 blk_2_y <= 170;
                 blk_3_x <= 480;
                 blk_3_y <= 190;
                 blk_4_x <= 500;
                 blk_4_y <= 190;
            end
            `T_BLOCK: begin
                 blk_1_x <= 460;
                 blk_1_y <= 170;
                 blk_2_x <= 480;
                 blk_2_y <= 170;
                 blk_3_x <= 500;
                 blk_3_y <= 170;
                 blk_4_x <= 480;
                 blk_4_y <= 190;
            end
            `S_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 170;
                 blk_2_x <= 500;
                 blk_2_y <= 170;
                 blk_3_x <= 460;
                 blk_3_y <= 190;
                 blk_4_x <= 480;
                 blk_4_y <= 190;
            
            end
            `Z_BLOCK: begin
                 blk_1_x <= 480;
                 blk_1_y <= 190;
                 blk_2_x <= 500;
                 blk_2_y <= 190;
                 blk_3_x <= 460;
                 blk_3_y <= 170;
                 blk_4_x <= 480;
                 blk_4_y <= 170;                   
            end
            `J_BLOCK: begin
                 blk_1_x <= 460;
                 blk_1_y <= 170;
                 blk_2_x <= 460;
                 blk_2_y <= 190;
                 blk_3_x <= 480;
                 blk_3_y <= 190;
                 blk_4_x <= 500;
                 blk_4_y <= 190;
            end
            `L_BLOCK: begin
                 blk_1_x <= 500;
                 blk_1_y <= 170;
                 blk_2_x <= 460;
                 blk_2_y <= 190;
                 blk_3_x <= 480;
                 blk_3_y <= 190;
                 blk_4_x <= 500;
                 blk_4_y <= 190;                      
            end
        endcase
      end

endmodule

