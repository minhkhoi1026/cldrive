//{"a":1,"dest":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AddToBuffer(const int ySize, global int* a, global int* dest) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;

  if (dest[hook(2, my_id)] > 0) {
    dest[hook(2, my_id)] += 5;
  }
  if (dest[hook(2, my_id)] > 1278) {
    dest[hook(2, my_id)] = 0;
  }
  if (a[hook(1, my_id)] != 0) {
    dest[hook(2, my_id)] = a[hook(1, my_id)];
  }
}