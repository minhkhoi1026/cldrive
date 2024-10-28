//{"A":0,"D":1,"S":2,"size1":3,"size2":4,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bidiag_pack(global float* A, global float* D, global float* S, unsigned int size1, unsigned int size2, unsigned int stride) {
  unsigned int size = min(size1, size2);

  if (get_global_id(0) == 0)
    S[hook(2, 0)] = 0;

  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    D[hook(1, i)] = A[hook(0, i * stride + i)];
    S[hook(2, i + 1)] = (i + 1 < size2) ? A[hook(0, i * stride + (i + 1))] : 0;
  }
}