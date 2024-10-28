//{"numberOfElements":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Memzero(int numberOfElements, global int* output) {
  const int min = (numberOfElements * (get_global_id(0) + 0)) / get_global_size(0);
  const int max = (numberOfElements * (get_global_id(0) + 1)) / get_global_size(0);
  for (int i = min; i < max; i++) {
    output[hook(1, i)] = 0;
  }
}