//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_global_fence_race(global int* data, global int* scratch) {
  int i = get_global_id(0);
  int l = get_local_id(0);
  int g = get_group_id(0);
  atomic_add(scratch, i);
  barrier(0x02);
  if (l == 0) {
    data[hook(0, g)] = *scratch;
  }
}