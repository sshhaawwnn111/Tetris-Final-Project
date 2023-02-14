`include "definitions.vh"

module calc_cur_blk(
    input wire [`BITS_PER_BLOCK-1:0] piece,
    input wire [3:0] pos_x,
    input wire [4:0] pos_y,
    input wire [1:0] rot,
    output reg [7:0] blk_1,
    output reg [7:0] blk_2,
    output reg [7:0] blk_3,
    output reg [7:0] blk_4,
    output reg [2:0] width,
    output reg [2:0] height,
    output reg [2:0] l_width,
    output reg [2:0] u_height
    );
    
    always @ (*) begin
        case (piece)
            `EMPTY_BLOCK: begin
                 blk_1 = `ERR_BLK_POS;
                 blk_2 = `ERR_BLK_POS;
                 blk_3 = `ERR_BLK_POS;
                 blk_4 = `ERR_BLK_POS;
                 width = 0;
                 height = 0;
                 l_width = 0;
                 u_height = 0;
            end
            `I_BLOCK: begin
                case (rot)
                    0: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 2) * `BLOCKS_WIDE) + pos_x;
                        width = 1;
                        height = 3;
                        l_width = 1;
                        u_height = 2;
                    end
                    1: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 2;
                        width = 3;
                        height = 1;
                        l_width = 2;
                        u_height = 1;
                    end
                    2: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x + 1;
                        end
                        else begin
                            blk_1 = pos_x + 1;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 2) * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 3;
                        l_width = 0;
                        u_height = 2;
                    end
                    3: begin
                        blk_1 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 2;
                        blk_2 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x - 1;
                        width = 3;
                        height = 2;
                        l_width = 2;
                        u_height = 0;
                    end
                endcase
            end
            `O_BLOCK: begin
                blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x;
                blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                width = 2;
                height = 2;
                l_width = 1;
                u_height = 1;
            end
            `T_BLOCK: begin
                case (rot)
                    0: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 1;
                        l_width = 2;
                        u_height = 2;
                    end
                    1: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = ((pos_y) * `BLOCKS_WIDE) + pos_x;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 2;
                        l_width = 1;
                        u_height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 2;
                        height = 2;
                        l_width = 2;
                        u_height = 1;
                    end
                    3: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 1;
                        height = 2;
                        l_width = 2;
                        u_height = 2;
                    end
                endcase
            end
            `S_BLOCK: begin
                case (rot)
                    0: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        if(pos_y > 0) begin
                            blk_2 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x + 1;
                        end
                        else begin
                            blk_2 = pos_x;
                        end
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        width = 2;
                        height = 1;
                        l_width = 2;
                        u_height = 2;
                    end
                    1: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 2;
                        l_width = 1;
                        u_height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x - 1;
                        width = 2;
                        height = 2;
                        l_width = 2;
                        u_height = 1;
                    end
                    3: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x - 1;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 1;
                        height = 2;
                        l_width = 2;
                        u_height = 2;
                    end
                endcase
            end
            `Z_BLOCK: begin
                case (rot)
                    0: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x - 1;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        if(pos_y > 0) begin
                            blk_2 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_2 = pos_x;
                        end
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 1;
                        l_width = 2;
                        u_height = 2;
                    end
                    1: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x + 1;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 2;
                        height = 2;
                        l_width = 1;
                        u_height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 2;
                        l_width = 2;
                        u_height = 1;
                    end
                    3: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x - 1;
                        width = 1;
                        height = 2;
                        l_width = 2;
                        u_height = 2;
                    end
                endcase
            end
            `J_BLOCK: begin
                case (rot)
                    0: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x - 1;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 1;
                        l_width = 2;
                        u_height = 2;
                    end
                    1: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        if(pos_y > 0) begin
                            blk_2 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x + 1;
                        end
                        else begin
                            blk_2 = pos_x;
                        end
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 2;
                        height = 2;
                        l_width = 1;
                        u_height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 2;
                        l_width = 2;
                        u_height = 1;
                    end
                    3: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x - 1;
                        width = 1;
                        height = 2;
                        l_width = 2;
                        u_height = 2;
                    end
                endcase
            end
            `L_BLOCK: begin
                case (rot)
                    0: begin
                         if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x + 1;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_4 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        width = 2;
                        height = 1;
                        l_width = 2;
                        u_height = 2;
                    end
                    1: begin
                        blk_1 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x + 1;
                        blk_2 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        if(pos_y > 0) begin
                            blk_4 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_4 = pos_x;
                        end
                        width = 2;
                        height = 2;
                        l_width = 1;
                        u_height = 2;
                    end
                    2: begin
                        blk_1 = (pos_y * `BLOCKS_WIDE) + pos_x - 1;
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        blk_3 = (pos_y * `BLOCKS_WIDE) + pos_x + 1;
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x - 1;
                        width = 2;
                        height = 2;
                        l_width = 2;
                        u_height = 1;
                    end
                    3: begin
                        if(pos_y > 0) begin
                            blk_1 = ((pos_y - 1)* `BLOCKS_WIDE) + pos_x;
                        end
                        else begin
                            blk_1 = pos_x;
                        end
                        blk_2 = (pos_y * `BLOCKS_WIDE) + pos_x;
                        if(pos_y > 0) begin
                            blk_3 = ((pos_y - 1) * `BLOCKS_WIDE) + pos_x - 1;
                        end
                        else begin
                            blk_3 = pos_x;
                        end
                        blk_4 = ((pos_y + 1) * `BLOCKS_WIDE) + pos_x;
                        width = 1;
                        height = 2;
                        l_width = 2;
                        u_height = 2;
                    end
                endcase
            end
        endcase
    end

endmodule
