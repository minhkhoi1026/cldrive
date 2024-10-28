//{"dim":8,"idx_size":9,"index_data":5,"index_offset":6,"size_dim":11,"src_data":2,"src_nDim":7,"src_offset":3,"src_stride":4,"tensor_data":0,"tensor_offset":1,"tensor_size":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void THClTensor_kernel_indexSelect(global float* tensor_data, int tensor_offset, global float* src_data, int src_offset, global int* src_stride, global float* index_data, int index_offset, int src_nDim, int dim, int idx_size, int tensor_size, int size_dim) {
  int thread_idx = get_group_id(0) * get_local_size(0) * get_local_size(1) + get_local_id(1) * get_local_size(0) + get_local_id(0);

  long flat_size = tensor_size / idx_size;

  if (thread_idx < flat_size) {
    long coeff = 0;
    for (int i = 0; i < idx_size; i++) {
      int leftover = thread_idx;
      int targetIdx = 0;
      int srcIdx = 0;
      for (int d = 0; d < src_nDim; d++) {
        if (d < dim) {
          long stride_d = src_stride[hook(4, d)] / size_dim;
          coeff = leftover / stride_d;
          leftover -= coeff * stride_d;
          targetIdx += coeff * stride_d * idx_size;
          srcIdx += coeff * src_stride[hook(4, d)];
        } else if (d > dim) {
          coeff = leftover / src_stride[hook(4, d)];
          leftover -= coeff * src_stride[hook(4, d)];
          targetIdx += coeff * src_stride[hook(4, d)];
          srcIdx += coeff * src_stride[hook(4, d)];
        }
      }
      tensor_data[hook(0, tensor_offset + targetIdx + i * src_stride[dhook(4, dim))] = src_data[hook(2, src_offset + srcIdx + ((int)(index_data[ihook(5, index_offset + i)) - 1) * src_stride[dhook(4, dim))];
    }
  }
}