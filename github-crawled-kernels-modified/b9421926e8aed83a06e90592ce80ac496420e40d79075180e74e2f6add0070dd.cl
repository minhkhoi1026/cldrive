//{"hist":1,"nchannels":3,"partial_hist":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClSumPartialHistogram(global unsigned int* partial_hist, global unsigned int* hist, unsigned int size, int nchannels) {
  int posx = get_global_id(0);
  int posy = get_global_id(1);
  int posz = get_global_id(2);

  if (posy == 0) {
    hist[hook(1, (posx * nchannels) + posz)] = 0;
  }

  atomic_add(&hist[hook(1, (posx * nchannels) + posz)], partial_hist[hook(0, (posy * 256 * nchannels) + (posx * nchannels) + posz)]);
}