
#include "pkd.h"
#include <Rinternals.h>

SEXP lgl8_new() {
  SEXP pkd = PROTECT(pkd_new(NULL));
  PKD_SIZEOF(pkd) = 1;
  PKD_ENDIAN(pkd) = NA_INTEGER;
  UNPROTECT(1);
  return pkd;
}

SEXP pkd_c_lgl8_to_logical(SEXP pkd) {
  R_xlen_t size = PKD_XLENGTH(pkd);
  SEXP lgl = PROTECT(Rf_allocVector(LGLSXP, size));
  int* pLgl = LOGICAL(lgl);
  unsigned char* data = PKD_DATA(pkd);

  for (R_xlen_t i = 0; i < size; i++) {
    pLgl[i] = data[i];
  }

  UNPROTECT(1);
  return lgl;
}

SEXP pkd_c_lgl8_from_logical(SEXP lgl) {
  R_xlen_t size = Rf_xlength(lgl);
  int* pLgl = LOGICAL(lgl);


  SEXP lgl8 = PROTECT(Rf_allocVector(RAWSXP, size));
  unsigned char* data = RAW(lgl8);

  for (R_xlen_t i = 0; i < size; i++) {
    if (pLgl[i] == NA_LOGICAL) {
      Rf_error("Can't store NA values as lgl8");
    }
    data[i] = pLgl[i];
  }

  SEXP pkd = PROTECT(lgl8_new());
  SET_VECTOR_ELT(pkd, 0, lgl8);
  UNPROTECT(2);
  return pkd;
}
