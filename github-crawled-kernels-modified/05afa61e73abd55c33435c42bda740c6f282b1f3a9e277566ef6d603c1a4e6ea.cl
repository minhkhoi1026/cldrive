//{"array":1,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memcpy_from_constant(global float* result) {
  const float array[] = {-2.0f, -1.0f, 0.0f, 1.0f, 2.0f};
  for (size_t i = 0; i < 5; ++i) {
    result[hook(0, i)] = array[hook(1, i)];
  }
}