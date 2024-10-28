//{"dim":8,"idx_size":9,"index_data":5,"index_offset":6,"res_data":0,"res_nDim":7,"res_offset":1,"res_stride":4,"size_dim":11,"src_data":2,"src_offset":3,"src_size":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void THClTensor_kernel_indexCopy(global float* res_data, int res_offset, global float* src_data, int src_offset, global int* res_stride, global float* index_data, int index_offset, int res_nDim, int dim, int idx_size, int src_size, int size_dim) {
  int thread_idx = get_group_id(0) * get_local_size(0) * get_local_size(1) + get_local_id(1) * get_local_size(0) + get_local_id(0);

  long flat_size = src_size / idx_size;

  if (thread_idx < flat_size) {
    long coeff = 0;
    for (int i = 0; i < idx_size; i++) {
      int leftover = thread_idx;
      int targetIdx = 0;
      int resIdx = 0;
      for (int d = 0; d < res_nDim; d++) {
        if (d < dim) {
          long stride_d = res_stride[hook(4, d)] / size_dim;
          coeff = leftover / stride_d;
          leftover -= coeff * stride_d;
          targetIdx += coeff * stride_d * idx_size;
          resIdx += coeff * res_stride[hook(4, d)];
        } else if (d > dim) {
          coeff = leftover / res_stride[hook(4, d)];
          leftover -= coeff * res_stride[hook(4, d)];
          targetIdx += coeff * res_stride[hook(4, d)];
          resIdx += coeff * res_stride[hook(4, d)];
        }
      }
      res_data[hook(0, res_offset + resIdx + ((int)(index_data[ihook(5, index_offset + i)) - 1) * res_stride[dhook(4, dim))] = src_data[hook(2, src_offset + targetIdx + i * res_stride[dhook(4, dim))];
    }
  }
}