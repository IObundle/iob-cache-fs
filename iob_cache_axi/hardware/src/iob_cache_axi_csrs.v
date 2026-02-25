// SPDX-FileCopyrightText: 2025 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_cache_axi_csrs_conf.vh"

module iob_cache_axi_csrs #(
   parameter ADDR_W = `IOB_CACHE_AXI_CSRS_ADDR_W,  // Don't change this parameter value!
   parameter FE_ADDR_W = `IOB_CACHE_AXI_CSRS_FE_ADDR_W,
   parameter FE_DATA_W = `IOB_CACHE_AXI_CSRS_FE_DATA_W,
   parameter BE_ADDR_W = `IOB_CACHE_AXI_CSRS_BE_ADDR_W,
   parameter BE_DATA_W = `IOB_CACHE_AXI_CSRS_BE_DATA_W,
   parameter NWAYS_W = `IOB_CACHE_AXI_CSRS_NWAYS_W,
   parameter NLINES_W = `IOB_CACHE_AXI_CSRS_NLINES_W,
   parameter WORD_OFFSET_W = `IOB_CACHE_AXI_CSRS_WORD_OFFSET_W,
   parameter WTBUF_DEPTH_W = `IOB_CACHE_AXI_CSRS_WTBUF_DEPTH_W,
   parameter REP_POLICY = `IOB_CACHE_AXI_CSRS_REP_POLICY,
   parameter WRITE_POL = `IOB_CACHE_AXI_CSRS_WRITE_POL,
   parameter USE_CTRL = `IOB_CACHE_AXI_CSRS_USE_CTRL,
   parameter USE_CTRL_CNT = `IOB_CACHE_AXI_CSRS_USE_CTRL_CNT,
   parameter FE_NBYTES = `IOB_CACHE_AXI_CSRS_FE_NBYTES,  // Don't change this parameter value!
   parameter FE_NBYTES_W = `IOB_CACHE_AXI_CSRS_FE_NBYTES_W,  // Don't change this parameter value!
   parameter BE_NBYTES = `IOB_CACHE_AXI_CSRS_BE_NBYTES,  // Don't change this parameter value!
   parameter BE_NBYTES_W = `IOB_CACHE_AXI_CSRS_BE_NBYTES_W,  // Don't change this parameter value!
   parameter LINE2BE_W = `IOB_CACHE_AXI_CSRS_LINE2BE_W,  // Don't change this parameter value!
   parameter DATA_W = `IOB_CACHE_AXI_CSRS_DATA_W,  // Don't change this parameter value!
   parameter AXI_ID_W = `IOB_CACHE_AXI_CSRS_AXI_ID_W,
   parameter AXI_ID = `IOB_CACHE_AXI_CSRS_AXI_ID,
   parameter AXI_LEN_W = `IOB_CACHE_AXI_CSRS_AXI_LEN_W,
   parameter AXI_ADDR_W = `IOB_CACHE_AXI_CSRS_AXI_ADDR_W,
   parameter AXI_DATA_W = `IOB_CACHE_AXI_CSRS_AXI_DATA_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                              clk_i,
   input                              cke_i,
   input                              arst_i,
   // control_if_s: CSR control interface. Interface type defined by `csr_if` parameter.
   input                              iob_valid_i,
   input  [                    5-1:0] iob_addr_i,
   input  [               DATA_W-1:0] iob_wdata_i,
   input  [             DATA_W/8-1:0] iob_wstrb_i,
   output                             iob_rvalid_o,
   output [               DATA_W-1:0] iob_rdata_o,
   output                             iob_ready_o,
   // WTB_EMPTY_io: WTB_EMPTY register interface
   output                             WTB_EMPTY_valid_o,
   input                              WTB_EMPTY_rdata_i,
   input                              WTB_EMPTY_ready_i,
   input                              WTB_EMPTY_rvalid_i,
   // WTB_FULL_io: WTB_FULL register interface
   output                             WTB_FULL_valid_o,
   input                              WTB_FULL_rdata_i,
   input                              WTB_FULL_ready_i,
   input                              WTB_FULL_rvalid_i,
   // RW_HIT_io: RW_HIT register interface
   output                             RW_HIT_valid_o,
   input  [                   32-1:0] RW_HIT_rdata_i,
   input                              RW_HIT_ready_i,
   input                              RW_HIT_rvalid_i,
   // RW_MISS_io: RW_MISS register interface
   output                             RW_MISS_valid_o,
   input  [                   32-1:0] RW_MISS_rdata_i,
   input                              RW_MISS_ready_i,
   input                              RW_MISS_rvalid_i,
   // READ_HIT_io: READ_HIT register interface
   output                             READ_HIT_valid_o,
   input  [                   32-1:0] READ_HIT_rdata_i,
   input                              READ_HIT_ready_i,
   input                              READ_HIT_rvalid_i,
   // READ_MISS_io: READ_MISS register interface
   output                             READ_MISS_valid_o,
   input  [                   32-1:0] READ_MISS_rdata_i,
   input                              READ_MISS_ready_i,
   input                              READ_MISS_rvalid_i,
   // WRITE_HIT_io: WRITE_HIT register interface
   output                             WRITE_HIT_valid_o,
   input  [                   32-1:0] WRITE_HIT_rdata_i,
   input                              WRITE_HIT_ready_i,
   input                              WRITE_HIT_rvalid_i,
   // WRITE_MISS_io: WRITE_MISS register interface
   output                             WRITE_MISS_valid_o,
   input  [                   32-1:0] WRITE_MISS_rdata_i,
   input                              WRITE_MISS_ready_i,
   input                              WRITE_MISS_rvalid_i,
   // RST_CNTRS_io: RST_CNTRS register interface
   output                             RST_CNTRS_valid_o,
   output                             RST_CNTRS_wdata_o,
   output [((1/8 > 1) ? 1/8 : 1)-1:0] RST_CNTRS_wstrb_o,
   input                              RST_CNTRS_ready_i,
   // INVALIDATE_io: INVALIDATE register interface
   output                             INVALIDATE_valid_o,
   output                             INVALIDATE_wdata_o,
   output [((1/8 > 1) ? 1/8 : 1)-1:0] INVALIDATE_wstrb_o,
   input                              INVALIDATE_ready_i
);

   // Internal iob interface
   wire                             internal_iob_valid;
   wire [               ADDR_W-1:0] internal_iob_addr;
   wire [               DATA_W-1:0] internal_iob_wdata;
   wire [             DATA_W/8-1:0] internal_iob_wstrb;
   wire                             internal_iob_rvalid;
   wire [               DATA_W-1:0] internal_iob_rdata;
   wire                             internal_iob_ready;
   wire                             state;
   reg                              state_nxt;
   wire                             write_en;
   wire [               ADDR_W-1:0] internal_iob_addr_stable;
   wire [               ADDR_W-1:0] internal_iob_addr_reg;
   wire                             internal_iob_addr_reg_en;
   wire                             RST_CNTRS_wdata;
   wire [((1/8 > 1) ? 1/8 : 1)-1:0] RST_CNTRS_wstrb;
   wire                             INVALIDATE_wdata;
   wire [((1/8 > 1) ? 1/8 : 1)-1:0] INVALIDATE_wstrb;
   wire                             iob_rvalid_out;
   reg                              iob_rvalid_nxt;
   wire [                   32-1:0] iob_rdata_out;
   reg  [                   32-1:0] iob_rdata_nxt;
   wire                             iob_ready_out;
   reg                              iob_ready_nxt;
   // Rvalid signal of currently addressed CSR
   reg                              rvalid_int;
   // Ready signal of currently addressed CSR
   reg                              ready_int;


   // Include iob_functions for use in parameters
   localparam IOB_MAX_W = ADDR_W;
   function [IOB_MAX_W-1:0] iob_max;
      input [IOB_MAX_W-1:0] a;
      input [IOB_MAX_W-1:0] b;
      begin
         if (a > b) iob_max = a;
         else iob_max = b;
      end
   endfunction

   function integer iob_abs;
      input integer a;
      begin
         iob_abs = (a >= 0) ? a : -a;
      end
   endfunction

   `define IOB_NBYTES (DATA_W/8)
   `define IOB_NBYTES_W $clog2(`IOB_NBYTES)
   `define IOB_WORD_ADDR(ADDR) ((ADDR>>`IOB_NBYTES_W)<<`IOB_NBYTES_W)

   localparam WSTRB_W = DATA_W / 8;

   //FSM states
   localparam WAIT_REQ = 1'd0;
   localparam WAIT_RVALID = 1'd1;


   assign internal_iob_addr_reg_en = internal_iob_valid;
   assign internal_iob_addr_stable = internal_iob_valid ? internal_iob_addr : internal_iob_addr_reg;

   assign write_en = |internal_iob_wstrb;

   //write address
   wire [($clog2(WSTRB_W)+1)-1:0] byte_offset;
   iob_ctls #(
      .W     (WSTRB_W),
      .MODE  (0),
      .SYMBOL(0)
   ) bo_inst (
      .data_i (internal_iob_wstrb),
      .count_o(byte_offset)
   );

   wire [ADDR_W-1:0] wstrb_addr;
   assign wstrb_addr = `IOB_WORD_ADDR(internal_iob_addr_stable) + byte_offset;

   // Create a special readstrobe for "REG" (auto) CSRs.
   // LSBs 0 = read full word; LSBs 1 = read byte; LSBs 2 = read half word; LSBs 3 = read byte.
   reg [1:0] shift_amount;
   always @(*) begin
      case (internal_iob_addr_stable[1:0])
         // Access entire word
         2'b00:   shift_amount = 2;
         // Access single byte
         2'b01:   shift_amount = 0;
         // Access half word
         2'b10:   shift_amount = 1;
         // Access single byte
         2'b11:   shift_amount = 0;
         default: shift_amount = 0;
      endcase
   end


   //NAME: RST_CNTRS;
   //MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 28; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   assign RST_CNTRS_wdata = internal_iob_wdata[0+:1];
   wire RST_CNTRS_addressed;
   assign RST_CNTRS_addressed = (internal_iob_addr_stable >= (28)) &&  (internal_iob_addr_stable < 29);
   assign RST_CNTRS_valid_o = internal_iob_valid & RST_CNTRS_addressed;
   assign RST_CNTRS_wstrb = internal_iob_wstrb[0/8+:((1/8>1)?1/8 : 1)];
   assign RST_CNTRS_wstrb_o = RST_CNTRS_wstrb;
   assign RST_CNTRS_wdata_o = RST_CNTRS_wdata;


   //NAME: INVALIDATE;
   //MODE: W; WIDTH: 1; RST_VAL: 0; ADDR: 29; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   assign INVALIDATE_wdata = internal_iob_wdata[8+:1];
   wire INVALIDATE_addressed;
   assign INVALIDATE_addressed = (internal_iob_addr_stable >= (29)) &&  (internal_iob_addr_stable < 30);
   assign INVALIDATE_valid_o = internal_iob_valid & INVALIDATE_addressed;
   assign INVALIDATE_wstrb = internal_iob_wstrb[8/8+:((1/8>1)?1/8 : 1)];
   assign INVALIDATE_wstrb_o = INVALIDATE_wstrb;
   assign INVALIDATE_wdata_o = INVALIDATE_wdata;


   //NAME: WTB_EMPTY;
   //MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 0; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   wire WTB_EMPTY_addressed;
   assign WTB_EMPTY_addressed = (internal_iob_addr_stable >= (0)) && (internal_iob_addr_stable < 1);
   assign WTB_EMPTY_valid_o = internal_iob_valid & WTB_EMPTY_addressed & ~write_en;


   //NAME: WTB_FULL;
   //MODE: R; WIDTH: 1; RST_VAL: 0; ADDR: 1; SPACE (bytes): 1 (max); TYPE: NOAUTO. 

   wire WTB_FULL_addressed;
   assign WTB_FULL_addressed = (internal_iob_addr_stable >= (1)) && (internal_iob_addr_stable < 2);
   assign WTB_FULL_valid_o   = internal_iob_valid & WTB_FULL_addressed & ~write_en;


   //NAME: RW_HIT;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 4; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire RW_HIT_addressed;
   assign RW_HIT_addressed = (internal_iob_addr_stable >= (4)) && (internal_iob_addr_stable < 8);
   assign RW_HIT_valid_o   = internal_iob_valid & RW_HIT_addressed & ~write_en;


   //NAME: RW_MISS;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 8; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire RW_MISS_addressed;
   assign RW_MISS_addressed = (internal_iob_addr_stable >= (8)) && (internal_iob_addr_stable < 12);
   assign RW_MISS_valid_o   = internal_iob_valid & RW_MISS_addressed & ~write_en;


   //NAME: READ_HIT;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 12; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire READ_HIT_addressed;
   assign READ_HIT_addressed = (internal_iob_addr_stable >= (12)) && (internal_iob_addr_stable < 16);
   assign READ_HIT_valid_o = internal_iob_valid & READ_HIT_addressed & ~write_en;


   //NAME: READ_MISS;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 16; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire READ_MISS_addressed;
   assign READ_MISS_addressed = (internal_iob_addr_stable >= (16)) && (internal_iob_addr_stable < 20);
   assign READ_MISS_valid_o = internal_iob_valid & READ_MISS_addressed & ~write_en;


   //NAME: WRITE_HIT;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 20; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire WRITE_HIT_addressed;
   assign WRITE_HIT_addressed = (internal_iob_addr_stable >= (20)) && (internal_iob_addr_stable < 24);
   assign WRITE_HIT_valid_o = internal_iob_valid & WRITE_HIT_addressed & ~write_en;


   //NAME: WRITE_MISS;
   //MODE: R; WIDTH: 32; RST_VAL: 0; ADDR: 24; SPACE (bytes): 4 (max); TYPE: NOAUTO. 

   wire WRITE_MISS_addressed;
   assign WRITE_MISS_addressed = (internal_iob_addr_stable >= (24)) && (internal_iob_addr_stable < 28);
   assign WRITE_MISS_valid_o = internal_iob_valid & WRITE_MISS_addressed & ~write_en;


   //NAME: version;
   //MODE: R; WIDTH: 16; RST_VAL: 0071; ADDR: 30; SPACE (bytes): 2 (max); TYPE: REG. 

   wire version_addressed_r;
   assign version_addressed_r = (internal_iob_addr_stable>>shift_amount >= (30>>shift_amount)) && (internal_iob_addr_stable>>shift_amount <= iob_max(
       1, 31 >> shift_amount
   ));


   wire auto_addressed;
   wire auto_addressed_r;
   reg  auto_addressed_nxt;

   //RESPONSE SWITCH

   // Don't register response signals if accessing non-auto CSR
   assign internal_iob_rvalid = auto_addressed ? iob_rvalid_out : rvalid_int;
   assign internal_iob_rdata  = auto_addressed ? iob_rdata_out : iob_rdata_nxt;
   assign internal_iob_ready  = auto_addressed ? iob_ready_out : ready_int;

   // auto_addressed register
   assign auto_addressed      = (state == WAIT_REQ) ? auto_addressed_nxt : auto_addressed_r;
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) auto_addressed_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(auto_addressed_nxt),
      // data_o port: Data output
      .data_o(auto_addressed_r)
   );

   always @* begin
      iob_rdata_nxt      = 32'd0;

      rvalid_int         = 1'b1;
      ready_int          = 1'b1;
      auto_addressed_nxt = auto_addressed_r;
      if (internal_iob_valid) begin
         auto_addressed_nxt = 1'b1;
      end
      if (WTB_EMPTY_addressed) begin

         iob_rdata_nxt[0+:8] = {{7{1'b0}}, WTB_EMPTY_rdata_i} | 8'd0;
         rvalid_int          = WTB_EMPTY_rvalid_i;
         ready_int           = WTB_EMPTY_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (WTB_FULL_addressed) begin

         iob_rdata_nxt[8+:8] = {{7{1'b0}}, WTB_FULL_rdata_i} | 8'd0;
         rvalid_int          = WTB_FULL_rvalid_i;
         ready_int           = WTB_FULL_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (RW_HIT_addressed) begin

         iob_rdata_nxt[0+:32] = RW_HIT_rdata_i | 32'd0;
         rvalid_int           = RW_HIT_rvalid_i;
         ready_int            = RW_HIT_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (RW_MISS_addressed) begin

         iob_rdata_nxt[0+:32] = RW_MISS_rdata_i | 32'd0;
         rvalid_int           = RW_MISS_rvalid_i;
         ready_int            = RW_MISS_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (READ_HIT_addressed) begin

         iob_rdata_nxt[0+:32] = READ_HIT_rdata_i | 32'd0;
         rvalid_int           = READ_HIT_rvalid_i;
         ready_int            = READ_HIT_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (READ_MISS_addressed) begin

         iob_rdata_nxt[0+:32] = READ_MISS_rdata_i | 32'd0;
         rvalid_int           = READ_MISS_rvalid_i;
         ready_int            = READ_MISS_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (WRITE_HIT_addressed) begin

         iob_rdata_nxt[0+:32] = WRITE_HIT_rdata_i | 32'd0;
         rvalid_int           = WRITE_HIT_rvalid_i;
         ready_int            = WRITE_HIT_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (WRITE_MISS_addressed) begin

         iob_rdata_nxt[0+:32] = WRITE_MISS_rdata_i | 32'd0;
         rvalid_int           = WRITE_MISS_rvalid_i;
         ready_int            = WRITE_MISS_ready_i;
         if (internal_iob_valid & (~|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (version_addressed_r) begin
         iob_rdata_nxt[16+:16] = 16'h0071 | 16'd0;
      end

      if (write_en && (wstrb_addr >= (28)) && (wstrb_addr < 29)) begin
         ready_int = RST_CNTRS_ready_i;
         if (internal_iob_valid & (|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end

      if (write_en && (wstrb_addr >= (29)) && (wstrb_addr < 30)) begin
         ready_int = INVALIDATE_ready_i;
         if (internal_iob_valid & (|internal_iob_wstrb)) begin
            auto_addressed_nxt = 1'b0;
         end
      end



      // ######  FSM  #############

      //FSM default values
      iob_ready_nxt  = 1'b0;
      iob_rvalid_nxt = 1'b0;
      state_nxt      = state;

      //FSM state machine
      case (state)
         WAIT_REQ: begin
            if (internal_iob_valid) begin  // Wait for a valid request

               iob_ready_nxt = ready_int;

               // If is read and ready, go to WAIT_RVALID
               if (iob_ready_nxt && (!write_en)) begin
                  state_nxt = WAIT_RVALID;
               end
            end
         end

         default: begin  // WAIT_RVALID

            if (auto_addressed & iob_rvalid_out) begin  // Transfer done
               state_nxt = WAIT_REQ;
            end else if ((!auto_addressed) & rvalid_int) begin  // Transfer done
               state_nxt = WAIT_REQ;
            end else begin
               iob_rvalid_nxt = rvalid_int;

            end
         end
      endcase

   end  //always @*



        // store iob addr
   iob_reg_cae #(
      .DATA_W (ADDR_W),
      .RST_VAL({ADDR_W{1'b0}})
   ) internal_addr_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (internal_iob_addr_reg_en),
      // data_i port: Data input
      .data_i(internal_iob_addr),
      // data_o port: Data output
      .data_o(internal_iob_addr_reg)
   );

   // state register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) state_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(state_nxt),
      // data_o port: Data output
      .data_o(state)
   );

   // Convert CSR interface into internal IOb port
   iob_universal_converter_iob_iob #(
      .ADDR_W(ADDR_W),
      .DATA_W(DATA_W)
   ) iob_universal_converter (
      // s_s port: Subordinate port
      .iob_valid_i (iob_valid_i),
      .iob_addr_i  (iob_addr_i),
      .iob_wdata_i (iob_wdata_i),
      .iob_wstrb_i (iob_wstrb_i),
      .iob_rvalid_o(iob_rvalid_o),
      .iob_rdata_o (iob_rdata_o),
      .iob_ready_o (iob_ready_o),
      // m_m port: Manager port
      .iob_valid_o (internal_iob_valid),
      .iob_addr_o  (internal_iob_addr),
      .iob_wdata_o (internal_iob_wdata),
      .iob_wstrb_o (internal_iob_wstrb),
      .iob_rvalid_i(internal_iob_rvalid),
      .iob_rdata_i (internal_iob_rdata),
      .iob_ready_i (internal_iob_ready)
   );

   // rvalid register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) rvalid_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_rvalid_nxt),
      // data_o port: Data output
      .data_o(iob_rvalid_out)
   );

   // rdata register
   iob_reg_ca #(
      .DATA_W (32),
      .RST_VAL(32'b0)
   ) rdata_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_rdata_nxt),
      // data_o port: Data output
      .data_o(iob_rdata_out)
   );

   // ready register
   iob_reg_ca #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) ready_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      // data_i port: Data input
      .data_i(iob_ready_nxt),
      // data_o port: Data output
      .data_o(iob_ready_out)
   );


endmodule
