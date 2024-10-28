//{"a":4,"bs":3,"mx":1,"my":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PlaceBlock(const int ySize, int mx, int my, int bs, global int* a) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;
  unsigned int mouse_id = mx + ySize * my;

  int a_out = a[hook(4, my_id)];

  if ((i >= mx && i <= mx + bs) && (j >= my && j <= my + bs)) {
    a_out = 1;
  }

  a[hook(4, my_id)] = a_out;
}