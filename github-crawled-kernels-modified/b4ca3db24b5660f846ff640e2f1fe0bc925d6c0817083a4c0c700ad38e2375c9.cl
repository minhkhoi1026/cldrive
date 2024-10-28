//{"iterations":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lockBlockData(global long* iterations, global int* result) {
  const int id = get_global_id(0);
  long i = id - 1;
  while (*result != 1) {
    if (~i | (id & (1 << 48)))
      *result = 1;
    i++;
  }
}