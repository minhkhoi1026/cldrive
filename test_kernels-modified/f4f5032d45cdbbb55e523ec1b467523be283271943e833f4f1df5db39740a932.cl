//{"multiplicands":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiplicand(global unsigned int* multiplicands) {
  unsigned int a = 1099087573;
  multiplicands[hook(0, 0)] = a;
  for (unsigned int i = 1; i < 1024; i++) {
    multiplicands[hook(0, i)] = a * multiplicands[hook(0, i - 1)];
  }
}