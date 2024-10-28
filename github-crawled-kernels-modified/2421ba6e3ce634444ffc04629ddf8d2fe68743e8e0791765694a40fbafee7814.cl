//{"c":3,"dst":1,"num":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct xyz {
  unsigned short b;
  unsigned short e;
  unsigned int o;
};

kernel void compiler_group_size4(global struct xyz* src, global unsigned int* dst, unsigned int num, unsigned int c) {
  unsigned int idx = (unsigned int)get_global_id(0);
  if (idx >= num)
    return;
  struct xyz td = src[hook(0, idx)];
  for (unsigned x = td.b; x <= td.e; x++)
    dst[hook(1, td.o + x)] = c;
}