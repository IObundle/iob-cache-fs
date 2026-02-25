/*
 * SPDX-FileCopyrightText: 2025 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#ifndef H_IOB_CACHE_FRONT_END_CONF_H
#define H_IOB_CACHE_FRONT_END_CONF_H

#define IOB_CACHE_FRONT_END_ADDR_W_CSRS 5
#define IOB_CACHE_FRONT_END_ADDR_W IOB_CACHE_FRONT_END_ADDR_W_CSRS
#define IOB_CACHE_FRONT_END_DATA_W 32
#define IOB_CACHE_FRONT_END_FE_NBYTES_W $clog2(DATA_W / 8)
#define IOB_CACHE_FRONT_END_USE_CTRL 0
#define IOB_CACHE_FRONT_END_VERSION 0x0081

#endif // H_IOB_CACHE_FRONT_END_CONF_H
