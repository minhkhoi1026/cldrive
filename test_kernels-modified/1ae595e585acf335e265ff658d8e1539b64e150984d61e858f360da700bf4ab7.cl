//{"bits":2,"data":0,"hist":3,"histograms":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void HistogramLocal(global unsigned int* data, global unsigned int* histograms, unsigned int bits, local unsigned int* hist) {
  size_t globalId = get_global_id(0);
  size_t localId = get_local_id(0);

  hist += localId * (1 << 4);

  for (int i = 0; i < (1 << 4); ++i)
    hist[hook(3, i)] = 0;

  for (int i = 0; i < 32; ++i) {
    unsigned int value = data[hook(0, globalId * 32 + i)];
    unsigned int pos = (value >> bits) & ((1 << 4) - 1);
    hist[hook(3, pos)]++;
  }

  for (int i = 0; i < (1 << 4); ++i)
    histograms[hook(1, get_global_size(0) * i + globalId)] = hist[hook(3, i)];
}