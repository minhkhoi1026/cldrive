//{"B":0,"D":1,"E":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int pow_two(int exp) {
  return 1 << exp;
}

int powi(int base, int exp) {
  if (exp == 0)
    return 1;
  int ret = base;
  for (int i = 1; i < exp; i++) {
    ret *= base;
  }
  return ret;
}

kernel void finalizeExtended(global int* B, global int* D, global int* E) {
  int globId = get_global_id(0);
  int grpId = get_group_id(0);

  E[hook(2, globId * 2)] = B[hook(0, globId * 2)] + D[hook(1, grpId)];
  E[hook(2, globId * 2 + 1)] = B[hook(0, globId * 2 + 1)] + D[hook(1, grpId)];
}