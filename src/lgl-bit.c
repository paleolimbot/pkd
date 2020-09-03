
#include <stdint.h>

#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Altrep.h>

#define BIT_ONE ((unsigned char ) 0x80)

R_xlen_t pkd_altrep_length_lgl_bit(SEXP lglBit) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) == LGLSXP) {
    return Rf_xlength(data2);
  }

  unsigned char extraBits = RAW(R_altrep_data2(lglBit))[0];
  return Rf_xlength(R_altrep_data1(lglBit)) - 1 + extraBits;
}

void pkd_materialize_lgl_bit(SEXP lglBit) {
  unsigned char* data = RAW(R_altrep_data1(lglBit));

  R_xlen_t size = pkd_altrep_length_lgl_bit(lglBit);
  SEXP lgl = PROTECT(Rf_allocVector(LGLSXP, size));
  int* pLgl = INTEGER(lgl);

  for (R_xlen_t i = 0; i < size; i++) {
    pLgl[i] = data[i / 8] & (BIT_ONE >> (i % 8));
  }

  R_set_altrep_data1(lglBit, R_NilValue);
  R_set_altrep_data2(lglBit, lgl);
  UNPROTECT(1);
}

Rboolean pkd_altrep_inspect_lgl_bit(SEXP lglBit, int pre, int deep, int pvec,
                                    void (*inspect_subtree)(SEXP, int, int, int)) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) == LGLSXP) {
    Rprintf("pkd_lgl_bit [%d] [materialized] <%p>\n", &lglBit, pkd_altrep_length_lgl_bit(lglBit));
  } else {
    Rprintf("pkd_lgl_bit [%d] [lazy] <%p>\n", &lglBit, pkd_altrep_length_lgl_bit(lglBit));
  }

  return TRUE;
}

void* pkd_altrep_dataptr_lgl_bit(SEXP lglBit, Rboolean writeable) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) == LGLSXP) {
    return LOGICAL(data2);
  }

  pkd_materialize_lgl_bit(lglBit);
  return LOGICAL(R_altrep_data2(lglBit));
}

const void* pkd_altrep_dataptr_or_null_lgl_bit(SEXP lglBit) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) == LGLSXP) {
    return LOGICAL(data2);
  } else {
    return NULL;
  }
}

int pkd_altrep_elt_lgl_bit(SEXP lglBit, R_xlen_t i) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) == LGLSXP) {
    return LOGICAL(data2)[i];
  }

  unsigned char* data = RAW(R_altrep_data1(lglBit));
  return data[i / 8] & (BIT_ONE >> (i % 8));
}

R_xlen_t pkd_altrep_get_region_lgl_bit(SEXP lglBit, R_xlen_t start, R_xlen_t size, int* out) {
  SEXP data2 = R_altrep_data2(lglBit);
  if (TYPEOF(data2) != LGLSXP) {
    pkd_materialize_lgl_bit(lglBit);
    data2 =  R_altrep_data2(lglBit);
  }

  *out = LOGICAL(data2)[start];
  R_xlen_t totalSize = Rf_xlength(data2);

  return totalSize > size ? totalSize : size;
}

int pkd_altrep_no_na_lgl_bit(SEXP lglBit) {
  return FALSE;
}

extern R_altrep_class_t pkd_altrep_class_t_lgl_bit;

void pkd_altrep_init_lgl_bit(DllInfo* dll) {
  pkd_altrep_class_t_lgl_bit = R_make_altlogical_class("pkd_lgl_bit", "pkd", dll);

  // altrep
  R_set_altrep_Length_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_length_lgl_bit);
  R_set_altrep_Inspect_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_inspect_lgl_bit);

  // altvec
  R_set_altvec_Dataptr_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_dataptr_lgl_bit);
  R_set_altvec_Dataptr_or_null_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_dataptr_or_null_lgl_bit);
  //R_set_altvec_Extract_subset_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_extract_subset_lgl_bit);

  // altlogical
  R_set_altlogical_Elt_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_elt_lgl_bit);
  R_set_altlogical_Get_region_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_get_region_lgl_bit);
  R_set_altlogical_No_NA_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_no_na_lgl_bit);
  //R_set_altlogical_Is_sorted_method(pkd_altrep_class_t_lgl_bit, pkd_altrep_is_sorted_lgl_bit);
}

SEXP pkd_c_new_lgl_bit(SEXP raw, SEXP extraBits) {
  if (RAW(extraBits)[0] > 7) {
    Rf_error("Number of extra bits must be in range 0-7");
  }

  return R_new_altrep(pkd_altrep_class_t_lgl_bit, raw, extraBits);
}
