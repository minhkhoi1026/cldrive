//{"output":1,"scratch":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_only_fence(local int* scratch, global int* output) {
  int l = get_local_id(0);
  int g = get_group_id(0);
  scratch[hook(0, l)] = l;
  barrier(0x02);
  if (get_local_id(0) == 0) {
    int x = 0;
    for (int i = 0; i < get_local_size(0); i++) {
      x += scratch[hook(0, i)];
    }
    output[hook(1, g)] = x;
  }
}