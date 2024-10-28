//{"dim":3,"res":2,"w":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decision_function(global const float* x, global const float* w, global float* res, int dim) {
  int id = get_global_id(0);
  float r = 0.f;
  for (int i = 0; i < dim; ++i)
    r += w[hook(1, i)] * x[hook(0, id * dim + i)];
  res[hook(2, id)] = r;
}