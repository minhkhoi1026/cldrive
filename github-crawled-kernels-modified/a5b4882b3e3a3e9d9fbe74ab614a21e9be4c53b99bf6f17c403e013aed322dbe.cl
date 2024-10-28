//{"buffer":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear_buffer(global uchar4* buffer, unsigned int size) {
  if (get_global_id(0) >= size)
    return;

  buffer[hook(0, get_global_id(0))] = 0;
}