//{"multiplicands":1,"offset":3,"result":2,"seed":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill(const unsigned int seed, global unsigned int* multiplicands, global unsigned int* result, const unsigned int offset) {
  const unsigned int i = get_global_id(0);
  result[hook(2, offset + i)] = seed * multiplicands[hook(1, i)];
}