// general_operation: General operation group
// Core Configuration Parameters Default Values
`define IOB_RAM_SP_BE_HEXFILE "none"
`define IOB_RAM_SP_BE_ADDR_W 10
`define IOB_RAM_SP_BE_DATA_W 32
`define IOB_RAM_SP_BE_MEM_NO_READ_ON_WRITE 0
// Core Configuration Macros.
`define IOB_RAM_SP_BE_VERSION 24'h008100
// Core Derived Parameters. DO NOT CHANGE
`define IOB_RAM_SP_BE_COL_W 8
`define IOB_RAM_SP_BE_NUM_COL DATA_W / COL_W
