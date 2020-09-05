
#include <Rinternals.h>
#include "pkd.h"

#define BIT_ONE ((unsigned char ) 0x80)
#define BIT_LGL_EXTRA_BITS(pkd) RAW(VECTOR_ELT(PKD_ATTR(pkd), 0))[0]
#define BIT_LGL_VALUE(data_, i_) 0 != (data_[i_ / 8] & (BIT_ONE >> (i_ % 8)))

static inline SEXP lgl1_new() {
  const char* names[] = {"extra_bits", ""};
  SEXP pkd = PROTECT(pkd_new(names));
  SEXP extraBits = PROTECT(Rf_allocVector(RAWSXP, 1));
  RAW(extraBits)[0] = 0;
  SET_VECTOR_ELT(PKD_ATTR(pkd), 0, extraBits);
  UNPROTECT(2);
  return pkd;
}

R_xlen_t lgl1_xlength(SEXP pkd) {
  R_xlen_t bitLglSize = PKD_XSIZE(pkd) - 1;
  if (bitLglSize == -1) {
    return 0;
  }

  unsigned char extraBits = BIT_LGL_EXTRA_BITS(pkd);
  return bitLglSize * 8 + extraBits;
}

SEXP lgl1_to_logical(SEXP pkd, R_xlen_t start, R_xlen_t end) {
  unsigned char* data = PKD_DATA(pkd);

  SEXP lgl = PROTECT(Rf_allocVector(LGLSXP, end - start));
  int* pLgl = INTEGER(lgl);

  for (R_xlen_t i = start; i < end; i++) {
    pLgl[i] = BIT_LGL_VALUE(data, i);
  }

  UNPROTECT(1);
  return lgl;
}

SEXP pkd_c_lgl1_length(SEXP pkd) {
  R_xlen_t size = lgl1_xlength(pkd);

  SEXP length = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(length)[0] = size;
  UNPROTECT(1);
  return length;
}

SEXP pkd_c_lgl1_to_logical(SEXP pkd) {
  R_xlen_t size = lgl1_xlength(pkd);
  return lgl1_to_logical(pkd, 0, size);
}

SEXP pkd_c_lgl1_from_logical(SEXP lgl) {
  R_xlen_t size = Rf_xlength(lgl);
  if (size == 0) {
    return lgl1_new();
  }

  int* pLgl = LOGICAL(lgl);

  R_xlen_t bitLglSize = (size - 1) / 8;
  unsigned char nExtraBits = size % 8;
  if (nExtraBits == 0) {
    nExtraBits = 8;
  }
  SEXP bitLgl = PROTECT(Rf_allocVector(RAWSXP, bitLglSize + 1));

  unsigned char* pData = RAW(bitLgl);
  unsigned char item;
  unsigned char lglValue;

  // set all but the last byte
  for (R_xlen_t i = 0; i < bitLglSize; i++) {
    item = 0;
    for (int j = 0; j < 8; j++) {
      lglValue = 0 != pLgl[i * 8 + j];
      item = item | (lglValue << (7 - j));
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
    lglValue = 0 != pLgl[lglIndex];
    lastItem = lastItem | (lglValue << (7 - j));
  }

  pData[bitLglSize] = lastItem;

  SEXP pkd = PROTECT(lgl1_new());
  SET_VECTOR_ELT(pkd, 0, bitLgl);
  BIT_LGL_EXTRA_BITS(pkd) = nExtraBits;

  UNPROTECT(2);
  return pkd;
}
