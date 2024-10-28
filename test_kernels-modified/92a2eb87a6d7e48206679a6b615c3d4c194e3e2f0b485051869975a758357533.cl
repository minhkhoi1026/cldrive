//{"buffer":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zero_buffer(global float* buffer, private int n) {
  size_t i = get_global_id(0);

  if (i < n)
    buffer[hook(0, i)] = 0;
}