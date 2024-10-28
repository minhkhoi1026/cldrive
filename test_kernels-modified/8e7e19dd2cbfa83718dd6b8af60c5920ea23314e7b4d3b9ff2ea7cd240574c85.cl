//{"data":2,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_copy_buffer_row(global int* src, global int* dst, global int* data) {
  int row = data[hook(2, 0)];
  int size = data[hook(2, 1)];
  int id = (int)get_global_id(0);
  for (; id < size; id += row)
    dst[hook(1, id)] = src[hook(0, id)];
}