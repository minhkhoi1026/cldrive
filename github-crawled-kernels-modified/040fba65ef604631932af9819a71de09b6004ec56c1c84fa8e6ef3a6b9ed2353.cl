//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void barrier_different_instructions(global int* data) {
  int i = get_global_id(0);
  if (i == 0) {
    data[hook(0, 0)] = 42;
    barrier(0x02);
  } else {
    barrier(0x02);
    data[hook(0, i)] = i + data[hook(0, 0)];
  }
}