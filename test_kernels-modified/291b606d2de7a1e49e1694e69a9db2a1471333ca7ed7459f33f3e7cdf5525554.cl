//{"column":1,"dimensions":2,"distances":0,"offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sumColumn(global float* distances, global const float* column, const ulong dimensions, const ulong offset) {
  size_t index = get_global_id(0);
  float distance = column[hook(1, (index + offset) / dimensions)] - column[hook(1, (index + offset) % dimensions)];

  distances[hook(0, index)] += distance * distance;
}