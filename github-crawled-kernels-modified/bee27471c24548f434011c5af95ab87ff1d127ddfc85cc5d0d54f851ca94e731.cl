//{"dimension":7,"dt":4,"gravity":5,"numberOfColliders":9,"numberOfParticles":8,"position":6,"positions":0,"positionsOut":1,"simData":10,"staticColliders":3,"velocity":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct SimulationData {
  float interactionRadius;
  float pressureMultiplier;
  float viscosity;
  float restPressure;
};

struct MinMaxData {
  float4 min, max;
};

inline float dim3(const float3* v, size_t i) {
  switch (i) {
    case 0:
      return v->x;
    case 1:
      return v->y;
    case 2:
      return v->z;
  }

  return __builtin_astype((2147483647), float);
}

inline float dim4(const float4* v, size_t i) {
  if (i == 3)
    return v->w;

  return dim3(v, i);
}

float3 calculatePressure(global float4* position, global float4* velocity, unsigned int index, float3 pos, float3 vel, unsigned int numberOfParticles, struct SimulationData simData);

bool ClipLine(int d, const struct MinMaxData aabbBox, const float3 v0, const float3 v1, float* f_low, float* f_high);
bool LineAABBIntersection(const struct MinMaxData aabbBox, const float3 v0, const float3 v1, float3* vecIntersection, float* flFraction);

kernel void particleUpdate(global float4* positions, global float4* positionsOut, global float4* velocity, global struct MinMaxData* staticColliders, const float dt, const float4 gravity, const float4 position, const float4 dimension, const unsigned int numberOfParticles, const unsigned int numberOfColliders, struct SimulationData simData) {
  unsigned int index = get_global_id(0);

  if (index >= numberOfParticles)
    return;

  float fluidDamp = 0.0;
  float particleSize = simData.interactionRadius * 0.1f;
  float3 worldAABBmin = particleSize;
  float3 worldAABBmax = dimension.xyz - particleSize;

  float3 particlePosition = positions[hook(0, index)].xyz;
  float3 particleVelocity = velocity[hook(2, index)].xyz;
  float3 particlePressure = calculatePressure(positions, velocity, index, particlePosition, particleVelocity, numberOfParticles, simData);

  particlePosition -= position.xyz;

  particleVelocity += (gravity.xyz + particlePressure.xyz) * dt;

  float3 deltaVelocity = particleVelocity * dt;
  float3 sizeOffset = normalize(particleVelocity) * particleSize;
  float3 newPos = particlePosition + deltaVelocity;

  int collisionCnt = 3;
  for (int i = 0; i < numberOfColliders && collisionCnt > 0; i++) {
    struct MinMaxData currentAABB = staticColliders[hook(3, i)];
    float3 intersection;
    float fraction;
    bool result = false;

    result = LineAABBIntersection(currentAABB, particlePosition, newPos + sizeOffset, &intersection, &fraction);

    if (result == false)
      continue;

    if (intersection.x == currentAABB.max.x || intersection.x == currentAABB.min.x)
      particleVelocity.x *= -fluidDamp;
    else if (intersection.y == currentAABB.max.y || intersection.y == currentAABB.min.y)
      particleVelocity.y *= -fluidDamp;
    else if (intersection.z == currentAABB.max.z || intersection.z == currentAABB.min.z)
      particleVelocity.z *= -fluidDamp;

    newPos = intersection;
    break;
  }

  if ((newPos.x > worldAABBmax.x && particleVelocity.x > 0.f) || (newPos.x < worldAABBmin.x && particleVelocity.x < 0.f)) {
    particleVelocity.x *= -fluidDamp;
  }

  if ((newPos.y > worldAABBmax.y && particleVelocity.y > 0.f) || (newPos.y < worldAABBmin.x && particleVelocity.y < 0.f)) {
    particleVelocity.y *= -fluidDamp;
  }

  if ((newPos.z > worldAABBmax.z && particleVelocity.z > 0.f) || (newPos.z < worldAABBmin.z && particleVelocity.z < 0.f)) {
    particleVelocity.z *= -fluidDamp;
  }

  particlePosition += particleVelocity * dt;

  positionsOut[hook(1, index)] = (float4)(particlePosition + position.xyz, length(particleVelocity));
  velocity[hook(2, index)] = (float4)(particleVelocity, numberOfParticles);
}