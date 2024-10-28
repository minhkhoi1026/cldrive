//{"buffer":0,"length":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_min_buffer(global float* buffer, long length, global float* result) {
  int index = get_global_id(0);
  int stride = get_global_size(0);

  float min = (__builtin_inff());
  float max = -(__builtin_inff());

  while (index < length) {
    float value = buffer[hook(0, index)];
    min = fmin(min, value);
    max = fmax(max, value);
    index += stride;
  }

  result[hook(2, 2 * get_global_id(0) + 0)] = min;
  result[hook(2, 2 * get_global_id(0) + 1)] = max;
}