// general_operation: General operation group
// Core Configuration Parameters Default Values
`define IOB_FIFO_SYNC_W_DATA_W 21
`define IOB_FIFO_SYNC_R_DATA_W 21
`define IOB_FIFO_SYNC_ADDR_W 21
// Core Constants. DO NOT CHANGE
`define IOB_FIFO_SYNC_VERSION 16'h0081
// Core Derived Parameters. DO NOT CHANGE
`define IOB_FIFO_SYNC_MAXDATA_W iob_max(W_DATA_W, R_DATA_W)
`define IOB_FIFO_SYNC_MINDATA_W iob_min(W_DATA_W, R_DATA_W)
`define IOB_FIFO_SYNC_R MAXDATA_W / MINDATA_W
`define IOB_FIFO_SYNC_MINADDR_W ADDR_W - $clog2(R)
`define IOB_FIFO_SYNC_W_ADDR_W (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
`define IOB_FIFO_SYNC_R_ADDR_W (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
