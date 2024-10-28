//{"count":2,"harris_threshold":3,"in":0,"strong":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void harris_count(global float* in, volatile global unsigned int* strong, volatile global int* count, float harris_threshold) {
  int i = get_global_id(0);

  float value = in[hook(0, i)];

  if (value > 0.0f) {
    atomic_inc(count);
    if (value > harris_threshold) {
      strong[hook(1, i)] += 1;
    }
  }
}