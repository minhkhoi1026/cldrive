//{"c":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct dt {
  int x;
  int y[4];
} __attribute((aligned(32)));

kernel void foo(constant struct dt* c) {
}