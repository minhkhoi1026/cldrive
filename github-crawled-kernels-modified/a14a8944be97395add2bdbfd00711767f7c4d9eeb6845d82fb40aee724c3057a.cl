//{"clf":10,"cli":11,"float3":1,"min":6,"newNum":9,"num":3,"pos":0,"posTex":4,"res":8,"scale":5,"velocity":2,"world":7}
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

const sampler_t samp = 2 | 0x10;

kernel void meshToParticles(global float4* pos, global float4* float3, global float4* velocity, int num, read_only image3d_t posTex, float scale, float4 min, float16 world, int res, global int* newNum, global float4* clf, global int4* cli) {
  unsigned int s = get_global_id(0);
  unsigned int t = get_global_id(1);
  unsigned int r = get_global_id(2);

  uint4 vox = read_imageui(posTex, samp, (int4)(s, t, r, 0));

  if (vox.x > 0) {
    int loc = atom_inc(newNum);
    pos[hook(0, num + loc)] = (float4)((s / (float)res) * scale + min.x, (t / (float)res) * scale + min.y, (r / (float)res) * scale + min.z, 1.0);
    pos[hook(0, num + loc)].x = dot(world.s0123, pos[hook(0, num + loc)]);
    pos[hook(0, num + loc)].y = dot(world.s4567, pos[hook(0, num + loc)]);
    pos[hook(0, num + loc)].z = dot(world.s89AB, pos[hook(0, num + loc)]);
    float3[hook(1, num + loc)] = (float4)(1.0, 0.0, 0.0, 1.0);
    velocity[hook(2, num + loc)] = (float4)(0.0, 0.0, 0.0, 0.0);
    clf[hook(10, num + loc)] = pos[hook(0, num + loc)];
  }
}