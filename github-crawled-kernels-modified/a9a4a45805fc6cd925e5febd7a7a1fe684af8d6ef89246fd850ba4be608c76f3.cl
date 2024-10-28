//{"data":0,"histogram":1,"histogramSize":3,"lhistogram":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_local(global int* data, global int* histogram, local int* lhistogram, const int histogramSize) {
  int id = get_global_id(0);
  int lid = get_local_id(0);

  if (lid < histogramSize) {
    lhistogram[hook(2, lid)] = 0;
  }
  barrier(0x01);

  atomic_add(&lhistogram[hook(2, data[ihook(0, id))], 1);

  barrier(0x01);

  if (lid < histogramSize) {
    histogram[hook(1, lid)] = lhistogram[hook(2, lid)];
  }
}