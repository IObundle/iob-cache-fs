// general_operation: General operation group
// Core Configuration Parameters Default Values
`define IOB_UUT_FE_ADDR_W 24
`define IOB_UUT_FE_DATA_W 32
`define IOB_UUT_BE_ADDR_W 24
`define IOB_UUT_BE_DATA_W 32
`define IOB_UUT_NWAYS_W 1
`define IOB_UUT_NLINES_W 7
`define IOB_UUT_WORD_OFFSET_W 3
`define IOB_UUT_WTBUF_DEPTH_W 4
`define IOB_UUT_REP_POLICY 0
`define IOB_UUT_WRITE_POL 0 
`define IOB_UUT_USE_CTRL 1
`define IOB_UUT_USE_CTRL_CNT 1
`define IOB_UUT_AXI_ID_W 1
`define IOB_UUT_AXI_ID 0
`define IOB_UUT_AXI_LEN_W 4
`define IOB_UUT_AXI_ADDR_W BE_ADDR_W
`define IOB_UUT_AXI_DATA_W BE_DATA_W
// Core Configuration Macros.
`define IOB_UUT_VERSION 24'h008100
// Core Derived Parameters. DO NOT CHANGE
`define IOB_UUT_FE_NBYTES FE_DATA_W / 8
`define IOB_UUT_FE_NBYTES_W $clog2(FE_NBYTES)
`define IOB_UUT_BE_NBYTES BE_DATA_W / 8
`define IOB_UUT_BE_NBYTES_W $clog2(BE_NBYTES)
`define IOB_UUT_LINE2BE_W WORD_OFFSET_W - $clog2(BE_DATA_W / FE_DATA_W)
`define IOB_UUT_ADDR_W USE_CTRL + FE_ADDR_W
`define IOB_UUT_DATA_W FE_DATA_W
