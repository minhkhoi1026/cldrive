//{"in_deltaT":3,"in_points":0,"in_range":2,"in_velocities":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 Acceleration(float3 in_pos) {
  float dSquared = (in_pos.x * in_pos.x) + (in_pos.y * in_pos.y) + (in_pos.z * in_pos.z);
  if (dSquared < 1.0f)
    return (float3)(0, 0, 0);

  float a = 1750.0f / dSquared;

  float3 accelVector = -normalize(in_pos);
  accelVector *= a;
  return accelVector;
}

float3 Velocity(float3 in_velocity, float3 in_accelVector, float in_deltaT) {
  float3 dV = in_accelVector * in_deltaT;
  float3 velocity = in_velocity + dV;

  if (length(velocity) > 500.0f) {
    velocity = normalize(velocity);
    velocity *= 500.0f;
  }

  return velocity;
}

kernel void Simulate(global float4* in_points, global float4* in_velocities, float in_range, float in_deltaT) {
  unsigned int gid = get_global_id(0);

  float3 velocity = in_velocities[hook(1, gid)].xyz;
  float3 position = in_points[hook(0, gid)].xyz;

  if (length(position) > in_range) {
    float3 fromCenter = normalize(position);

    float vFromCenter = dot(fromCenter, velocity);

    unsigned int nid = gid + 1;
    if (get_global_size(0) <= nid) {
      nid = gid - 1;
    }
    float3 int2 = in_points[hook(0, nid)].xyz;
    float3 dir = cross(fromCenter, normalize(int2));
    velocity = normalize(dir) * length(velocity);
    velocity *= 0.995f;

    if (vFromCenter < 0) {
      velocity += vFromCenter * fromCenter;
    }
  }

  float3 accelVector = Acceleration(position);

  velocity = Velocity(velocity, accelVector, in_deltaT);

  float3 deltaPos = (velocity * in_deltaT) + (0.5f * accelVector * in_deltaT * in_deltaT);
  position = position + deltaPos;

  in_velocities[hook(1, gid)] = (float4)(velocity, 0);

  float normalizedSpeed = length(velocity) / 500.0f;
  in_points[hook(0, gid)] = (float4)(position, normalizedSpeed);
}