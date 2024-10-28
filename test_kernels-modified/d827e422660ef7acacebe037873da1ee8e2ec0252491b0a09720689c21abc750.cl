//{"binResult":1,"histo":0,"subHistogramSize":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bin256(global unsigned int* histo, global const unsigned int* binResult, unsigned int subHistogramSize) {
  size_t j = get_local_id(0);
  size_t binSize = get_global_size(0);
  unsigned int histValue = 0;
  for (int i = 0; i < subHistogramSize; ++i) {
    histValue += binResult[hook(1, i * binSize + j)];
  }
  histo[hook(0, j)] = histValue;
}