//{"a":2,"c":3,"offset":1,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void RunAutomata(const int ySize, const int offset, global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;
  unsigned int count = 0;

  unsigned int my_offset_id = 0;
  unsigned int tSize = ySize * ySize;

  if ((i + (offset)) % (j) == 0) {
    c[hook(3, my_id)] = a[hook(2, my_id)] + 1;
  } else {
    c[hook(3, my_id)] = 0;
  }
}