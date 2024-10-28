//{"dt":9,"normal_s":4,"normal_u":3,"num":0,"pos_s":2,"pos_u":1,"sort_indices":7,"sphp":8,"velocity_s":6,"velocity_u":5}
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
kernel void cloudEuler(int num, global float4* pos_u, global float4* pos_s, global float4* normal_u, global float4* normal_s, global float4* velocity_u, global float4* velocity_s,

                       global int* sort_indices, constant struct SPHParams* sphp, float dt) {
  unsigned int i = get_global_id(0);

  if (i >= num)
    return;

  float4 p = pos_s[hook(2, i)];
  float4 vel = velocity_s[hook(6, i)];

  p += dt * vel;

  p.w = 1.0f;

  unsigned int originalIndex = sort_indices[hook(7, i)];

  pos_u[hook(1, originalIndex)] = (float4)(p.xyz, 1.);
  normal_u[hook(3, originalIndex)] = normal_s[hook(4, i)];
  velocity_u[hook(5, originalIndex)] = velocity_s[hook(6, i)];
  return;
}