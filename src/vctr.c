
#include "pkd.h"
#include <stdint.h>

SEXP pkd_c_system_endian() {
  SEXP out = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(out)[0] = PKD_SYSTEM_ENDIAN;
  UNPROTECT(1);
  return out;
}

SEXP pkd_c_swap_endian(SEXP pkd) {
  if (PKD_ENDIAN(pkd) == NA_REAL) {
    return pkd;
  }

  SEXP newPkd = PROTECT(pkd_clone(pkd));
  int sizeOf = PKD_SIZEOF(pkd);
  R_xlen_t len = PKD_XLENGTH(pkd);

  if (sizeOf == 2) {
    uint16_t* data = (uint16_t*) PKD_DATA(pkd);
    uint16_t* newData = (uint16_t*) PKD_DATA(newPkd);
    for (R_xlen_t i = 0; i < len; i++) {
      newData[i] = bswap_16(data[i]);
    }
  } else if (sizeOf == 4) {
    uint32_t* data = (uint32_t*) PKD_DATA(pkd);
    uint32_t* newData = (uint32_t*) PKD_DATA(newPkd);
    for (R_xlen_t i = 0; i < len; i++) {
      newData[i] = bswap_32(data[i]);
    }
  } else if (sizeOf == 8) {
    uint64_t* data = (uint64_t*) PKD_DATA(pkd);
    uint64_t* newData = (uint64_t*) PKD_DATA(newPkd);
    for (R_xlen_t i = 0; i < len; i++) {
      newData[i] = bswap_64(data[i]);
    }
  }

  if (PKD_ENDIAN(pkd) == PKD_BIG_ENDIAN) {
    PKD_ENDIAN(newPkd) = PKD_LITTLE_ENDIAN;
  } else {
    PKD_ENDIAN(newPkd) = PKD_LITTLE_ENDIAN;
  }

  UNPROTECT(1);
  return newPkd;
}
