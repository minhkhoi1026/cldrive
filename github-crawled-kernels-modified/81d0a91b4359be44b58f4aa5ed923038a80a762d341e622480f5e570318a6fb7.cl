//{"dt":4,"float3":1,"masses":2,"pos":0,"vel":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float GRAVITY = 0.000000000066742;
kernel void vortex(global float4* pos, global float4* float3, global float* masses, global float4* vel, float dt) {
  unsigned int i = get_global_id(0);
  unsigned int particle_count = get_global_size(0);

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(3, i)];
  float mass = masses[hook(2, i)];

  float4 accelerationDirection = (float4)(0, 0, 0, 0);

  if (mass == 0)
    return;

  for (int j = 0; j < particle_count; j++) {
    if (masses[hook(2, j)] == 0 || j == i)
      continue;

    float4 distance = pos[hook(0, j)] - p;
    float qdistance = dot(distance, distance);

    if (qdistance <= 0)
      continue;

    if (qdistance > 0.01) {
      float acceleration = GRAVITY * masses[hook(2, j)] / qdistance;
      accelerationDirection += normalize(distance) * acceleration;
    }

    if (

        qdistance < 0.0001 && masses[hook(2, i)] < masses[hook(2, j)]) {
      masses[hook(2, j)] += masses[hook(2, i)];

      vel[hook(3, j)] += vel[hook(3, i)] * masses[hook(2, i)] / masses[hook(2, j)];

      masses[hook(2, i)] = 0;
      return;
    }
  }

  v += accelerationDirection * dt;
  v.w = 1;

  p += v * dt;
  p.w = 1;

  pos[hook(0, i)] = p;
  vel[hook(3, i)] = v;
}