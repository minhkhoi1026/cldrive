//{"L":1,"k":3,"mat":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ludecomposition_U_pass(global float* mat, global float* L, unsigned size, unsigned k) {
  unsigned i = get_global_id(1);
  unsigned j = get_global_id(0);

  bool write = (i < size) & (j != k) & (j < size);

  float tmp = L[hook(1, i * size + k)];
  float res = mat[hook(0, i * size + j)] - tmp * mat[hook(0, k * size + j)];
  mat[hook(0, i * size + j)] = res;
}