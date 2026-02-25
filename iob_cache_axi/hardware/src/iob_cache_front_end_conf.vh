// general_operation: General operation group
// Core Configuration Parameters Default Values
`define IOB_CACHE_FRONT_END_ADDR_W `IOB_CACHE_FRONT_END_ADDR_W_CSRS
`define IOB_CACHE_FRONT_END_DATA_W 32
`define IOB_CACHE_FRONT_END_USE_CTRL 0
// Core Configuration Macros.
`define IOB_CACHE_FRONT_END_ADDR_W_CSRS 5
// Core Constants. DO NOT CHANGE
`define IOB_CACHE_FRONT_END_VERSION 16'h0081
// Core Derived Parameters. DO NOT CHANGE
`define IOB_CACHE_FRONT_END_FE_NBYTES_W $clog2(DATA_W/8)
