
#include <Rinternals.h>
#include "pkd.h"

#define BIT_ONE ((unsigned char ) 0x80)
#define BIT_LGL_EXTRA_BITS(pkd) RAW(VECTOR_ELT(PKD_ATTR(pkd), 0))[0]
#define BIT_LGL_VALUE(data_, i_) 0 != (data_[i_ / 8] & (BIT_ONE >> (i_ % 8)))

R_xlen_t bitlgl_xlength(SEXP pkd) {
  R_xlen_t bitLglSize = PKD_XSIZE(pkd) - 1;
  if (bitLglSize == -1) {
    return 0;
  }

  unsigned char extraBits = BIT_LGL_EXTRA_BITS(pkd);
  return bitLglSize * 8 + extraBits;
}

SEXP bitlgl_to_logical(SEXP pkd, R_xlen_t start, R_xlen_t end, R_xlen_t stride) {
  unsigned char* data = PKD_DATA(pkd);

  SEXP lgl = PROTECT(Rf_allocVector(LGLSXP, end - start));
  int* pLgl = INTEGER(lgl);

  for (R_xlen_t i = start; i < end; i += stride) {
    pLgl[i] = BIT_LGL_VALUE(data, i);
  }

  UNPROTECT(1);
  return lgl;
}

SEXP pkd_c_bitlgl_length(SEXP pkd) {
  R_xlen_t size = bitlgl_xlength(pkd);

  SEXP length = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(length)[0] = size;
  UNPROTECT(1);
  return length;
}

SEXP pkd_c_bitlgl_to_logical(SEXP pkd) {
  R_xlen_t size = bitlgl_xlength(pkd);
  return bitlgl_to_logical(pkd, 0, size, 1);
}

SEXP pkd_c_bitlgl_from_logical(SEXP lgl) {
  R_xlen_t size = Rf_xlength(lgl);
  int* pLgl = LOGICAL(lgl);

  R_xlen_t bitLglSize;
  unsigned char nExtraBits;
  if (size == 0) {
    bitLglSize = 0;
    nExtraBits = 0;
  } else {
    bitLglSize = size / 8 + 1;
    nExtraBits = (bitLglSize * 8) % size;
  }

  SEXP bitLgl = PROTECT(Rf_allocVector(RAWSXP, bitLglSize + 1));

  if (size > 0) {
    unsigned char* pData = RAW(bitLgl);
    unsigned char item;

    // set all but the last byte
    for (R_xlen_t i = 0; i < bitLglSize; i++) {
      item = 0;
      for (int j = 0; j < 8; j++) {
        item = item | ((0 != pLgl[i * 8 + j]) << (8 - j));
      }

      pData[i] = item;
    }

    // set the last byte
    unsigned char lastItem = 0;
    for (int j = 0; j < 8; j++) {
      R_xlen_t lglIndex = bitLglSize * 8 + j;
      if (lglIndex >= size) {
        break;
      }
      lastItem = lastItem | ((0 != pLgl[lglIndex]) << (8 - j));
    }

    pData[bitLglSize] = lastItem;
  }

  SEXP pkd = PROTECT(pkd_new());
  SET_VECTOR_ELT(pkd, 0, bitLgl);
  BIT_LGL_EXTRA_BITS(pkd) = nExtraBits;

  UNPROTECT(3);
  return pkd;
}
