//{"N":3,"ndvi":2,"nir":1,"red":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nd_vi(global const float* red, global const float* nir, global float* ndvi, global const int* N) {
  int i = get_global_id(0);
  if (i < N)
    ndvi[hook(2, i)] = (nir[hook(1, i)] - red[hook(0, i)]) / (nir[hook(1, i)] + red[hook(0, i)]);
}