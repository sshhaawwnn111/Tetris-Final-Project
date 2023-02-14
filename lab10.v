`include "definitions.vh"

module tetris(
    input wire        clk_too_fast,
    input wire        btn_rotate,
    input wire        btn_left,
    input wire        btn_right,
    input wire        btn_down,
    input wire        sw_pause, //sw0
    input wire        sw_rst,  //sw1
    input wire        sw_hold, //sw2
    input wire        sw_we,   //sw3
    input wire        reset_n,
    output wire [3:0]  usr_led,
    output wire [11:0] rgb,
    output wire        hsync,
    output wire        vsync
    );
    
    // Divides the clock into 25 MHz
    reg clk_count;
    reg clk;
    initial begin
        clk_count = 0;
        clk = 0;
    end
    always @ (posedge clk_too_fast) begin
        clk_count <= ~clk_count;
        if (clk_count) begin
            clk <= ~clk;
        end
    end

    // Increments once per cycle to a maximum value. If this is
    // not yet at the maximum value, we cannot go into drop mode.
    reg [31:0] drop_timer;
    initial begin
        drop_timer = 0;
    end

    // This signal random_piece rotates between the types
    // of pieces at 100 MHz, and is selected based on user input,
    // making it effectively random.
    wire [`BITS_PER_BLOCK-1:0] random_piece;
    randomizer randomizer_ (
        .clk(clk),
        .random(random_piece)
    );

    // The enable signals for the five buttons, after
    // they have gone through the debouncer. Should only be high
    // for one cycle for each button press.
    wire btn_rotate_en;
    wire btn_rotate_dis;
    wire btn_left_en;
    wire btn_left_dis;
    wire btn_right_en;
    wire btn_right_dis;
    wire btn_down_en;
    wire btn_down_dis;
    // Debounce all of the input signals
    debouncer debouncer_btn_rotate_ (
        .raw(btn_rotate),
        .clk(clk),
        .enabled(btn_rotate_en),
        .disabled(btn_rotate_dis)
    );
    debouncer debouncer_btn_left_ (
        .raw(btn_left),
        .clk(clk),
        .enabled(btn_left_en),
        .disabled(btn_left_dis)
    );
    debouncer debouncer_btn_right_ (
        .raw(btn_right),
        .clk(clk),
        .enabled(btn_right_en),
        .disabled(btn_right_dis)
    );
    debouncer debouncer_btn_down_ (
        .raw(btn_down),
        .clk(clk),
        .enabled(btn_down_en),
        .disabled(btn_down_dis)
    );

    // Sets up wires for the pause and reset switch enable
    // and disable signals, and debounces the asynchronous input.
    wire sw_pause_en;
    wire sw_pause_dis;
    wire sw_rst_en;
    wire sw_rst_dis;
    wire sw_hold_en;
    wire sw_hold_dis;
    debouncer debouncer_sw_hold_ (
        .raw(sw_hold),
        .clk(clk),
        .enabled(sw_hold_en),
        .disabled(sw_hold_dis)
    );
    debouncer debouncer_sw_pause_ (
        .raw(sw_pause),
        .clk(clk),
        .enabled(sw_pause_en),
        .disabled(sw_pause_dis)
    );
    debouncer debouncer_sw_rst_ (
        .raw(sw_rst),
        .clk(clk),
        .enabled(sw_rst_en),
        .disabled(sw_rst_dis)
    );
    assign usr_led = 4'b0001;
    // A memory bank for storing 1 bit for each board position.
    // If the fallen_pieces memory is 1, there is a block still that
    // has not been removed from play. This is used to draw the board
    // and to test for intersection with the falling piece.
    reg [(`BLOCKS_WIDE*`BLOCKS_HIGH)-1:0] fallen_pieces;

    // What type of piece the current falling tetromino is. The types
    // are defined in definitions.vh.
    reg [`BITS_PER_BLOCK-1:0] cur_piece;
    reg [`BITS_PER_BLOCK-1:0] temp_piece;
    reg [`BITS_PER_BLOCK-1:0] cur_piece_next;
    reg [`BITS_PER_BLOCK-1:0] hold_piece;
    // The x position of the falling piece.
    reg [`BITS_X_POS-1:0] cur_pos_x;
    // The y position of the falling piece.
    reg [`BITS_Y_POS-1:0] cur_pos_y;
    // The current rotation of the falling piece (0 == 0 degrees, 1 == 90 degrees, etc)
    reg [`BITS_ROT-1:0] cur_rot;
    // The four flattened locations of the current falling tetromino. Used to
    // test for intersection, or add to fallen_pieces, etc.
    wire [`BITS_BLK_POS-1:0] cur_blk_1;
    wire [`BITS_BLK_POS-1:0] cur_blk_2;
    wire [`BITS_BLK_POS-1:0] cur_blk_3;
    wire [`BITS_BLK_POS-1:0] cur_blk_4;
    // The width and height of the current shape of the tetromino, based on its
    // type and rotation.
    wire [`BITS_BLK_SIZE-1:0] cur_width;
    wire [`BITS_BLK_SIZE-1:0] cur_height;
    wire [`BITS_BLK_SIZE-1:0] cur_l_width;
    wire [`BITS_BLK_SIZE-1:0] cur_u_height;
    // Use a calc_cur_blk module to get the values of the wires above from
    // the current position, type, and rotation of the falling tetromino.
    calc_cur_blk calc_cur_blk_ (
        .piece(cur_piece),
        .pos_x(cur_pos_x),
        .pos_y(cur_pos_y),
        .rot(cur_rot),
        .blk_1(cur_blk_1),
        .blk_2(cur_blk_2),
        .blk_3(cur_blk_3),
        .blk_4(cur_blk_4),
        .width(cur_width),
        .height(cur_height),
        .l_width(cur_l_width),
        .u_height(cur_u_height)
    );
     reg test1, test;
    // The VGA controller. We give it the type of tetromino (cur_piece)
    // so that it knows the right color, and the four positions on the
    // board that it covers. We also pass in fallen_pieces so that it can
    // display the fallen tetromino squares in monochrome.
    vga_display display_ (
        .clk(clk),
        .sw_we(sw_we),
        .cur_piece(cur_piece),
        .cur_blk_1(cur_blk_1),
        .cur_blk_2(cur_blk_2),
        .cur_blk_3(cur_blk_3),
        .cur_blk_4(cur_blk_4),
        .score_1(score_1),
        .score_2(score_2),
        .score_3(score_3),
        .score_4(score_4),
        .game_over(game_over_buf),
        .fallen_pieces(fallen_pieces),
        .hold_piece(hold_piece),
        .is_holding(test),
        .next_piece(cur_piece_next),
        .rgb(rgb),
        .hsync(hsync),
        .vsync(vsync)
    );

    // The mode, used for finite state machine things. We also
    // need to store the old mode occasionally, like when we're paused.
    reg [`MODE_BITS-1:0] mode;
    reg [`MODE_BITS-1:0] old_mode;
    // The game clock
    wire game_clk;
    // The game clock reset
    reg game_clk_rst;

    // This module outputs the game clock, which is when the clock
    // that determines when the tetromino falls by itself.
    game_clock game_clock_ (
        .clk(clk),
        .rst(game_clk_rst),
        .pause(mode != `MODE_PLAY),
        .game_clk(game_clk)
    );

    // Set up some variables to test for intersection or off-screen-ness
    // of the current piece if the user's current action were to be
    // followed through. For example, if the user presses the left button,
    // we test where the current piece would be if it was moved one to the
    // left, i.e. x = x - 1.
    wire [`BITS_X_POS-1:0] test_pos_x;
    wire [`BITS_Y_POS-1:0] test_pos_y;
    wire [`BITS_ROT-1:0] test_rot;
    // Combinational logic to determine what position/rotation we are testing.
    // This has been hoisted out into a module so that the code is shorter.
    calc_test_pos_rot calc_test_pos_rot_ (
        .mode(mode),
        .game_clk_rst(game_clk_rst),
        .game_clk(game_clk),
        .btn_left_en(btn_left_en),
        .btn_right_en(btn_right_en),
        .btn_rotate_en(btn_rotate_en),
        .btn_down_en(btn_down_en),
        .btn_drop_en(btn_drop_en),
        .cur_pos_x(cur_pos_x),
        .cur_pos_y(cur_pos_y),
        .cur_rot(cur_rot),
        .test_pos_x(test_pos_x),
        .test_pos_y(test_pos_y),
        .test_rot(test_rot)
    );
    // Set up the outputs for the calc_test_blk module
    wire [`BITS_BLK_POS-1:0] test_blk_1;
    wire [`BITS_BLK_POS-1:0] test_blk_2;
    wire [`BITS_BLK_POS-1:0] test_blk_3;
    wire [`BITS_BLK_POS-1:0] test_blk_4;
    wire [`BITS_BLK_SIZE-1:0] test_width;
    wire [`BITS_BLK_SIZE-1:0] test_height;
    wire [`BITS_BLK_SIZE-1:0] test_l_width;
    wire [`BITS_BLK_SIZE-1:0] test_u_height;
    calc_cur_blk calc_test_block_ (
        .piece(cur_piece),
        .pos_x(test_pos_x),
        .pos_y(test_pos_y),
        .rot(test_rot),
        .blk_1(test_blk_1),
        .blk_2(test_blk_2),
        .blk_3(test_blk_3),
        .blk_4(test_blk_4),
        .width(test_width),
        .height(test_height),
        .l_width(test_l_width),
        .u_height(test_u_height)
    );

    // This function checks whether its input block positions intersect
    // with any fallen pieces.
    function intersects_fallen_pieces;
        input wire [7:0] blk1;
        input wire [7:0] blk2;
        input wire [7:0] blk3;
        input wire [7:0] blk4;
        begin
            intersects_fallen_pieces = fallen_pieces[blk1] ||
                                       fallen_pieces[blk2] ||
                                       fallen_pieces[blk3] ||
                                       fallen_pieces[blk4];
        end
    endfunction

    // This signal goes high when the test positions/rotations intersect with
    // fallen blocks.
    wire test_intersects = intersects_fallen_pieces(test_blk_1, test_blk_2, test_blk_3, test_blk_4);
    reg last_spin;
    // If the falling piece can be moved left, moves it left
    task move_left;
        begin
            if(cur_rot == 2 && cur_pos_x == 0) begin
                if (cur_pos_x >= test_l_width && !test_intersects) begin
                    cur_rot <= 0;
                    last_spin <= 0;                
                end                
            end
            else begin
                if (cur_pos_x >= test_l_width && !test_intersects) begin
                    cur_pos_x <= cur_pos_x - 1;
                    last_spin <= 0;                
                end            
            end

        end
    endtask

    // If the falling piece can be moved right, moves it right
    task move_right;
        begin
            if (cur_pos_x + cur_width < `BLOCKS_WIDE && !test_intersects) begin
                cur_pos_x <= cur_pos_x + 1;
                last_spin <= 0;                
            end
        end
    endtask

    // Rotates the current block if it would not cause any part of the
    // block to go off screen and would not intersect with any fallen blocks.
    task rotate;
        begin
            if(test_l_width > 0) begin
                if (cur_pos_x + test_width <= `BLOCKS_WIDE &&
                    cur_pos_y + test_height <= `BLOCKS_HIGH &&
                    (cur_pos_x >= (test_l_width - 1)) &&
                    !test_intersects) begin
                    cur_rot <= cur_rot + 1;
                    last_spin <= 1;
                end            
            end
            else begin
                if (cur_pos_x + test_width <= `BLOCKS_WIDE &&
                    cur_pos_y + test_height <= `BLOCKS_HIGH &&
                    !test_intersects) begin
                    cur_rot <= cur_rot + 1;
                    last_spin <= 1;
                end                       
            end
        end
    endtask

    // Adds the current block to fallen_pieces
    task add_to_fallen_pieces;
        begin
            fallen_pieces[cur_blk_1] <= 1;
            fallen_pieces[cur_blk_2] <= 1;
            fallen_pieces[cur_blk_3] <= 1;
            fallen_pieces[cur_blk_4] <= 1;
        end
    endtask
    
    // generate obstacle randomly
    reg [3:0] obscnt = 0;
    always @(posedge clk) begin
      if (obscnt == 9) obscnt <= 0;
      else obscnt <= obscnt + 1;
    end
    
    reg [2:0] piececnt = 0;
    reg [4:0] bumb_y;
    
    always @(*) begin
       bumb_y = 20;
        for (i = 19; i >= 6; i = i-1) begin
          if (fallen_pieces[obscnt + i*`BLOCKS_WIDE]) bumb_y = i;
        end
    end
    integer i;
    task addobstacle;
        begin
            fallen_pieces[obscnt + (bumb_y-1)*`BLOCKS_WIDE] <= 1;
            fallen_pieces[obscnt + (bumb_y-2)*`BLOCKS_WIDE] <= 1;
        end
    endtask

    // Adds the given blocks to fallen_pieces, and
    // chooses a new block for the user that appears
    // at the top of the screen.
    task get_new_block;
        begin
            // Reset the drop timer, can't drop until this is high enough
            drop_timer = 0;
            // Choose a new block for the user
            cur_piece = cur_piece_next;
            cur_piece_next = random_piece;
            cur_pos_x = (`BLOCKS_WIDE / 2) - 1;
            cur_pos_y = 0;
            cur_rot = 0;
            // reset the game timer so the user has a full
            // cycle before the block falls
            game_clk_rst = 1;
            test1 = 0;
            piececnt = piececnt + 1;
            if (piececnt == 4) begin
              addobstacle();
              piececnt = 0;
            end
        end
    endtask
    task get_hold_1;
        begin
            // Reset the drop timer, can't drop until this is high enough
            drop_timer = 0;
            // Choose a new block for the user
            hold_piece = cur_piece;
            cur_piece = cur_piece_next;
            cur_piece_next = random_piece;
            cur_pos_x = (`BLOCKS_WIDE / 2) - 1;
            cur_pos_y = 0;
            cur_rot = 0;
            // reset the game timer so the user has a full
            // cycle before the block falls
            game_clk_rst = 1;
        end
    endtask
    task get_hold_2;
        begin
            // Reset the drop timer, can't drop until this is high enough
            drop_timer = 0;
            // Choose a new block for the user
            //temp_piece = cur_piece;
            cur_piece <= hold_piece;
            hold_piece <= cur_piece;
            cur_pos_x <= (`BLOCKS_WIDE / 2) - 1;
            cur_pos_y <= 0;
            cur_rot <= 0;
            // reset the game timer so the user has a full
            // cycle before the block falls
            game_clk_rst <= 1;
        end
    endtask
    // Moves the current piece down one, getting a new block if
    // the piece would go off the board or intersect with another block.
    task move_down;
        begin
            if (cur_pos_y + cur_height < `BLOCKS_HIGH && !test_intersects) begin
                cur_pos_y <= cur_pos_y + 1;
                last_spin <= 0;
            end else begin
                add_to_fallen_pieces();
                get_new_block();
            end
        end
    endtask

    // Sets the mode to MODE_DROP, in which the current block will not respond
    // to user input and it will move down at one cycle per second until it hits
    // a block or the bottom of the board.
    task drop_to_bottom;
        begin
            mode <= `MODE_DROP;
        end
    endtask

    // The score register, increased by one when the user
    // completes a row.
    reg [3:0] score_1; // 1's place
    reg [3:0] score_2; // 10's place
    reg [3:0] score_3; // 100's place
    reg [3:0] score_4; // 1000's place
    // The 7-segment display module, which outputs the score

    // The module that determines which row, if any, is complete
    // and needs to be removed and the score incremented
    wire [`BITS_Y_POS-1:0] remove_row_y;
    wire remove_row_en;
    complete_row complete_row_ (
        .clk(clk),
        .pause(mode != `MODE_PLAY),
        .fallen_pieces(fallen_pieces),
        .row(remove_row_y),
        .enabled(remove_row_en)
    );

    // This task removes the completed row from fallen_pieces
    // and increments the score
    reg [`BITS_Y_POS-1:0] shifting_row;
    reg [15:0] score;
    reg [2:0] temp;
    reg [2:0] num;
    task remove_row;
        input t_spin;
        begin
            // Shift away remove_row_y
            mode = `MODE_SHIFT;
            shifting_row <= remove_row_y;
        end
    endtask
    reg [15:0] counter;
    // Initialize any registers we need
    initial begin
        mode = `MODE_IDLE;
        fallen_pieces = 0;
        cur_piece = `EMPTY_BLOCK;
        hold_piece = `O_BLOCK;
        cur_pos_x = 0;
        cur_pos_y = 0;
        cur_rot = 0;
        counter = 0;
        num = 0;
        score_1 = 0;
        score_2 = 0;
        score_3 = 0;
        score_4 = 0;
    end

    // Starts a new game after a button is pressed in the MODE_IDLE state
    task start_game;
        begin
            mode <= `MODE_PLAY;
            fallen_pieces <= 0;
            score_1 <= 0;
            score_2 <= 0;
            score_3 <= 0;
            score_4 <= 0;
            cur_piece_next <= random_piece;
            get_new_block();
        end
    endtask

    // Determine if the game is over because the current position
    // intersects with a fallen block
    reg game_over_buf;
    wire game_over = cur_pos_y == 0 && intersects_fallen_pieces(cur_blk_1, cur_blk_2, cur_blk_3, cur_blk_4);
    wire t_spin;
    wire [2:0] diagnal_occupied_num;
    reg last_spin;
    reg [3:0] occupied;
    assign diagnal_occupied_num = occupied[0] + occupied[1] + occupied[2] + occupied[3];
    assign t_spin = last_spin && (cur_piece == 3) && (diagnal_occupied_num == 3);
    
    reg t_spin_buf = 0;
    reg t_spin_prev = 0;
    reg [8:0] t_spin_counter = 0;
    
    always @(posedge clk) begin
        t_spin_prev <= t_spin;
    end
    
    always @ (posedge clk) begin
        if (t_spin_counter == 500) t_spin_counter <= 0;
        else if (t_spin_buf || ((~t_spin) && t_spin_prev)) t_spin_counter <= t_spin_counter+1;
        else t_spin_counter <= 0;
    end
 
    always @ (posedge clk) begin
        if (t_spin_counter == 0) t_spin_buf <= (~t_spin) & t_spin_prev;
    end

    always @ (posedge clk) begin
        occupied[0] <= (cur_pos_y + 1 >= `BLOCKS_HIGH || cur_pos_x + 1 >= `BLOCKS_WIDE)? 1:
                       (fallen_pieces[(cur_pos_y + 1)*`BLOCKS_WIDE + cur_pos_x + 1])? 1:0;

        occupied[1] <= (cur_pos_y + 1 >= `BLOCKS_HIGH || cur_pos_x == 0)? 1:
                       (fallen_pieces[(cur_pos_y + 1)*`BLOCKS_WIDE + cur_pos_x - 1])? 1:0;

        occupied[2] <= ((cur_pos_y == 0) || (cur_pos_x + 1 >= `BLOCKS_WIDE))? 1:
                       (fallen_pieces[(cur_pos_y - 1)*`BLOCKS_WIDE + cur_pos_x + 1])? 1:0;

        occupied[3] <= (cur_pos_y == 0 || cur_pos_x == 0)? 1:
                       (fallen_pieces[(cur_pos_y - 1)*`BLOCKS_WIDE + cur_pos_x - 1])? 1:0;
    end
    // Main game logic
    always @ (posedge clk) begin
        if (drop_timer < `DROP_TIMER_MAX) begin
            drop_timer <= drop_timer + 1;
        end
        game_clk_rst <= 0;
        if (mode == `MODE_IDLE && (sw_rst_en || sw_rst_dis)) begin
            // We are in idle mode and the user has requested to start the game
            game_over_buf <= 0;
            start_game();
        end else if (sw_rst_en || sw_rst_dis || game_over) begin
            // We hit the reset switch or the game ended by itself,
            // go into idle mode where we wait for the user to press a button
            mode <= `MODE_IDLE;
            cur_piece <= `EMPTY_BLOCK;
            if (game_over) begin
                fallen_pieces <= 0;
                game_over_buf <= 1;
            end
            else add_to_fallen_pieces();
            cur_piece_next <= random_piece;
            test <= 1;
            test1 <= 0;
        end else if ((sw_pause_en || sw_pause_dis) && mode == `MODE_PLAY) begin
            // If we switch on pause, save the old mode and enter
            // the pause mode.
            mode <= `MODE_PAUSE;
            old_mode <= mode;
        end else if ((sw_pause_en || sw_pause_dis) && mode == `MODE_PAUSE) begin
            // If we switch off pause, enter the old mode
            mode <= old_mode;
        end else if (mode == `MODE_PLAY) begin
            if(counter > 200) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
            // Normal gameplay
            if (game_clk) begin
                move_down();
            end else if ((sw_hold_en || sw_hold_dis) && test == 0 && test1 == 0) begin
                 test <= 1;
                 test1 <= 1;
                 get_hold_1();
            end else if ((sw_hold_en || sw_hold_dis) && test == 1 && test1 == 0) begin
                 test1 <= 1;
                 get_hold_2();
            end else if (btn_left_en) begin
                move_left();
            end else if (btn_right_en) begin
                move_right();
            end else if (btn_rotate_en) begin
                rotate();
            end else if (btn_down_en) begin
                move_down();
            end else if (btn_drop_en && drop_timer == `DROP_TIMER_MAX) begin
                drop_to_bottom();
           end else if (remove_row_en) begin
                remove_row(t_spin);
            end
        end else if (mode == `MODE_DROP) begin
            // We are dropping the block until we hit respawn
            // at the top
            if (game_clk_rst && !sw_pause_en) begin
                mode <= `MODE_PLAY;
            end else begin
                move_down();
            end
        end else if (mode == `MODE_SHIFT) begin
            // We are shifting the row above shifting_row
            // into shifting_row's position
            if (shifting_row == 0) begin
                num <= num + 1;           
                fallen_pieces[0 +: `BLOCKS_WIDE] <= 0;
                counter <= 0;
                mode <= `MODE_PLAY;
            end else begin
                fallen_pieces[shifting_row*`BLOCKS_WIDE +: `BLOCKS_WIDE] <= fallen_pieces[(shifting_row - 1)*`BLOCKS_WIDE +: `BLOCKS_WIDE];
                shifting_row <= shifting_row - 1;
            end
        end
        if(mode == `MODE_IDLE && (sw_rst_en || sw_rst_dis)) begin
          score <= 0;
        end
        else if(counter == 200 && mode == `MODE_PLAY) begin
            if(t_spin_buf == 0) begin
                // Increment the score
                case(num)
                    1: begin
                        score <= score + 4;
                    end
                    2: begin
                        score <= score + 10;
                    end
                    3: begin
                        score <= score + 30;
                    end
                    4: begin
                        score <= score + 120;
                    end
                endcase
            end
            else if (num == 2) begin
                score <= score + 120;
            end
            else if(num == 1) begin
                score <= score + 60;
            end

            score_1 <= score%10;
            score_2 <= (score/10)%10;
            score_3 <= (score/100)%10;
            score_4 <= (score/1000)%10;
            num <= 0;
            
        end
    end

endmodule
