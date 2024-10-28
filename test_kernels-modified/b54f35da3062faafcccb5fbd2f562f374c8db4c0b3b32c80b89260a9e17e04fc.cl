//{"inner_dim":2,"key_data":5,"n":1,"out_data":0,"out_max_val":4,"top_k":3,"value_data":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void topk_radix_sort2(global float* restrict out_data, int n, int inner_dim, int top_k, int out_max_val, global const float* restrict key_data, global const int* restrict value_data) {
  const int tid = get_global_id(0);

  if (tid < inner_dim) {
    if (out_max_val) {
      out_data[hook(0, tid)] = value_data[hook(6, inner_dim - tid - 1)];
      out_data[hook(0, tid + top_k)] = key_data[hook(5, inner_dim - tid - 1)];
    } else {
      out_data[hook(0, tid)] = value_data[hook(6, inner_dim - tid - 1)];
    }
  }
}