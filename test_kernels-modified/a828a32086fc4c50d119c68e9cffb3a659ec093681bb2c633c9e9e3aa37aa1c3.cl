//{"dt":7,"force_s":4,"pos_s":1,"pos_u":0,"sort_indices":5,"sphp":6,"vel_s":3,"vel_u":2}
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

float magnitude(float4 vec) {
  return sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
}

kernel void euler(

    global float4* pos_u, global float4* pos_s, global float4* vel_u, global float4* vel_s, global float4* force_s, global int* sort_indices,

    constant struct SPHParams* sphp, float dt) {
  unsigned int i = get_global_id(0);
  int num = sphp->num;
  if (i >= num)
    return;

  float4 p = pos_s[hook(1, i)];
  float4 v = vel_s[hook(3, i)];
  float4 f = force_s[hook(4, i)];

  f.z += -9.8f;

  float speed = magnitude(f);
  if (speed > 600.0f) {
    f *= 600.0f / speed;
  }

  v += dt * f;

  p += dt * v;
  p.w = 1.0f;
  p.xyz /= sphp->simulation_scale;

  unsigned int originalIndex = sort_indices[hook(5, i)];

  vel_u[hook(2, originalIndex)] = v;

  pos_u[hook(0, originalIndex)] = (float4)(p.xyz, 1.);
}