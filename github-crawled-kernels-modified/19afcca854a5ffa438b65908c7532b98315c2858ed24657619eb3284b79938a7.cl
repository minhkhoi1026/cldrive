//{"dobarrier":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k(global int* dobarrier) {
  int i = get_local_id(0);
  if (dobarrier[hook(0, i)]) {
    barrier(0x02);
  }
}