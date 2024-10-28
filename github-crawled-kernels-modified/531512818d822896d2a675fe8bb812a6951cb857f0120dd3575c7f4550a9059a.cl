//{"a":0,"b":1,"c":2,"wa":3,"wb":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_matmul_f32(global const float* a, global const float* b, global float* c, const ulong wa, const ulong wb) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);

  float accum = 0.0;
  for (ulong k = 0; k < wa; k++) {
    accum += a[hook(0, i * wa + k)] * b[hook(1, k * wb + j)];
  }
  c[hook(2, i * wb + j)] = accum;
}