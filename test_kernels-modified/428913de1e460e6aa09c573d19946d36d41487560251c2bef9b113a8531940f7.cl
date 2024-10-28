//{"n":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int div_up(unsigned int a, unsigned int b) {
  return (a + b - 1) / b;
}

unsigned int round_mul_up(unsigned int a, unsigned int b) {
  return div_up(a, b) * b;
}

kernel void vecinit(global int* out, int n) {
  const int i = get_global_id(0);
  if (i < n)
    out[hook(0, i)] = (i + 1);
}