//{"hw":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant char hw[] = "Hello World!";
kernel void hello(global char* out) {
  size_t tid = get_global_id(0);
  out[hook(0, tid)] = hw[hook(1, tid)];
}