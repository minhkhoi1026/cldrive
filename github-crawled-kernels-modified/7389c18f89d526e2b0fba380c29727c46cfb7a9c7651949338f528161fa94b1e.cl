//{"c":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct dt {
  int x[2];
  int y;
} __attribute((aligned(16)));

kernel void foo(constant struct dt* c) {
}