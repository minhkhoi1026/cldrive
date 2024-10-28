//{"n":1,"struct_out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct a {
  int x;
  int y;
  float arr[5];
};

kernel void foo(global struct a* struct_out, int n) {
  struct a local_a;
  if (n == 0) {
    local_a.x = 0;
  }
  *struct_out = local_a;
}