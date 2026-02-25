/*
 * SPDX-FileCopyrightText: 2025 IObundle, Lda
 *
 * SPDX-License-Identifier: MIT
 *
 * Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).
 */

#include "iob_cache_iob_csrs.h"

// Base Address
static uint32_t base;
void iob_cache_iob_csrs_init_baseaddr(uint32_t addr) { base = addr; }

// Core Setters and Getters
uint8_t iob_cache_iob_csrs_get_WTB_EMPTY() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_WTB_EMPTY_ADDR,
                  IOB_CACHE_IOB_CSRS_WTB_EMPTY_W);
}

uint8_t iob_cache_iob_csrs_get_WTB_FULL() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_WTB_FULL_ADDR,
                  IOB_CACHE_IOB_CSRS_WTB_FULL_W);
}

uint32_t iob_cache_iob_csrs_get_RW_HIT() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_RW_HIT_ADDR,
                  IOB_CACHE_IOB_CSRS_RW_HIT_W);
}

uint32_t iob_cache_iob_csrs_get_RW_MISS() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_RW_MISS_ADDR,
                  IOB_CACHE_IOB_CSRS_RW_MISS_W);
}

uint32_t iob_cache_iob_csrs_get_READ_HIT() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_READ_HIT_ADDR,
                  IOB_CACHE_IOB_CSRS_READ_HIT_W);
}

uint32_t iob_cache_iob_csrs_get_READ_MISS() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_READ_MISS_ADDR,
                  IOB_CACHE_IOB_CSRS_READ_MISS_W);
}

uint32_t iob_cache_iob_csrs_get_WRITE_HIT() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_WRITE_HIT_ADDR,
                  IOB_CACHE_IOB_CSRS_WRITE_HIT_W);
}

uint32_t iob_cache_iob_csrs_get_WRITE_MISS() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_WRITE_MISS_ADDR,
                  IOB_CACHE_IOB_CSRS_WRITE_MISS_W);
}

void iob_cache_iob_csrs_set_RST_CNTRS(uint8_t value) {
  iob_write(base + IOB_CACHE_IOB_CSRS_RST_CNTRS_ADDR,
            IOB_CACHE_IOB_CSRS_RST_CNTRS_W, value);
}

void iob_cache_iob_csrs_set_INVALIDATE(uint8_t value) {
  iob_write(base + IOB_CACHE_IOB_CSRS_INVALIDATE_ADDR,
            IOB_CACHE_IOB_CSRS_INVALIDATE_W, value);
}

uint16_t iob_cache_iob_csrs_get_version() {
  return iob_read(base + IOB_CACHE_IOB_CSRS_VERSION_ADDR,
                  IOB_CACHE_IOB_CSRS_VERSION_W);
}
