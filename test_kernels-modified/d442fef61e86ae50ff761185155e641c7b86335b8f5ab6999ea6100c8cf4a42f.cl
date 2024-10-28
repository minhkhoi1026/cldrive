//{"color_s":8,"color_u":7,"num":0,"pos_s":2,"pos_u":1,"sort_indices":9,"vel_s":4,"vel_u":3,"veleval_s":6,"veleval_u":5}
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

kernel void permute(int num, global float4* pos_u, global float4* pos_s, global float4* vel_u, global float4* vel_s, global float4* veleval_u, global float4* veleval_s, global float4* color_u, global float4* color_s, global unsigned int* sort_indices) {
  unsigned int index = get_global_id(0);

  if (index >= num)
    return;

  unsigned int sorted_index = sort_indices[hook(9, index)];
  pos_s[hook(2, index)] = pos_u[hook(1, sorted_index)];
  vel_s[hook(4, index)] = vel_u[hook(3, sorted_index)];
  veleval_s[hook(6, index)] = veleval_u[hook(5, sorted_index)];
  color_s[hook(8, index)] = color_u[hook(7, sorted_index)];
}