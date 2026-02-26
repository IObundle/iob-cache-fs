/*
 * SPDX-FileCopyrightText: 2026 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81.0 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#ifndef H_IOB_FIFO_SYNC_CONF_H
#define H_IOB_FIFO_SYNC_CONF_H

#define IOB_FIFO_SYNC_W_DATA_W 21
#define IOB_FIFO_SYNC_R_DATA_W 21
#define IOB_FIFO_SYNC_ADDR_W 21
#define IOB_FIFO_SYNC_MAXDATA_W iob_max(W_DATA_W, R_DATA_W)
#define IOB_FIFO_SYNC_MINDATA_W iob_min(W_DATA_W, R_DATA_W)
#define IOB_FIFO_SYNC_R MAXDATA_W / MINDATA_W
#define IOB_FIFO_SYNC_MINADDR_W ADDR_W - $clog2(R)
#define IOB_FIFO_SYNC_W_ADDR_W (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
#define IOB_FIFO_SYNC_R_ADDR_W (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
#define IOB_FIFO_SYNC_ADDR_W_DIFF $clog2(R)
#define IOB_FIFO_SYNC_FIFO_SIZE                                                \
  {                                                                            \
    1'b1, {                                                                    \
      ADDR_W { 1'b0 }                                                          \
    }                                                                          \
  }
#define IOB_FIFO_SYNC_W_INCR                                                   \
  (W_DATA_W > R_DATA_W) ? {{ADDR_W - 1 {1'd0}}, {1'd1}} << ADDR_W_DIFF : {     \
    {ADDR_W - 1 {1'd0}}, { 1'd1 }                                              \
  }
#define IOB_FIFO_SYNC_R_INCR                                                   \
  (R_DATA_W > W_DATA_W) ? {{ADDR_W - 1 {1'd0}}, {1'd1}} << ADDR_W_DIFF : {     \
    {ADDR_W - 1 {1'd0}}, { 1'd1 }                                              \
  }
#define IOB_FIFO_SYNC_VERSION 0x008100

#endif // H_IOB_FIFO_SYNC_CONF_H
