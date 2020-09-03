
#include <Rinternals.h>
#include <R_ext/Altrep.h>
#include <R_ext/Rdynload.h>

SEXP pkd_c_init();
SEXP pkd_c_new_lgl_bit(SEXP raw);

static const R_CallMethodDef CallEntries[] = {
  {"pkd_c_init", (DL_FUNC) &pkd_c_init, 0},
  {"pkd_c_new_lgl_bit", (DL_FUNC) &pkd_c_new_lgl_bit, 1},
  {NULL, NULL, 0}
};

void R_init_pkd(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}

SEXP pkd_c_init() {
  return R_NilValue;
}
