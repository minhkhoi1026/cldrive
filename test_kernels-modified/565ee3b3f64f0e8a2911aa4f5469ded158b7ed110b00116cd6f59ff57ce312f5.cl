//{"G":8,"M":10,"N":9,"cached_stars":5,"m":2,"n_end":1,"n_start":0,"softening":6,"timestep":7,"v_end":4,"v_start":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 pair_force(float4 pi, float4 pj, float4 ai, const float softening) {
  float4 r;
  r.x = pj.x - pi.x;
  r.y = pj.y - pi.y;
  r.z = pj.z - pi.z;
  r.w = copysign(1, pi.w);

  float distSquare = r.x * r.x + r.y * r.y + r.z * r.z + softening;
  float invDist = native_rsqrt(distSquare);
  float invDistCube = invDist * invDist * invDist;
  float s = pj.w * invDistCube * r.w;
  ai.x += r.x * s;
  ai.y += r.y * s;
  ai.z += r.z * s;
  return ai;
}

kernel void nbody(global float4* n_start, global float4* n_end, global float4* m, global float4* v_start, global float4* v_end, local float4* cached_stars, const float softening, const float timestep, const float G, const int N, const int M) {
  int globalid = get_global_id(0);
  int threadcount = get_global_size(0);
  int chunksize = get_local_size(0);
  int localid = get_local_id(0);

  float4 pos = n_start[hook(0, globalid)];
  float4 vel = v_start[hook(3, globalid)];
  float4 force = {0, 0, 0, 0};

  int chunk = 0;
  for (int i = 0; i < M; i += chunksize, chunk++) {
    int local_pos = chunk * chunksize + localid;
    cached_stars[hook(5, localid)] = m[hook(2, local_pos)];

    barrier(0x01);
    for (int j = 0; j < chunksize;) {
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

  n_end[hook(1, globalid)] = pos;
  v_end[hook(4, globalid)] = vel;
}