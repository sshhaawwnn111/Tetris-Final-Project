// The width of the screen in pixels
`define PIXEL_WIDTH 640
// The height of the screen in pixels
`define PIXEL_HEIGHT 480

// Used for VGA horizontal and vertical sync
`define HSYNC_FRONT_PORCH 16
`define HSYNC_PULSE_WIDTH 96
`define HSYNC_BACK_PORCH 48
`define VSYNC_FRONT_PORCH 10
`define VSYNC_PULSE_WIDTH 2
`define VSYNC_BACK_PORCH 33

// How many pixels wide/high each block is
`define BLOCK_SIZE 20

// How many blocks wide the game board is
`define BLOCKS_WIDE 10

// How many blocks high the game board is
`define BLOCKS_HIGH 20

// Width of the game board in pixels
`define BOARD_WIDTH (`BLOCKS_WIDE * `BLOCK_SIZE)
// Starting x pixel for the game board
`define BOARD_X (((`PIXEL_WIDTH - `BOARD_WIDTH) / 2) - 1)

// Height of the game board in pixels
`define BOARD_HEIGHT (`BLOCKS_HIGH * `BLOCK_SIZE)
// Starting y pixel for the game board
`define BOARD_Y (((`PIXEL_HEIGHT - `BOARD_HEIGHT) / 2) - 1)

// The number of bits used to store a block position
`define BITS_BLK_POS 8
// The number of bits used to store an X position
`define BITS_X_POS 4
// The number of bits used to store a Y position
`define BITS_Y_POS 5
// The number of bits used to store a rotation
`define BITS_ROT 2
// The number of bits used to store how wide / long a block is (max of decimal 4)
`define BITS_BLK_SIZE 3
// The number of bits for the score. The score goes up to 10000
`define BITS_SCORE 14
// The number of bits used to store each block
`define BITS_PER_BLOCK 3

// The type of each block
`define EMPTY_BLOCK 3'b000
`define I_BLOCK 3'b001
`define O_BLOCK 3'b010
`define T_BLOCK 3'b011
`define S_BLOCK 3'b100
`define Z_BLOCK 3'b101
`define J_BLOCK 3'b110
`define L_BLOCK 3'b111

// Color mapping
`define WHITE 12'b111111111111
`define BLACK 12'b000000000000
`define GRAY 12'b100010001000
`define CYAN 12'b111010000000
`define YELLOW 12'b001011011100
`define PURPLE 12'b110000101100
`define GREEN 12'b001011000000
`define RED 12'b000000000111
`define BLUE 12'b110000000000
`define ORANGE 12'b000011011100

// Error value
`define ERR_BLK_POS 8'b11111111

// Modes
`define MODE_BITS 3
`define MODE_PLAY 0
`define MODE_DROP 1
`define MODE_PAUSE 2
`define MODE_IDLE 3
`define MODE_SHIFT 4

// The maximum value of the drop timer
`define DROP_TIMER_MAX 10000

`define BG_POS 0
`define BG_WIDTH 320
`define BG_HEIGHT 240
`define BLK_WIDTH 10
`define BLK_HEIGHT 10
`define BLUE_POS 76800
`define DBLUE_POS 76900
`define RED_POS 77000
`define DRED_POS 77100
`define YELLOW_POS 77200
`define DYELLOW_POS 77300
`define GREEN_POS 77400
`define DGREEN_POS 77500
`define NUM_WIDTH 14
`define NUM_HEIGHT 20
`define NUM_POS 77600
`define BANNER_WIDTH 160
`define BANNER_HEIGHT 30
`define OVER_POS 80400

`define SCORE_POS_X 70
`define SCORE_POS_Y 76
`define FOUR_SCORE_WIDTH 118
`define FOUR_SCORE_HEIGHT 40

`define BANNER_POS_X 152
`define BANNER_POS_Y 210

`define BOARD_POS_X 220
`define BOARD_POS_Y 40
