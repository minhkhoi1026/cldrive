//{"bottom_data":1,"newStride":4,"nthreads":0,"num_axes":5,"oldStride":3,"permute_order":2,"top_data":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void permute(const int nthreads, global float* bottom_data, global int* permute_order, global int* oldStride, global int* newStride, const int num_axes, global float* top_data) {
  for (int i = get_global_id(0); i < nthreads; i += get_global_size(0)) {
    int oldPosition = 0;
    int newPosition = i;

    for (int j = 0; j < num_axes; ++j) {
      int order = permute_order[hook(2, j)];
      oldPosition += (newPosition / newStride[hook(4, j)]) * oldStride[hook(3, order)];
      newPosition %= newStride[hook(4, j)];
    }

    top_data[hook(6, i)] = bottom_data[hook(1, oldPosition)];
  }
}