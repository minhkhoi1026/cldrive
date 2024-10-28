//{"buf":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global char* buf, char val) {
  int tid = get_global_id(0);
  buf[hook(0, tid)] += val;
}