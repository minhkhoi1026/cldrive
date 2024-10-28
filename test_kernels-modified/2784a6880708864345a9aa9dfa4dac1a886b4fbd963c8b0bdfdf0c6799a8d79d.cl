//{"buff":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initInputBuffer(global float* buff) {
  int idx = get_global_id(0);
  buff[hook(0, idx)] = 0;
}