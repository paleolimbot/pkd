
#include "pkd.h"
#include <stdint.h>
#include <Rinternals.h>

SEXP int8_new() {
  return pkd_new(NULL);
}

SEXP pkd_c_int8_from_integer(SEXP intVector) {
  PKD_DATA_FROM_INTEGER(intVector, int8_t);

  SEXP pkd = PROTECT(int8_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_int8_to_integer(SEXP pkd) {
  PKD_INT_VECTOR_FROM_PKD(pkd, int8_t);
  UNPROTECT(1);
  return intVector;
}

SEXP pkd_c_int8_from_double(SEXP dblVector) {
  PKD_DATA_FROM_DOUBLE(dblVector, int8_t);

  SEXP pkd = PROTECT(int8_new());
  SET_VECTOR_ELT(pkd, 0, data);

  UNPROTECT(2);
  return pkd;
}

SEXP pkd_c_int8_to_double(SEXP pkd) {
  PKD_DBL_VECTOR_FROM_PKD(pkd, int8_t);
  UNPROTECT(1);
  return dblVector;
}
