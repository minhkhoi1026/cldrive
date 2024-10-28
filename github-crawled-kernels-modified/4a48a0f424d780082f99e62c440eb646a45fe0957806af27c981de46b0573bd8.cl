//{"a":1,"b":2,"dest":3,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BuildFrame(const int ySize, global int* a, global int* b, global int* dest) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;

  int out = a[hook(1, my_id)];

  if (b[hook(2, my_id)] != 0) {
    out = b[hook(2, my_id)];
  }

  dest[hook(3, my_id)] = out;
}