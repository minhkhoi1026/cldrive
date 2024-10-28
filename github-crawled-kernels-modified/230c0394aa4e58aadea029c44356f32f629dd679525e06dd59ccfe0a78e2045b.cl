//{"coords":0,"sizes":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_means(global unsigned int* coords, global int* sizes) {
  int pos = get_global_id(0);
  uint2 sum = vload2(pos, coords);
  int size = sizes[hook(1, pos)];
  uint2 centroid = (uint2)(sum.x / size, sum.y / size);
  vstore2(centroid, pos, coords);
}