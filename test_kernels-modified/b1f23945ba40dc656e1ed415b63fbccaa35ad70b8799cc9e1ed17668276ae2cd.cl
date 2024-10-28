//{"G":8,"N":9,"a":4,"cached_stars":5,"p_end":1,"p_start":0,"softening":6,"timestep":7,"v_end":3,"v_start":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 pair_force(float4 pi, float4 pj, float4 ai, const unsigned int softening) {
  float3 r;
  r.x = pj.x - pi.x;
  r.y = pj.y - pi.y;
  r.z = pj.z - pi.z;

  float distSquare = r.x * r.x + r.y * r.y + r.z * r.z + softening;
  float invDist = rsqrt(distSquare);
  float invDistCube = invDist * invDist * invDist;
  float s = pj.w * invDistCube;
  ai.x += r.x * s;
  ai.y += r.y * s;
  ai.z += r.z * s;
  return ai;
}

kernel void nbody(global float4* p_start, global float4* p_end, global float4* v_start, global float4* v_end, global float4* a, local float4* cached_stars, const unsigned int softening, const unsigned int timestep, const float G, const unsigned int N) {
  unsigned int globalid = get_global_id(0);
  unsigned int chunksize = get_local_size(0);
  unsigned int localid = get_local_id(0);
  unsigned int threadcount = get_global_size(0);

  for (; globalid < N; globalid += threadcount) {
    float4 pos = p_start[hook(0, globalid)];
    float4 vel = v_start[hook(2, globalid)];

    float4 force = {0, 0, 0, 0};

    int chunk = 0;
    for (int i = 0; i < N; i += chunksize, chunk++) {
      int local_pos = chunk * chunksize + localid;
      cached_stars[hook(5, localid)] = p_start[hook(0, local_pos)];

      barrier(0x01);
      for (int j = 0; j < chunksize;) {
        force = pair_force(pos, cached_stars[hook(5, j++)], force, softening);
        force = pair_force(pos, cached_stars[hook(5, j++)], force, softening);
        force = pair_force(pos, cached_stars[hook(5, j++)], force, softening);
        force = pair_force(pos, cached_stars[hook(5, j++)], force, softening);
      }
      barrier(0x01);
    }

    vel.x += force.x * G * timestep;
    vel.y += force.y * G * timestep;
    vel.z += force.z * G * timestep;

    pos.x += vel.x * timestep;
    pos.y += vel.y * timestep;
    pos.z += vel.z * timestep;

    p_end[hook(1, globalid)] = pos;
    v_end[hook(3, globalid)] = vel;
  }
}