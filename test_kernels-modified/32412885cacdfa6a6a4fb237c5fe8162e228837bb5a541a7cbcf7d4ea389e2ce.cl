//{"buffer":0,"buffer_size":1,"one_over_sum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_float(global float* buffer, private unsigned int buffer_size, private float one_over_sum) {
  size_t i = get_global_id(0);

  if (i < buffer_size) {
    buffer[hook(0, i)] = buffer[hook(0, i)] * one_over_sum;

    if (buffer[hook(0, i)] < 0 || !isfinite(buffer[hook(0, i)]) || isnan(buffer[hook(0, i)]))
      buffer[hook(0, i)] = 0;
  }
}