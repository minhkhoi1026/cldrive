//{"data":0,"histogram":2,"localHistogram":3,"numData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global int* data, int numData, global int* histogram) {
  local int localHistogram[256];
  int lid = get_local_id(0);
  int gid = get_global_id(0);

  for (int i = lid; i < 256; i += get_local_size(0)) {
    localHistogram[hook(3, i)] = 0;
  }

  barrier(0x01);

  for (int i = gid; i < numData; i += get_global_size(0)) {
    atomic_add(&localHistogram[hook(3, data[ihook(0, i))], 1);
  }

  barrier(0x01);

  for (int i = lid; i < 256; i += get_local_size(0)) {
    atomic_add(&histogram[hook(2, i)], localHistogram[hook(3, i)]);
  }
}