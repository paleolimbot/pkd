
#include "pkd.h"
#include <stdint.h>
#include <Rinternals.h>

SEXP uint16_new() {
  SEXP pkd = PROTECT(pkd_new(NULL));
  SEXP newSizeOf = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newSizeOf)[0] = 2;
  SET_VECTOR_ELT(pkd, 1, newSizeOf);
  SEXP newEndian = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newEndian)[0] = PKD_SYSTEM_ENDIAN;
  SET_VECTOR_ELT(pkd, 2, newEndian);
  UNPROTECT(3);
  return pkd;
}

SEXP pkd_c_uint16_from_integer(SEXP intVector) {
  PKD_DATA_FROM_INTEGER(intVector, uint16_t);

  SEXP pkd = PROTECT(uint16_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_uint16_to_integer(SEXP pkd) {
  PKD_INT_VECTOR_FROM_PKD(pkd, uint16_t);
  UNPROTECT(1);
  return intVector;
}

SEXP pkd_c_uint16_from_double(SEXP dblVector) {
  PKD_DATA_FROM_DOUBLE(dblVector, uint16_t);

  SEXP pkd = PROTECT(uint16_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_uint16_to_double(SEXP pkd) {
  PKD_DBL_VECTOR_FROM_PKD(pkd, uint16_t);
  UNPROTECT(1);
  return dblVector;
}
