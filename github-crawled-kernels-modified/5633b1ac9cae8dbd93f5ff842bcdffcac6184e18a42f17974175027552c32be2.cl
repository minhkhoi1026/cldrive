//{"bits":3,"dst":1,"hist":4,"scannedHistograms":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Permute(global unsigned int* src, global unsigned int* dst, global unsigned int* scannedHistograms, unsigned int bits) {
  size_t globalId = get_global_id(0);

  unsigned int hist[(1 << 4)];
  for (int i = 0; i < (1 << 4); ++i)
    hist[hook(4, i)] = scannedHistograms[hook(2, get_global_size(0) * i + globalId)];

  for (int i = 0; i < 32; ++i) {
    unsigned int value = src[hook(0, globalId * 32 + i)];
    unsigned int pos = (value >> bits) & ((1 << 4) - 1);
    unsigned int index = hist[hook(4, pos)]++;
    dst[hook(1, index)] = value;
  }
}