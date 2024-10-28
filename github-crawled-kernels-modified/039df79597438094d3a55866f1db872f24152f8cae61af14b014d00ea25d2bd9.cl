//{"bank":0,"filter_width":2,"num_filters":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter_normalize(global float* bank, unsigned int num_filters, unsigned int filter_width) {
  const unsigned int filter = get_global_id(0);
  const unsigned int filter_len = filter_width * filter_width;

  if (filter < num_filters) {
    float sum = 0;
    for (unsigned int i = 0; i < filter_len; ++i) {
      sum += bank[hook(0, filter_len * filter + i)];
    }

    for (unsigned int i = 0; i < filter_len; ++i) {
      bank[hook(0, filter_len * filter + i)] = bank[hook(0, filter_len * filter + i)] / sum;
    }
  }
}