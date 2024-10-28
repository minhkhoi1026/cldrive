//{"dim":2,"ret":1,"w":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_l2norm(global const float* w, global float* ret, int dim) {
  float r = 0.f;
  for (int i = 0; i < dim; ++i)
    r += w[hook(0, i)] * w[hook(0, i)];
  ret[hook(1, 0)] = sqrt(r);
}