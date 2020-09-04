
#include <Rinternals.h>
#include "port.h"
#include <memory.h>

#define PKD_DATA_SEXP(pkd) VECTOR_ELT(pkd, 0)
#define PKD_DATA(pkd) RAW(PKD_DATA_SEXP(pkd))
#define PKD_SIZEOF(pkd) INTEGER(VECTOR_ELT(pkd, 1))[0]
#define PKD_ENDIAN(pkd) INTEGER(VECTOR_ELT(pkd, 2))[0]
#define PKD_ATTR(pkd) VECTOR_ELT(pkd, 3)

#define PKD_XSIZE(pkd) Rf_xlength(PKD_DATA_SEXP(pkd))
#define PKD_XLENGTH(pkd) PKD_XSIZE(pkd) * PKD_SIZEOF(pkd)

#define PKD_BIG_ENDIAN 0
#define PKD_LITTLE_ENDIAN 1

#ifdef IS_BIG_ENDIAN
#define PKD_SYSTEM_ENDIAN PKD_BIG_ENDIAN
#elif defined(IS_LITTLE_ENDIAN)
#define PKD_SYSTEM_ENDIAN PKD_LITTLE_ENDIAN
#else
#error "Can't detect system endianness at compile time"
#endif

static inline SEXP pkd_clone(SEXP pkd, int copyData) {
  SEXP newData;
  if (copyData) {
    newData = PROTECT(Rf_allocVector(RAWSXP, PKD_XSIZE(pkd)));
    memcpy(RAW(newData), PKD_DATA(pkd), PKD_XSIZE(pkd));
  } else {
    newData = R_NilValue;
  }

  SEXP newSizeOf = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newSizeOf)[0] = PKD_SIZEOF(pkd);

  SEXP newEndian = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newEndian)[0] = PKD_ENDIAN(pkd);

  SEXP newAttr = PROTECT(Rf_duplicate(PKD_ATTR(pkd)));

  const char* pkdNames[] = {"data", "sizeof", "endian", "attr", ""};
  SEXP newPkd = PROTECT(Rf_mkNamed(VECSXP, pkdNames));
  SET_VECTOR_ELT(newPkd, 0, newData);
  SET_VECTOR_ELT(newPkd, 1, newSizeOf);
  SET_VECTOR_ELT(newPkd, 2, newEndian);
  SET_VECTOR_ELT(newPkd, 3, newAttr);

  if (copyData) {
    UNPROTECT(5);
  } else {
    UNPROTECT(4);
  }

  return newPkd;
}

static inline SEXP pkd_new(const char** attrNames) {
  SEXP newData = PROTECT(Rf_allocVector(RAWSXP, 0));

  SEXP newSizeOf = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newSizeOf)[0] = 1;

  SEXP newEndian = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(newEndian)[0] = NA_INTEGER;

  SEXP newAttr;
  if (attrNames == NULL) {
    newAttr = PROTECT(Rf_allocVector(VECSXP, 0L));
  } else {
    newAttr = PROTECT(Rf_mkNamed(VECSXP, attrNames));
  }

  const char* pkdNames[] = {"data", "sizeof", "endian", "attr", ""};
  SEXP newPkd = PROTECT(Rf_mkNamed(VECSXP, pkdNames));
  SET_VECTOR_ELT(newPkd, 0, newData);
  SET_VECTOR_ELT(newPkd, 1, newSizeOf);
  SET_VECTOR_ELT(newPkd, 2, newEndian);
  SET_VECTOR_ELT(newPkd, 3, newAttr);

  UNPROTECT(5);
  return newPkd;
}
