//{"histogram":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_histogram(global int* histogram, int size) {
  const int g_id = get_global_id(0);
  const int g_size = get_global_size(0);

  if (g_id < size)
    histogram[hook(0, g_id)] = 0;

  if (g_size < size) {
    for (int i = g_size; i < size; i++) {
      const int index = g_id + i;
      if (index < size)
        histogram[hook(0, index)] = 0;
    }
  }
}