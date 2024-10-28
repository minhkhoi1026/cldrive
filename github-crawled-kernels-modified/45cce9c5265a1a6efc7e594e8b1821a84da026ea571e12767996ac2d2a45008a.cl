//{"buf":0,"buf2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void example(global char* buf, global char* buf2) {
  int x = get_global_id(0);

  buf2[hook(1, x)] = buf[hook(0, x)];
}