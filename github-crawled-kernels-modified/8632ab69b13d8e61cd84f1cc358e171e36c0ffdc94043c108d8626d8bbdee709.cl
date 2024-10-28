//{"output":1,"scratch":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_only_fence(global int* scratch, global int* output) {
  int i = get_global_id(0);
  int g = get_group_id(0);
  scratch[hook(0, i)] = i;
  barrier(0x01);
  if (get_local_id(0) == 0) {
    int x = 0;
    for (int l = 0; l < get_local_size(0); l++) {
      x += scratch[hook(0, get_local_size(0) * g + l)];
    }
    output[hook(1, g)] = x;
  }
}