//{"A":0,"last_n":3,"n":2,"p":5,"q":4,"stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void final_iter_update(global float* A, unsigned int stride, unsigned int n, unsigned int last_n, float q, float p) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  for (unsigned int px = glb_id; px < last_n; px += glb_sz) {
    float v_in = A[hook(0, n * stride + px)];
    float z = A[hook(0, (n - 1) * stride + px)];
    A[hook(0, (n - 1) * stride + px)] = q * z + p * v_in;
    A[hook(0, n * stride + px)] = q * v_in - p * z;
  }
}