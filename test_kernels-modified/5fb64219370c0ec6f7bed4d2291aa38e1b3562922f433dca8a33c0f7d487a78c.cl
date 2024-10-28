//{"output":0,"s.b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S {
  int a;
  char b[2];
};

kernel void static_array_padded_struct(global char* output) {
  struct S s = {-1, {42, 7}};
  int i = get_global_id(0);
  output[hook(0, i)] = s.b[hook(1, i)];
}