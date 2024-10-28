//{"c":1,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void getID(const int ySize, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int id = i + ySize * j;

  c[hook(1, id)] = id;
}