//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_read_write_race(global int* data, local int* scratch) {
  int l = get_local_id(0);
  scratch[hook(1, l)] = 0;
  barrier(0x01);

  scratch[hook(1, l)] = l;
  if (l == 0) {
    int x = 0;
    for (int i = 0; i < get_local_size(0); i++) {
      x += scratch[hook(1, i)];
    }
    *data = x;
  }
}