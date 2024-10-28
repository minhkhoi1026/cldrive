//{"a":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct fakecomplex {
  int x;
  int y;
};

kernel void sum(global float* a, struct fakecomplex x) {
  int gid = get_global_id(0);
  a[hook(0, gid)] = x.x;
}