//{"G":8,"M":10,"N":9,"cached_stars":5,"m":2,"n_end":1,"n_start":0,"softening":6,"threads_per_star":11,"timestep":7,"v_end":4,"v_start":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 pair_force(float4 pi, float4 pj, const float softening) {
  float4 r;
  r.x = pj.x - pi.x;
  r.y = pj.y - pi.y;
  r.z = pj.z - pi.z;
  r.w = copysign(1, pi.w);

  float distSquare = r.x * r.x + r.y * r.y + r.z * r.z + softening;
  float invDist = native_rsqrt(distSquare);
  float invDistCube = invDist * invDist * invDist;
  float s = pj.w * invDistCube * r.w;
  return (float4){r.x * s, r.y * s, r.z * s, 0};
}

kernel void nbody(global float4* n_start, global float4* n_end, global float4* m, global float4* v_start, global float4* v_end, local float4* cached_stars, const float softening, const float timestep, const float G, const int N, const int M, const int threads_per_star) {
  int globalid = get_global_id(0);
  int chunksize = get_local_size(0);
  int localid = get_local_id(0);
  if (localid % threads_per_star == 0) {
    cached_stars[hook(5, localid)] = n_start[hook(0, globalid / threads_per_star)];
    cached_stars[hook(5, localid + 1)] = v_start[hook(3, globalid / threads_per_star)];
  }
  barrier(0x01);
  int offset = localid - localid % threads_per_star;
  float4 pos = cached_stars[hook(5, offset)];
  float4 vel = cached_stars[hook(5, offset + 1)];
  float4 force = {0, 0, 0, 0};
  int chunk = 0;
  barrier(0x01);
  for (int i = 0; i < M; i += chunksize, chunk++) {
    cached_stars[hook(5, localid)] = m[hook(2, chunk * chunksize + localid)];
    barrier(0x01);
    for (int j = 0; j < chunksize / threads_per_star;) {
      force += pair_force(pos, cached_stars[hook(5, offset + j++)], softening);
      force += pair_force(pos, cached_stars[hook(5, offset + j++)], softening);
      force += pair_force(pos, cached_stars[hook(5, offset + j++)], softening);
      force += pair_force(pos, cached_stars[hook(5, offset + j++)], softening);
    }
    barrier(0x01);
  }
  cached_stars[hook(5, localid)] = force;
  barrier(0x01);
  if (localid % threads_per_star == 0) {
    for (int i = 1; i < threads_per_star; i++)
      force += cached_stars[hook(5, localid + i)];

    vel.x += force.x * G * timestep;
    vel.y += force.y * G * timestep;
    vel.z += force.z * G * timestep;

    float velsqr = vel.x * vel.x + vel.y * vel.y + vel.z * vel.z;
    if (velsqr > 90000000000000000) {
      velsqr = sqrt(velsqr);
      vel.x = vel.x / velsqr;
      vel.y = vel.y / velsqr;
      vel.z = vel.z / velsqr;
    }

    pos.x += vel.x * timestep;
    pos.y += vel.y * timestep;
    pos.z += vel.z * timestep;

    n_end[hook(1, globalid / threads_per_star)] = pos;
    v_end[hook(4, globalid / threads_per_star)] = vel;
  }
}