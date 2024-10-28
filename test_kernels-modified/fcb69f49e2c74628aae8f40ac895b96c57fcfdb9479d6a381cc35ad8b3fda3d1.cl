//{"dim":4,"idx":0,"res":3,"w":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_kernel(global const int* idx, global const float* x, global const float* w, global float* res, int dim) {
  int j = get_global_id(0);
  int id = idx[hook(0, j)];

  float r = 0.f;
  for (int i = 0; i < dim; ++i)
    r += w[hook(2, i)] * x[hook(1, id * dim + i)];
  res[hook(3, j)] = r;
}