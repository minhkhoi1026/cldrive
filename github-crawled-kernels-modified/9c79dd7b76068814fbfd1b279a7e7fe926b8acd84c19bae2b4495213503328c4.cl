//{"dim":6,"idx_size":7,"index_data":3,"index_offset":4,"size_dim":9,"src_nDim":5,"stride":2,"tensor_data":0,"tensor_offset":1,"tensor_size":8,"val":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void THClTensor_kernel_indexFill(global float* tensor_data, int tensor_offset, global int* stride, global float* index_data, int index_offset, int src_nDim, int dim, int idx_size, int tensor_size, int size_dim, float val) {
  int thread_idx = get_group_id(0) * get_local_size(0) * get_local_size(1) + get_local_id(1) * get_local_size(0) + get_local_id(0);

  long flat_size = tensor_size / idx_size;

  if (thread_idx < flat_size) {
    long coeff = 0;
    for (int i = 0; i < idx_size; i++) {
      int leftover = thread_idx;
      int srcIdx = 0;
      for (int d = 0; d < src_nDim; d++) {
        if (d < dim) {
          coeff = leftover / (stride[hook(2, d)] / size_dim);
          leftover -= coeff * (stride[hook(2, d)] / size_dim);
          srcIdx += coeff * stride[hook(2, d)];
        } else if (d > dim) {
          coeff = leftover / stride[hook(2, d)];
          leftover -= coeff * stride[hook(2, d)];
          srcIdx += coeff * stride[hook(2, d)];
        }
      }
      tensor_data[hook(0, tensor_offset + srcIdx + (int)((index_data[ihook(3, index_offset + i)) - 1) * stride[dhook(2, dim))] = val;
    }
  }
}