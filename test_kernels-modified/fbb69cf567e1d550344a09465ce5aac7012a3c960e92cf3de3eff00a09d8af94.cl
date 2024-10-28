//{"data":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bar(int* x) {
  *x += 1;
}

int foo() {
  int x = 0;
  bar(&x);
  return x;
}

kernel void many_alloca(global int* data, int n) {
  int x = 0;
  for (int i = 0; i < n; i++) {
    x += foo();
  }
  data[hook(0, get_global_id(0))] = x;
}