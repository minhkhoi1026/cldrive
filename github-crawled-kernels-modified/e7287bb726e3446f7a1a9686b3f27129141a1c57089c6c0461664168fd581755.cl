//{"bias":3,"dim_hidden":4,"dim_in":5,"in":1,"out":0,"weight":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm_base(global float* out, const global float* in, const global float* weight, const global float* bias, const int dim_hidden, const int dim_in) {
  const int GID = get_global_id(0);
  const int n = GID / dim_hidden;
  const int hidden = GID % dim_hidden;
  const int in_offset = n * dim_in;
  float z = bias != ((void*)0) ? bias[hook(3, hidden)] : 0;

  for (int i = 0; i < dim_in; i++)
    z += weight[hook(2, dim_hidden * i + hidden)] * in[hook(1, in_offset + i)];
  out[hook(0, GID)] = z;
}