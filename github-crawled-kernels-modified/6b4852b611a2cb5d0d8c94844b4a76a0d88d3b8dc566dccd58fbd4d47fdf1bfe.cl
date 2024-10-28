//{"a":1,"length":0,"out":3,"scratch":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_f64_gpu(unsigned int length, global double* a, local double* scratch, global double* out) {
  const unsigned int globalSize = get_global_size(0);
  unsigned int globalIndex = get_global_id(0);
  double accumulator = (__builtin_inff());
  while (globalIndex < length) {
    accumulator = min(accumulator, a[hook(1, globalIndex)]);
    globalIndex += globalSize;
  }

  unsigned int localIndex = get_local_id(0);
  scratch[hook(2, localIndex)] = accumulator;
  barrier(0x01);
  for (unsigned int offset = get_local_size(0) / 2; offset != 0; offset >>= 1) {
    if (localIndex < offset) {
      scratch[hook(2, localIndex)] = min(scratch[hook(2, localIndex)], scratch[hook(2, localIndex + offset)]);
    }
    barrier(0x01);
  }
  if (localIndex == 0) {
    out[hook(3, get_group_id(0))] = scratch[hook(2, 0)];
  }
}