//{"in_data":0,"in_size":2,"kernel_size":3,"out_data":1,"out_size":5,"pool_type":6,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pool(global float* restrict in_data, global float* restrict out_data, const int in_size, const int kernel_size, const int stride, const int out_size, const int pool_type) {
  int filter_index = get_global_id(0);

  for (int row = 0; row < out_size; row++) {
    for (int col = 0; col < out_size; col++) {
      float tmp1 = 0.0;
      float tmp2 = -10000.0;

      for (int i = 0; i < (kernel_size * kernel_size); i++) {
        int k_row = i / kernel_size;
        int k_col = i - (k_row * kernel_size);

        float data = in_data[hook(0, filter_index * in_size * in_size + (row * stride + k_row) * in_size + (col * stride + k_col))];

        if (pool_type == 1)
          tmp1 += data / (kernel_size * kernel_size);
        else {
          if (tmp2 < data)
            tmp2 = data;
        }
      }
      out_data[hook(1, filter_index * out_size * out_size + row * out_size + col)] = pool_type ? tmp1 : tmp2;
    }
  }
}