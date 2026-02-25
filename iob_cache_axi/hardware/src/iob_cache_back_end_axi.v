// SPDX-FileCopyrightText: 2024 IObundle
//
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps

`include "iob_cache_back_end_axi_conf.vh"

module iob_cache_back_end_axi #(
   parameter FE_ADDR_W = `IOB_CACHE_BACK_END_AXI_FE_ADDR_W,
   parameter FE_DATA_W = `IOB_CACHE_BACK_END_AXI_FE_DATA_W,
   parameter BE_ADDR_W = `IOB_CACHE_BACK_END_AXI_BE_ADDR_W,
   parameter BE_DATA_W = `IOB_CACHE_BACK_END_AXI_BE_DATA_W,
   parameter WORD_OFFSET_W = `IOB_CACHE_BACK_END_AXI_WORD_OFFSET_W,
   parameter WRITE_POL = `IOB_CACHE_BACK_END_AXI_WRITE_POL,
   parameter AXI_ID_W = `IOB_CACHE_BACK_END_AXI_AXI_ID_W,
   parameter AXI_ID = `IOB_CACHE_BACK_END_AXI_AXI_ID,
   parameter AXI_LEN_W = `IOB_CACHE_BACK_END_AXI_AXI_LEN_W,
   parameter AXI_ADDR_W = `IOB_CACHE_BACK_END_AXI_AXI_ADDR_W,
   parameter AXI_DATA_W = `IOB_CACHE_BACK_END_AXI_AXI_DATA_W,
   parameter FE_NBYTES = `IOB_CACHE_BACK_END_AXI_FE_NBYTES,  // Don't change this parameter value!
   parameter FE_NBYTES_W = `IOB_CACHE_BACK_END_AXI_FE_NBYTES_W,  // Don't change this parameter value!
   parameter BE_NBYTES = `IOB_CACHE_BACK_END_AXI_BE_NBYTES,  // Don't change this parameter value!
   parameter BE_NBYTES_W = `IOB_CACHE_BACK_END_AXI_BE_NBYTES_W,  // Don't change this parameter value!
   parameter LINE2BE_W = `IOB_CACHE_BACK_END_AXI_LINE2BE_W  // Don't change this parameter value!
) (
   // clk_rst_s: Clock and reset
   input                                                                       clk_i,
   input                                                                       arst_i,
   // write_io: Back-end write channel
   input                                                                       write_valid_i,
   input  [           FE_ADDR_W - (FE_NBYTES_W + WRITE_POL*WORD_OFFSET_W)-1:0] write_addr_i,
   input  [FE_DATA_W + WRITE_POL*(FE_DATA_W*(2**WORD_OFFSET_W)-FE_DATA_W)-1:0] write_wdata_i,
   input  [                                                     FE_NBYTES-1:0] write_wstrb_i,
   output                                                                      write_ready_o,
   // read_io: Back-end read channel
   input                                                                       replace_valid_i,
   output                                                                      replace_o,
   input  [                             FE_ADDR_W-(BE_NBYTES_W+LINE2BE_W)-1:0] replace_addr_i,
   output                                                                      read_valid_o,
   output [                                                     LINE2BE_W-1:0] read_addr_o,
   output [                                                    AXI_DATA_W-1:0] read_rdata_o,
   // axi_m: Back-end interface
   output [                                                    AXI_ADDR_W-1:0] axi_araddr_o,
   output                                                                      axi_arvalid_o,
   input                                                                       axi_arready_i,
   input  [                                                    AXI_DATA_W-1:0] axi_rdata_i,
   input  [                                                             2-1:0] axi_rresp_i,
   input                                                                       axi_rvalid_i,
   output                                                                      axi_rready_o,
   output [                                                      AXI_ID_W-1:0] axi_arid_o,
   output [                                                     AXI_LEN_W-1:0] axi_arlen_o,
   output [                                                             3-1:0] axi_arsize_o,
   output [                                                             2-1:0] axi_arburst_o,
   output                                                                      axi_arlock_o,
   output [                                                             4-1:0] axi_arcache_o,
   output [                                                             4-1:0] axi_arqos_o,
   input  [                                                      AXI_ID_W-1:0] axi_rid_i,
   input                                                                       axi_rlast_i,
   output [                                                    AXI_ADDR_W-1:0] axi_awaddr_o,
   output                                                                      axi_awvalid_o,
   input                                                                       axi_awready_i,
   output [                                                    AXI_DATA_W-1:0] axi_wdata_o,
   output [                                                  AXI_DATA_W/8-1:0] axi_wstrb_o,
   output                                                                      axi_wvalid_o,
   input                                                                       axi_wready_i,
   input  [                                                             2-1:0] axi_bresp_i,
   input                                                                       axi_bvalid_i,
   output                                                                      axi_bready_o,
   output [                                                      AXI_ID_W-1:0] axi_awid_o,
   output [                                                     AXI_LEN_W-1:0] axi_awlen_o,
   output [                                                             3-1:0] axi_awsize_o,
   output [                                                             2-1:0] axi_awburst_o,
   output                                                                      axi_awlock_o,
   output [                                                             4-1:0] axi_awcache_o,
   output [                                                             4-1:0] axi_awqos_o,
   output                                                                      axi_wlast_o,
   input  [                                                      AXI_ID_W-1:0] axi_bid_i
);

   iob_cache_read_channel_axi #(
      .ADDR_W       (FE_ADDR_W),
      .DATA_W       (FE_DATA_W),
      .BE_ADDR_W    (AXI_ADDR_W),
      .BE_DATA_W    (AXI_DATA_W),
      .WORD_OFFSET_W(WORD_OFFSET_W),
      .AXI_ADDR_W   (AXI_ADDR_W),
      .AXI_DATA_W   (AXI_DATA_W),
      .AXI_ID_W     (AXI_ID_W),
      .AXI_LEN_W    (AXI_LEN_W),
      .AXI_ID       (AXI_ID)
   ) read_fsm (
      .replace_valid_i(replace_valid_i),
      .replace_addr_i (replace_addr_i),
      .replace_o      (replace_o),
      .read_valid_o   (read_valid_o),
      .read_addr_o    (read_addr_o),
      .read_rdata_o   (read_rdata_o),

      .axi_araddr_o (axi_araddr_o),
      .axi_arprot_o (),
      .axi_arvalid_o(axi_arvalid_o),
      .axi_arready_i(axi_arready_i),
      .axi_rdata_i  (axi_rdata_i),
      .axi_rresp_i  (axi_rresp_i),
      .axi_rvalid_i (axi_rvalid_i),
      .axi_rready_o (axi_rready_o),
      .axi_arid_o   (axi_arid_o),
      .axi_arlen_o  (axi_arlen_o),
      .axi_arsize_o (axi_arsize_o),
      .axi_arburst_o(axi_arburst_o),
      .axi_arlock_o (axi_arlock_o),
      .axi_arcache_o(axi_arcache_o),
      .axi_arqos_o  (axi_arqos_o),
      .axi_rid_i    (axi_rid_i),
      .axi_rlast_i  (axi_rlast_i),

      .clk_i  (clk_i),
      .reset_i(arst_i)
   );

   iob_cache_write_channel_axi #(
      .ADDR_W       (FE_ADDR_W),
      .DATA_W       (FE_DATA_W),
      .BE_ADDR_W    (AXI_ADDR_W),
      .BE_DATA_W    (AXI_DATA_W),
      .WRITE_POL    (WRITE_POL),
      .WORD_OFFSET_W(WORD_OFFSET_W),
      .AXI_ADDR_W   (AXI_ADDR_W),
      .AXI_DATA_W   (AXI_DATA_W),
      .AXI_ID_W     (AXI_ID_W),
      .AXI_LEN_W    (AXI_LEN_W),
      .AXI_ID       (AXI_ID)
   ) write_fsm (
      .valid_i(write_valid_i),
      .addr_i (write_addr_i),
      .wstrb_i(write_wstrb_i),
      .wdata_i(write_wdata_i),
      .ready_o(write_ready_o),

      .axi_awaddr_o (axi_awaddr_o),
      .axi_awprot_o (),
      .axi_awvalid_o(axi_awvalid_o),
      .axi_awready_i(axi_awready_i),
      .axi_wdata_o  (axi_wdata_o),
      .axi_wstrb_o  (axi_wstrb_o),
      .axi_wvalid_o (axi_wvalid_o),
      .axi_wready_i (axi_wready_i),
      .axi_bresp_i  (axi_bresp_i),
      .axi_bvalid_i (axi_bvalid_i),
      .axi_bready_o (axi_bready_o),
      .axi_awid_o   (axi_awid_o),
      .axi_awlen_o  (axi_awlen_o),
      .axi_awsize_o (axi_awsize_o),
      .axi_awburst_o(axi_awburst_o),
      .axi_awlock_o (axi_awlock_o),
      .axi_awcache_o(axi_awcache_o),
      .axi_awqos_o  (axi_awqos_o),
      .axi_wlast_o  (axi_wlast_o),
      .axi_bid_i    (axi_bid_i),

      .clk_i  (clk_i),
      .reset_i(arst_i)
   );

endmodule
