//{"buffer":0,"buffer4":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clearBuffer(global int* restrict buffer, int size) {
  int index = get_global_id(0);
  global int4* buffer4 = (global int4*)buffer;
  int sizeDiv4 = size / 4;
  while (index < sizeDiv4) {
    buffer4[hook(2, index)] = (int4)0;
    index += get_global_size(0);
  }
  if (get_global_id(0) == 0)
    for (int i = sizeDiv4 * 4; i < size; i++)
      buffer[hook(0, i)] = 0;
}