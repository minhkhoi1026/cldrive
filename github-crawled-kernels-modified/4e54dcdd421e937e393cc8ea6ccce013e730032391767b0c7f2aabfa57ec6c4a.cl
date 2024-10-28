//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union U {
  unsigned int a;
  unsigned int b;
};

unsigned int func(union U value) {
  unsigned int ret = value.a;
  value.b = 777;
  return ret;
}

kernel void byval_function_argument(global unsigned int* output) {
  union U u = {42};
  output[hook(0, 0)] = func(u);
  output[hook(0, 1)] = u.b;
}