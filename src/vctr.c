
#include "pkd.h"
#include <stdint.h>

SEXP pkd_subset_lgl(SEXP pkd, SEXP lgl) {
  R_xlen_t size = PKD_XLENGTH(pkd);
  R_xlen_t lglSize = Rf_xlength(lgl);
  int* pLgl = LOGICAL(lgl);

  if ((lglSize == 1) && (pLgl[0] == TRUE)) {
    return pkd;
  } else if ((lglSize == 1) && (pLgl[0] == FALSE)) {
    return pkd_clone(pkd, FALSE);
  } else if (lglSize != size) {
    Rf_error("Can't subset pkd_vctr of size %d with logical vector of size %d", size, lglSize);
  }

  // calculate output size, check NA
  R_xlen_t outLength = 0;
  for (R_xlen_t i = 0; i < size; i++) {
    if (pLgl[i] == NA_LOGICAL) {
      Rf_error("Can't subset a pkd_vctr with NA");
    }

    outLength += 0 != pLgl[i];
  }

  int sizeOf = PKD_SIZEOF(pkd);
  SEXP lgl8 = PROTECT(Rf_allocVector(RAWSXP, outLength * sizeOf));
  unsigned char* data = PKD_DATA(pkd);
  unsigned char* outData = RAW(lgl8);

  for (R_xlen_t i = 0; i < size; i++) {
    if (pLgl[i]) {
      memcpy(outData, data + (i * sizeOf), sizeOf);
      outData += sizeOf;
    }
  }

  SEXP newPkd = PROTECT(pkd_clone(pkd, FALSE));
  SET_VECTOR_ELT(newPkd, 0, lgl8);

  UNPROTECT(2);
  return newPkd;
}

SEXP pkd_subset_dbl(SEXP pkd, SEXP dbl) {
  int sizeOf = PKD_SIZEOF(pkd);
  unsigned char* data = PKD_DATA(pkd);

  R_xlen_t dblSize = Rf_xlength(dbl);
  double* pDbl = REAL(dbl);

  SEXP lgl8 = PROTECT(Rf_allocVector(RAWSXP, dblSize * sizeOf));
  unsigned char* newData = RAW(lgl8);

  for (R_xlen_t i = 0; i < dblSize; i++) {
    memcpy(newData, data + ((R_xlen_t) pDbl[i] - 1) * sizeOf, sizeOf);
    newData += sizeOf;
  }

  SEXP newPkd = PROTECT(pkd_clone(pkd, FALSE));
  SET_VECTOR_ELT(newPkd, 0, lgl8);
  UNPROTECT(2);
  return newPkd;
}

SEXP pkd_subset_int(SEXP pkd, SEXP int_) {
  int sizeOf = PKD_SIZEOF(pkd);
  unsigned char* data = PKD_DATA(pkd);

  R_xlen_t intSize = Rf_xlength(int_);
  int* pInt = INTEGER(int_);

  SEXP lgl8 = PROTECT(Rf_allocVector(RAWSXP, intSize * sizeOf));
  unsigned char* newData = RAW(lgl8);

  for (R_xlen_t i = 0; i < intSize; i++) {
    memcpy(newData, data + ((pInt[i] - 1) * sizeOf), sizeOf);
    newData += sizeOf;
  }

  SEXP newPkd = PROTECT(pkd_clone(pkd, FALSE));
  SET_VECTOR_ELT(newPkd, 0, lgl8);
  UNPROTECT(2);
  return newPkd;
}

SEXP pkd_c_subset(SEXP pkd, SEXP indices) {
  if (TYPEOF(indices) == LGLSXP) {
    return pkd_subset_lgl(pkd, indices);
  } else if (TYPEOF(indices) == REALSXP) {
    return pkd_subset_dbl(pkd, indices);
  } else if (TYPEOF(indices) == INTSXP) {
    return pkd_subset_int(pkd, indices);
  } else {
    Rf_error("Can't subset 'pkd_vctr' with this type of object");
  }

  return R_NilValue;
}

SEXP pkd_c_expand_indices(SEXP pkd, SEXP indices) {
  int sizeOf = PKD_SIZEOF(pkd);
  R_xlen_t indexSize = Rf_xlength(indices);

  SEXP newIndices;
  if (TYPEOF(indices) == LGLSXP) {
    if (indexSize != PKD_XLENGTH(pkd)) {
      Rf_error(
        "Can't subset-assign pkd_vctr of size %d with logical vector of size %d",
        PKD_XLENGTH(pkd),
        indexSize
      );
    }

    newIndices = PROTECT(Rf_allocVector(LGLSXP, indexSize * sizeOf));
    int* pNewIndices = LOGICAL(newIndices);
    int* pIndices = LOGICAL(indices);

    for (R_xlen_t i = 0; i < indexSize; i++) {
      if (pIndices[i] == NA_LOGICAL) {
        Rf_error("Can't subset-assign a 'pkd_vctr' with NA");
      }
      int newValue = 0 != pIndices[i];
      for (int j = 0; j < sizeOf; j++) {
        pNewIndices[i * sizeOf + j] = newValue;
      }
    }
  } else if (TYPEOF(indices) == REALSXP) {
    newIndices = PROTECT(Rf_allocVector(REALSXP, indexSize * sizeOf));
    double* pNewIndices = REAL(newIndices);
    double* pIndices = REAL(indices);

    for (R_xlen_t i = 0; i < indexSize; i++) {
      if (ISNA(pIndices[i])) {
        Rf_error("Can't subset-assign a 'pkd_vctr' with NA");
      }
      for (int j = 0; j < sizeOf; j++) {
        pNewIndices[i * sizeOf + j] = (pIndices[i] - 1) * sizeOf + j + 1;
      }
    }

  } else if (TYPEOF(indices) == INTSXP) {
    newIndices = PROTECT(Rf_allocVector(REALSXP, indexSize * sizeOf));
    double* pNewIndices = REAL(newIndices);
    int* pIndices = INTEGER(indices);

    for (R_xlen_t i = 0; i < indexSize; i++) {
      if (pIndices[i] == NA_INTEGER) {
        Rf_error("Can't subset-assign a 'pkd_vctr' with NA");
      }
      for (int j = 0; j < sizeOf; j++) {
        pNewIndices[i * sizeOf + j] = (pIndices[i] - 1) * sizeOf + j + 1;
      }
    }
  } else {
    Rf_error("Can't subset-assign a 'pkd_vctr' with this type of object");
  }

  UNPROTECT(1);
  return newIndices;
}

SEXP pkd_c_system_endian() {
  SEXP out = PROTECT(Rf_allocVector(INTSXP, 1));
  INTEGER(out)[0] = PKD_SYSTEM_ENDIAN;
  UNPROTECT(1);
  return out;
}

SEXP pkd_c_swap_endian(SEXP pkd, SEXP clone) {
  if (PKD_ENDIAN(pkd) == NA_REAL) {
    return pkd;
  }

  NEW_PKD_MAYBE_COPY(pkd, newPkd, clone);

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
  } else if (sizeOf != 1) {
    Rf_error("Can't swap endian with sizeof=%d", sizeOf);
  }

  if (PKD_ENDIAN(pkd) == PKD_BIG_ENDIAN) {
    PKD_ENDIAN(newPkd) = PKD_LITTLE_ENDIAN;
  } else {
    PKD_ENDIAN(newPkd) = PKD_LITTLE_ENDIAN;
  }

  NEW_PKD_MAYBE_UNPROTECT(clone);
  return newPkd;
}
