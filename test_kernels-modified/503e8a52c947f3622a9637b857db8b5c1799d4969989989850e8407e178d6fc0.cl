//{"n":1,"out":0,"s.arr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S {
  int arr[5];
};

struct S bar(int n) {
  struct S s;
  if (n > 0) {
    s.arr[hook(2, 0)] = n;
    s.arr[hook(2, 1)] = n + 1;
    s.arr[hook(2, 2)] = n + 2;
    s.arr[hook(2, 3)] = n + 3;
    s.arr[hook(2, 4)] = n + 4;
  }
  return s;
}
kernel void foo(global struct S* out, int n) {
  *out = bar(n);
}