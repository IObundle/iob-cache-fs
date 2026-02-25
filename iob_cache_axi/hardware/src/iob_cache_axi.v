// SPDX-FileCopyrightText: 2025 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_cache_axi_conf.vh"

module iob_cache_axi #(
   parameter FE_ADDR_W     = `IOB_CACHE_AXI_FE_ADDR_W,
   parameter FE_DATA_W     = `IOB_CACHE_AXI_FE_DATA_W,
   parameter BE_ADDR_W     = `IOB_CACHE_AXI_BE_ADDR_W,
   parameter BE_DATA_W     = `IOB_CACHE_AXI_BE_DATA_W,
   parameter NWAYS_W       = `IOB_CACHE_AXI_NWAYS_W,
   parameter NLINES_W      = `IOB_CACHE_AXI_NLINES_W,
   parameter WORD_OFFSET_W = `IOB_CACHE_AXI_WORD_OFFSET_W,
   parameter WTBUF_DEPTH_W = `IOB_CACHE_AXI_WTBUF_DEPTH_W,
   parameter REP_POLICY    = `IOB_CACHE_AXI_REP_POLICY,
   parameter WRITE_POL     = `IOB_CACHE_AXI_WRITE_POL,
   parameter USE_CTRL      = `IOB_CACHE_AXI_USE_CTRL,
   parameter USE_CTRL_CNT  = `IOB_CACHE_AXI_USE_CTRL_CNT,
   parameter FE_NBYTES     = `IOB_CACHE_AXI_FE_NBYTES,      // Don't change this parameter value!
   parameter FE_NBYTES_W   = `IOB_CACHE_AXI_FE_NBYTES_W,    // Don't change this parameter value!
   parameter BE_NBYTES     = `IOB_CACHE_AXI_BE_NBYTES,      // Don't change this parameter value!
   parameter BE_NBYTES_W   = `IOB_CACHE_AXI_BE_NBYTES_W,    // Don't change this parameter value!
   parameter LINE2BE_W     = `IOB_CACHE_AXI_LINE2BE_W,      // Don't change this parameter value!
   parameter ADDR_W        = `IOB_CACHE_AXI_ADDR_W,         // Don't change this parameter value!
   parameter DATA_W        = `IOB_CACHE_AXI_DATA_W,         // Don't change this parameter value!
   parameter AXI_ID_W      = `IOB_CACHE_AXI_AXI_ID_W,
   parameter AXI_ID        = `IOB_CACHE_AXI_AXI_ID,
   parameter AXI_LEN_W     = `IOB_CACHE_AXI_AXI_LEN_W,
   parameter AXI_ADDR_W    = `IOB_CACHE_AXI_AXI_ADDR_W,
   parameter AXI_DATA_W    = `IOB_CACHE_AXI_AXI_DATA_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                         clk_i,
   input                         cke_i,
   input                         arst_i,
   // iob_s: Front-end interface
   input                         iob_valid_i,
   input      [      ADDR_W-1:0] iob_addr_i,
   input      [      DATA_W-1:0] iob_wdata_i,
   input      [    DATA_W/8-1:0] iob_wstrb_i,
   output                        iob_rvalid_o,
   output     [      DATA_W-1:0] iob_rdata_o,
   output                        iob_ready_o,
   // ie_io: Cache invalidate and write-trough buffer IO chain
   input                         invalidate_i,
   output reg                    invalidate_o,
   input                         wtb_empty_i,
   output reg                    wtb_empty_o,
   // axi_m: Back-end interface
   output     [  AXI_ADDR_W-1:0] axi_araddr_o,
   output                        axi_arvalid_o,
   input                         axi_arready_i,
   input      [  AXI_DATA_W-1:0] axi_rdata_i,
   input      [           2-1:0] axi_rresp_i,
   input                         axi_rvalid_i,
   output                        axi_rready_o,
   output     [    AXI_ID_W-1:0] axi_arid_o,
   output     [   AXI_LEN_W-1:0] axi_arlen_o,
   output     [           3-1:0] axi_arsize_o,
   output     [           2-1:0] axi_arburst_o,
   output                        axi_arlock_o,
   output     [           4-1:0] axi_arcache_o,
   output     [           4-1:0] axi_arqos_o,
   input      [    AXI_ID_W-1:0] axi_rid_i,
   input                         axi_rlast_i,
   output     [  AXI_ADDR_W-1:0] axi_awaddr_o,
   output                        axi_awvalid_o,
   input                         axi_awready_i,
   output     [  AXI_DATA_W-1:0] axi_wdata_o,
   output     [AXI_DATA_W/8-1:0] axi_wstrb_o,
   output                        axi_wvalid_o,
   input                         axi_wready_i,
   input      [           2-1:0] axi_bresp_i,
   input                         axi_bvalid_i,
   output                        axi_bready_o,
   output     [    AXI_ID_W-1:0] axi_awid_o,
   output     [   AXI_LEN_W-1:0] axi_awlen_o,
   output     [           3-1:0] axi_awsize_o,
   output     [           2-1:0] axi_awburst_o,
   output                        axi_awlock_o,
   output     [           4-1:0] axi_awcache_o,
   output     [           4-1:0] axi_awqos_o,
   output                        axi_wlast_o,
   input      [    AXI_ID_W-1:0] axi_bid_i
);

   // Cache memory front-end interface
   wire                                                                      data_req;
   wire [                                       FE_ADDR_W - FE_NBYTES_W-1:0] data_addr;
   wire [                                                     FE_DATA_W-1:0] data_rdata;
   wire                                                                      data_ack;
   wire                                                                      data_req_reg;
   wire [                                       FE_ADDR_W - FE_NBYTES_W-1:0] data_addr_reg;
   wire [                                                     FE_DATA_W-1:0] data_wdata_reg;
   wire [                                                     FE_NBYTES-1:0] data_wstrb_reg;
   // Control interface.
   wire                                                                      ctrl_req;
   wire [                                    `IOB_CACHE_AXI_ADDR_W_CSRS-1:0] ctrl_addr;
   wire [                                                      DATA_W/8-1:0] ctrl_wstrb;
   wire [                                      USE_CTRL*(FE_DATA_W-1)+1-1:0] ctrl_rdata;
   wire                                                                      ctrl_ack;
   // Cache memory front-end interface
   reg  [                             FE_ADDR_W-(BE_NBYTES_W+LINE2BE_W)-1:0] cache_mem_data_addr;
   // Back-end write channel
   wire                                                                      write_req;
   wire [           FE_ADDR_W - (FE_NBYTES_W + WRITE_POL*WORD_OFFSET_W)-1:0] write_addr;
   wire [FE_DATA_W + WRITE_POL*(FE_DATA_W*(2**WORD_OFFSET_W)-FE_DATA_W)-1:0] write_wdata;
   wire [                                                     FE_NBYTES-1:0] write_wstrb;
   wire                                                                      write_ack;
   // Back-end read channel
   wire                                                                      replace_req;
   wire                                                                      replace;
   wire [                             FE_ADDR_W-(BE_NBYTES_W+LINE2BE_W)-1:0] replace_addr;
   wire                                                                      read_req;
   wire [                                                     LINE2BE_W-1:0] read_addr;
   wire [                                                     BE_DATA_W-1:0] read_rdata;
   wire                                                                      wtbuf_full;
   wire                                                                      wtbuf_empty;
   wire                                                                      write_hit;
   wire                                                                      write_miss;
   wire                                                                      read_hit;
   wire                                                                      read_miss;
   // Internal signals for control interface.
   wire                                                                      ctrl_invalidate;

   always @(*) begin

      invalidate_o        = ctrl_invalidate | invalidate_i;
      wtb_empty_o         = wtbuf_empty & wtb_empty_i;
      cache_mem_data_addr = data_addr[FE_ADDR_W-FE_NBYTES_W-1:BE_NBYTES_W+LINE2BE_W-FE_NBYTES_W];


   end


   //Cache control & Cache controller: this block is used for invalidating the cache, monitoring the status of the Write Thorough buffer, and accessing read/write hit/miss counters.
   generate
      if (USE_CTRL) begin : g_ctrl
         iob_cache_control #(
            .DATA_W      (FE_DATA_W),
            .USE_CTRL_CNT(USE_CTRL_CNT)
         ) cache_control (
            .clk_i (clk_i),
            .cke_i (cke_i),
            .arst_i(arst_i),

            // control's signals
            .valid_i(ctrl_req),
            .addr_i (ctrl_addr),
            .wstrb_i(ctrl_wstrb),

            // write data
            .wtbuf_full_i (wtbuf_full),
            .wtbuf_empty_i(wtbuf_empty),
            .write_hit_i  (write_hit),
            .write_miss_i (write_miss),
            .read_hit_i   (read_hit),
            .read_miss_i  (read_miss),

            .rdata_o     (ctrl_rdata),
            .ready_o     (ctrl_ack),
            .invalidate_o(ctrl_invalidate)
         );
      end else begin : g_no_ctrl
         assign ctrl_rdata      = 1'b0;
         assign ctrl_ack        = 1'b0;
         assign ctrl_invalidate = 1'b0;
      end
   endgenerate


   // This IOb interface is connected to a processor or any other processing element that needs a cache buffer to improve the performance of accessing a slower but larger memory
   iob_cache_front_end #(
      .ADDR_W  (ADDR_W),
      .DATA_W  (DATA_W),
      .USE_CTRL(USE_CTRL)
   ) front_end (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i           (clk_i),
      .cke_i           (cke_i),
      .arst_i          (arst_i),
      // iob_s port: Front-end interface
      .iob_valid_i     (iob_valid_i),
      .iob_addr_i      (iob_addr_i),
      .iob_wdata_i     (iob_wdata_i),
      .iob_wstrb_i     (iob_wstrb_i),
      .iob_rvalid_o    (iob_rvalid_o),
      .iob_rdata_o     (iob_rdata_o),
      .iob_ready_o     (iob_ready_o),
      // cache_mem_io port: Cache memory front-end interface
      .data_req_o      (data_req),
      .data_addr_o     (data_addr),
      .data_rdata_i    (data_rdata),
      .data_ack_i      (data_ack),
      .data_req_reg_o  (data_req_reg),
      .data_addr_reg_o (data_addr_reg),
      .data_wdata_reg_o(data_wdata_reg),
      .data_wstrb_reg_o(data_wstrb_reg),
      // ctrl_io port: Control interface.
      .ctrl_req_o      (ctrl_req),
      .ctrl_addr_o     (ctrl_addr),
      .ctrl_wstrb_o    (ctrl_wstrb),
      .ctrl_rdata_i    (ctrl_rdata),
      .ctrl_ack_i      (ctrl_ack)
   );

   // This block contains the tag, data storage memories and the Write Through Buffer if the correspeonding write policy is selected; these memories are implemented either with RAM if large enough, or with registers if small enough
   iob_cache_memory #(
      .FE_ADDR_W    (FE_ADDR_W),
      .FE_DATA_W    (FE_DATA_W),
      .BE_DATA_W    (BE_DATA_W),
      .NWAYS_W      (NWAYS_W),
      .NLINES_W     (NLINES_W),
      .WORD_OFFSET_W(WORD_OFFSET_W),
      .WTBUF_DEPTH_W(WTBUF_DEPTH_W),
      .REP_POLICY   (REP_POLICY),
      .WRITE_POL    (WRITE_POL),
      .USE_CTRL     (USE_CTRL),
      .USE_CTRL_CNT (USE_CTRL_CNT)
   ) cache_memory (
      // clk_en_rst_s port: Clock, clock enable and synchronous reset
      .clk_i         (clk_i),
      .cke_i         (cke_i),
      .arst_i        (arst_i),
      // fe_io port: Cache memory front-end interface
      .req_i         (data_req),
      .addr_i        (cache_mem_data_addr),
      .rdata_o       (data_rdata),
      .ack_o         (data_ack),
      .req_reg_i     (data_req_reg),
      .addr_reg_i    (data_addr_reg),
      .wdata_reg_i   (data_wdata_reg),
      .wstrb_reg_i   (data_wstrb_reg),
      // be_write_io port: Back-end write channel
      .write_req_o   (write_req),
      .write_addr_o  (write_addr),
      .write_wdata_o (write_wdata),
      .write_wstrb_o (write_wstrb),
      .write_ack_i   (write_ack),
      // be_read_io port: Back-end read channel
      .replace_req_o (replace_req),
      .replace_i     (replace),
      .replace_addr_o(replace_addr),
      .read_req_i    (read_req),
      .read_addr_i   (read_addr),
      .read_rdata_i  (read_rdata),
      .invalidate_i  (invalidate_o),
      .wtbuf_full_o  (wtbuf_full),
      .wtbuf_empty_o (wtbuf_empty),
      .write_hit_o   (write_hit),
      .write_miss_o  (write_miss),
      .read_hit_o    (read_hit),
      .read_miss_o   (read_miss)
   );

   // Memory-side interface: if the cache is at the last level before the target memory module, the back-end interface connects to the target memory (e.g. DDR) controller; if the cache is not at the last level, the back-end interface connects to the next-level cache. This module implements an AXI4 interface
   iob_cache_back_end_axi #(
      .FE_ADDR_W    (FE_ADDR_W),
      .FE_DATA_W    (FE_DATA_W),
      .BE_ADDR_W    (BE_ADDR_W),
      .BE_DATA_W    (BE_DATA_W),
      .WORD_OFFSET_W(WORD_OFFSET_W),
      .WRITE_POL    (WRITE_POL),
      .AXI_ADDR_W   (AXI_ADDR_W),
      .AXI_DATA_W   (AXI_DATA_W),
      .AXI_ID_W     (AXI_ID_W),
      .AXI_LEN_W    (AXI_LEN_W),
      .AXI_ID       (AXI_ID)
   ) back_end_axi (
      // clk_rst_s port: Clock and reset
      .clk_i          (clk_i),
      .arst_i         (arst_i),
      // write_io port: Back-end write channel
      .write_valid_i  (write_req),
      .write_addr_i   (write_addr),
      .write_wdata_i  (write_wdata),
      .write_wstrb_i  (write_wstrb),
      .write_ready_o  (write_ack),
      // read_io port: Back-end read channel
      .replace_valid_i(replace_req),
      .replace_o      (replace),
      .replace_addr_i (replace_addr),
      .read_valid_o   (read_req),
      .read_addr_o    (read_addr),
      .read_rdata_o   (read_rdata),
      // axi_m port: Back-end interface
      .axi_araddr_o   (axi_araddr_o),
      .axi_arvalid_o  (axi_arvalid_o),
      .axi_arready_i  (axi_arready_i),
      .axi_rdata_i    (axi_rdata_i),
      .axi_rresp_i    (axi_rresp_i),
      .axi_rvalid_i   (axi_rvalid_i),
      .axi_rready_o   (axi_rready_o),
      .axi_arid_o     (axi_arid_o),
      .axi_arlen_o    (axi_arlen_o),
      .axi_arsize_o   (axi_arsize_o),
      .axi_arburst_o  (axi_arburst_o),
      .axi_arlock_o   (axi_arlock_o),
      .axi_arcache_o  (axi_arcache_o),
      .axi_arqos_o    (axi_arqos_o),
      .axi_rid_i      (axi_rid_i),
      .axi_rlast_i    (axi_rlast_i),
      .axi_awaddr_o   (axi_awaddr_o),
      .axi_awvalid_o  (axi_awvalid_o),
      .axi_awready_i  (axi_awready_i),
      .axi_wdata_o    (axi_wdata_o),
      .axi_wstrb_o    (axi_wstrb_o),
      .axi_wvalid_o   (axi_wvalid_o),
      .axi_wready_i   (axi_wready_i),
      .axi_bresp_i    (axi_bresp_i),
      .axi_bvalid_i   (axi_bvalid_i),
      .axi_bready_o   (axi_bready_o),
      .axi_awid_o     (axi_awid_o),
      .axi_awlen_o    (axi_awlen_o),
      .axi_awsize_o   (axi_awsize_o),
      .axi_awburst_o  (axi_awburst_o),
      .axi_awlock_o   (axi_awlock_o),
      .axi_awcache_o  (axi_awcache_o),
      .axi_awqos_o    (axi_awqos_o),
      .axi_wlast_o    (axi_wlast_o),
      .axi_bid_i      (axi_bid_i)
   );


endmodule
