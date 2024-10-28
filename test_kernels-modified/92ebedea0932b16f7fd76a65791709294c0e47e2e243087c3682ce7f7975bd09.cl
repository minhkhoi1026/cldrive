//{"A":1,"lda":3,"nb":0,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
kernel void cset_nbxnb_to_zero(int nb, global float2* A, int offset, int lda) {
  int ind = get_group_id(0) * lda + get_local_id(0);
  int i, j;
  A += (ind + offset);
  float2 MAGMA_C_ZERO;

  MAGMA_C_ZERO = (float2)(0.0, 0.0);

  for (i = 0; i < nb; i += 32) {
    for (j = 0; j < nb; j += 32)
      A[hook(1, j)] = MAGMA_C_ZERO;
    A += 32 * lda;
  }
}