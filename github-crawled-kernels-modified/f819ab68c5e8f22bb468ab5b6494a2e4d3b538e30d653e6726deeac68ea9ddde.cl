//{"hist":0,"histSize":1,"nSubHists":3,"subHists":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceSubHists(global unsigned int* hist, unsigned int histSize, global unsigned int* subHists, unsigned int nSubHists) {
  unsigned int gid = get_global_id(0);

  for (unsigned int i = gid; i < histSize; i += get_global_size(0)) {
    unsigned int bin = 0;
    for (unsigned int j = 0; j < nSubHists; ++j) {
      bin += subHists[hook(2, j * histSize + i)];
    }
    hist[hook(0, i)] = bin;
  }
}