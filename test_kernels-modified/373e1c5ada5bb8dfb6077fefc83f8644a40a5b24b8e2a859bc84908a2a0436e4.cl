//{"idx":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
char bar(char a, char b) {
  return a + b;
}

kernel void foo(global char* in, global char* out, int idx) {
  char x = in[hook(0, idx)];
  char y = in[hook(0, idx + 1)];
  out[hook(1, idx)] = bar(x, y);
}