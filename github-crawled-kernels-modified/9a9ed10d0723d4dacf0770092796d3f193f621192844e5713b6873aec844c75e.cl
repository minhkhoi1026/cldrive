//{"normal_s":4,"normal_u":3,"num":0,"pos_s":2,"pos_u":1,"sort_indices":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void cloud_permute(int num, global float4* pos_u, global float4* pos_s, global float4* normal_u, global float4* normal_s, global unsigned int* sort_indices) {
  unsigned int index = get_global_id(0);

  if (index >= num)
    return;
  unsigned int sorted_index = sort_indices[hook(5, index)];

  pos_s[hook(2, index)] = pos_u[hook(1, sorted_index)];
  normal_s[hook(4, index)] = normal_u[hook(3, sorted_index)];
}