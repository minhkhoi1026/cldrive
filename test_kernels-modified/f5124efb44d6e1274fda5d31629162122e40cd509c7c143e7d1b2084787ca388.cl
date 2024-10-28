//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void printString(global char* out) {
  size_t tid = get_global_id(0);
  out[hook(0, tid)] = out[hook(0, tid)];
}