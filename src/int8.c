
#include "pkd.h"
#include <stdint.h>
#include <Rinternals.h>

SEXP int8_new() {
  return pkd_new(NULL);
}

SEXP pkd_c_int8_from_integer(SEXP intVector) {
  R_xlen_t len = Rf_xlength(intVector);

  SEXP data = PROTECT(Rf_allocVector(RAWSXP, len / sizeof(int8_t)));
  int8_t* pData = (int8_t*) RAW(data);

  int* pIntVector = INTEGER(intVector);

  for (R_xlen_t i = 0; i < len; i++) {
    pData[i] = pIntVector[i];
  }

  SEXP pkd = PROTECT(int8_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_int8_to_integer(SEXP pkd) {
  R_xlen_t len = PKD_XLENGTH(pkd);

  SEXP intVector = PROTECT(Rf_allocVector(INTSXP, len));
  int* pIntVector = INTEGER(intVector);

  int8_t* pData = (int8_t*) PKD_DATA(pkd);

  for (R_xlen_t i = 0; i < len; i++) {
    pIntVector[i] = pData[i];
  }

  UNPROTECT(1);
  return intVector;
}

SEXP pkd_c_int8_from_double(SEXP dblVector) {
  R_xlen_t len = Rf_xlength(dblVector);

  SEXP data = PROTECT(Rf_allocVector(RAWSXP, len / sizeof(int8_t)));
  int8_t* pData = (int8_t*) RAW(data);

  double* pDblVector = REAL(dblVector);

  for (R_xlen_t i = 0; i < len; i++) {
    pData[i] = pDblVector[i];
  }

  SEXP pkd = PROTECT(int8_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_int8_to_double(SEXP pkd) {
  R_xlen_t len = PKD_XLENGTH(pkd);

  SEXP dblVector = PROTECT(Rf_allocVector(REALSXP, len));
  double* pDblVector = REAL(dblVector);

  int8_t* pData = (int8_t*) PKD_DATA(pkd);

  for (R_xlen_t i = 0; i < len; i++) {
    pDblVector[i] = pData[i];
  }

  UNPROTECT(1);
  return dblVector;
}
