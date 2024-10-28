//{"data":1,"localData":3,"n":0,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(unsigned int n, global unsigned int* data, global unsigned int* result, local unsigned int* localData) {
  unsigned int lid = get_local_id(0);
  unsigned int lsz = get_local_size(0);
  unsigned int sum = 0;
  for (unsigned int i = lid; i < n; i += lsz) {
    sum += data[hook(1, i)];
  }

  localData[hook(3, lid)] = sum;
  for (unsigned int offset = lsz / 2; offset > 0; offset /= 2) {
    barrier(0x01);
    if (lid < offset) {
      localData[hook(3, lid)] += localData[hook(3, lid + offset)];
    }
  }

  if (lid == 0) {
    *result = localData[hook(3, lid)];
  }
}