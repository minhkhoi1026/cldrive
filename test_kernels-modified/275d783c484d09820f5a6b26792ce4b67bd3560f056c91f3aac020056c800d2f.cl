//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_write_write_race(global int* data, local int* scratch) {
  int i = get_global_id(0);
  *scratch = i;
  barrier(0x01);
  data[hook(0, i)] = *scratch;
}