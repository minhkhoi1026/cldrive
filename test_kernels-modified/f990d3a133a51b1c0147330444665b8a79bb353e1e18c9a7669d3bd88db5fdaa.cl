//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern constant float foo;
kernel void test(global float* buf) {
  buf[hook(0, 0)] += foo;
}