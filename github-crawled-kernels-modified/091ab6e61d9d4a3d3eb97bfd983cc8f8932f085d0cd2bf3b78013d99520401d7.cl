//{"mean":1,"means":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtract_mean(global float* means, global const float* mean) {
  const unsigned int dim_id = get_global_id(0);
  const unsigned int dim_size = get_global_size(0);
  const unsigned int n_id = get_global_id(1);

  means[hook(0, dim_size * n_id + dim_id)] -= mean[hook(1, dim_id)];
}