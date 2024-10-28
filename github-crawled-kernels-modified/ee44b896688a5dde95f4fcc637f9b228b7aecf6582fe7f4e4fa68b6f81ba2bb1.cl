//{"L":1,"k":3,"mat":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ludecomposition_pass_hard_float(global float* mat, global float* L, unsigned size, unsigned k) {
  unsigned i = get_global_id(1);
  unsigned j = get_global_id(0);

  float tmp = mat[hook(0, i * size + k)] / mat[hook(0, k * size + k)];
  float res = mat[hook(0, i * size + j)] - tmp * mat[hook(0, k * size + j)];

  if (i < size) {
    if (j == k) {
      L[hook(1, i * size + k)] = tmp;
      if (i == k + 1) {
        L[hook(1, k * size + k)] = 1;
      }
    } else if (j < size) {
      mat[hook(0, i * size + j)] = res;
    }
  }
}