//{"data":2,"dataSize":3,"histSize":4,"lower":0,"subHist":5,"subHists":6,"upper":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void generateSubHists(const unsigned int lower, const unsigned int upper, global int* data, unsigned int dataSize, unsigned int histSize, local unsigned int* subHist, global unsigned int* subHists) {
  unsigned int gid = get_global_id(0);
  unsigned int lid = get_local_id(0);

  if (lid == 0) {
    for (unsigned int i = 0; i < histSize; ++i) {
      subHist[hook(5, i)] = 0;
    }
  }

  barrier(0x01);

  for (unsigned int i = gid; i < dataSize; i += get_global_size(0)) {
    atomic_inc(&subHist[hook(5, data[ihook(2, i) - lower)]);
  }

  barrier(0x01);

  for (unsigned int i = lid; i < histSize; i += get_local_size(0)) {
    subHists[hook(6, get_group_id(0) * histSize + i)] = subHist[hook(5, i)];
  }
}