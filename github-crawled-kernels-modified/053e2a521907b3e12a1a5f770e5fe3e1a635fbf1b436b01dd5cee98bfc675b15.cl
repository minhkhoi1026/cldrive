//{"num":0,"omega":4,"pos_cg":3,"pos_s":1,"vel_s":2}
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

kernel void kern_cloud_velocity(int num, global float4* pos_s, global float4* vel_s, float4 pos_cg, float4 omega) {
  unsigned int i = get_global_id(0);
  if (i >= num)
    return;

  float4 simulation_scale = 0.05;

  float4 p = simulation_scale * (pos_s[hook(1, i)] - pos_cg);
  vel_s[hook(2, i)] = (float4)(p.y * omega.z - p.z * omega.y, p.z * omega.x - p.x * omega.z, p.x * omega.y - p.y * omega.x, 1.);
}