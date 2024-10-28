//{"A":1,"B":2,"output":3,"wSrc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub_scalar(const int wSrc, global const float* A, const float B, global float* output) {
  const int idx = get_global_id(0);
  const int idy = get_global_id(1);

  output[hook(3, idy * wSrc + idx)] = A[hook(1, idy * wSrc + idx)] - B;
}