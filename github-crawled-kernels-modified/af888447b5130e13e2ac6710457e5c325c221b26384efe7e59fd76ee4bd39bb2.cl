//{"data":0,"data_size":1,"new_data":5,"num_classes":2,"num_data":3,"num_dim":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void permute_data_kernel(const global float* data, const int data_size, const int num_classes, const int num_data, const int num_dim, global float* new_data) {
  int index = get_global_id(0);

  if (index < data_size) {
    const int i = index % num_dim;
    const int c = (index / num_dim) % num_classes;
    const int d = (index / num_dim / num_classes) % num_data;
    const int n = index / num_dim / num_classes / num_data;
    const int new_index = ((n * num_classes + c) * num_data + d) * num_dim + i;
    new_data[hook(5, new_index)] = data[hook(0, index)];
  }
}