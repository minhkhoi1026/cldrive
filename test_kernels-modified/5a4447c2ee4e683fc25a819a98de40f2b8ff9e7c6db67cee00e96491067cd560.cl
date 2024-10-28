//{"iteration":0,"lightSourcePosition":5,"photons":2,"resolution":3,"seed":1,"simulationBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int stepLCG(unsigned int* z, unsigned int A, unsigned int C) {
  return (*z) = (A * (*z) + C);
}

unsigned int stepCTG(unsigned int* z, unsigned int S1, unsigned int S2, unsigned int S3, unsigned int M) {
  unsigned int b = ((((*z) << S1) ^ (*z)) >> S2);
  return (*z) = ((((*z) & M) << S3) ^ b);
}

float getRandom(unsigned int* rng1, unsigned int* rng2, unsigned int* rng3, unsigned int* rng4) {
  return 2.3283064365387e-10 * (stepCTG(rng1, 13, 19, 12, 4294967294UL) ^ stepCTG(rng2, 2, 25, 4, 4294967288UL) ^ stepCTG(rng3, 3, 11, 17, 4294967280UL) ^ stepLCG(rng4, 1664525, 1013904223UL));
}

struct photon {
  float4 origin;
  float4 direction;
  float energy;
};

float4 getRandomDirection(unsigned int* rng1, unsigned int* rng2, unsigned int* rng3, unsigned int* rng4) {
  float x, y, z;
  bool inside = false;
  while (!inside) {
    x = getRandom(rng1, rng2, rng3, rng4) * 2.0f - 1.0f;
    y = getRandom(rng1, rng2, rng3, rng4) * 2.0f - 1.0f;
    z = getRandom(rng1, rng2, rng3, rng4) * 2.0f - 1.0f;
    if ((x * x + y * y + z * z) <= 1.0f) {
      inside = true;
    }
  }
  if (x * x + y * y + z * z == 0.0) {
    x = 0.0f;
    y = 1.0f;
    z = 0.0f;
  }
  float vlen = sqrt(x * x + y * y + z * z);
  return (float4)(x / vlen, y / vlen, z / vlen, 0);
}

constant float eps = 0.000001f;
constant float albedo = 0.8f;
constant float densityScale = 1.0f;

float getDensity(float4 p) {
  for (float ix = 0.3f; ix < 0.9f; ix += 0.4f) {
    for (float iy = 0.3f; iy < 0.9f; iy += 0.4f) {
      float px2 = (p.x - ix) * (p.x - ix);
      float py2 = (p.y - iy) * (p.y - iy);
      if (px2 + py2 < 0.001f) {
        return 100.0f;
      }
    }
  }

  for (float ix = 0.3f; ix < 0.9f; ix += 0.4f) {
    for (float iz = 0.3f; iz < 0.9f; iz += 0.4f) {
      float px2 = (p.x - ix) * (p.x - ix);
      float pz2 = (p.z - iz) * (p.z - iz);
      if (px2 + pz2 < 0.001f) {
        return 100.0f;
      }
    }
  }

  for (float iz = 0.3f; iz < 0.9f; iz += 0.4f) {
    for (float iy = 0.3f; iy < 0.9f; iy += 0.4f) {
      float pz2 = (p.z - iz) * (p.z - iz);
      float py2 = (p.y - iy) * (p.y - iy);
      if (pz2 + py2 < 0.001f) {
        return 100.0f;
      }
    }
  }

  if (p.y > 0.78f && p.y < 0.83f && ((p.x - 0.5f) * (p.x - 0.5f) + (p.z - 0.5f) * (p.z - 0.5f)) > 0.001f)
    return 100.0f;

  if (p.x < 0.02f)
    return 100.0f;
  if (p.y < 0.02f)
    return 100.0f;
  if (p.z > 0.98f)
    return 100.0f;

  if (p.y < 0.2f)
    return (1.0f - p.y) * 5.0f;

  return 0.5f * densityScale;
}

void tracePhotonRM(global struct photon* p, float rnd) {
  float s = -log(rnd) / densityScale;

  float t = 0.0f;
  float dt = 1.0f / 256.0f;
  float sum = 0.0f;
  float sigmat = 0.0f;

  while (sum < s) {
    float4 samplePos = p->origin + t * p->direction;
    if (samplePos.x < 0.0f || samplePos.x > 1.0f || samplePos.y < 0.0f || samplePos.y > 1.0f || samplePos.z < 0.0f || samplePos.z > 1.0f) {
      p->energy = 0.0f;
      break;
    } else {
      sigmat = getDensity(samplePos);
      sum += sigmat * dt;
      t += dt;
    }
  }

  p->origin = p->origin + p->direction * t;
  p->direction = p->direction;
  p->energy = p->energy * albedo;
}

void storePhoton(global struct photon* p, const int resolution, global float* simulationBuffer) {
  if (p->energy < 0.1f)
    return;

  int x = p->origin.x * resolution;
  int y = p->origin.y * resolution;
  int z = p->origin.z * resolution;

  if (x > resolution - 1 || x < 0)
    return;
  if (y > resolution - 1 || y < 0)
    return;
  if (z > resolution - 1 || z < 0)
    return;

  simulationBuffer[hook(4, x + y * resolution + z * resolution * resolution)] += p->energy;
}

kernel void simulation(const int iteration, global uint4* seed, global struct photon* photons, const int resolution, global float* simulationBuffer, const float4 lightSourcePosition) {
  int id = get_global_id(0);

  unsigned int rng1 = seed[hook(1, id)].s0;
  unsigned int rng2 = seed[hook(1, id)].s1;
  unsigned int rng3 = seed[hook(1, id)].s2;
  unsigned int rng4 = seed[hook(1, id)].s3;

  if (0 == iteration || photons[hook(2, id)].energy < 0.2f) {
    photons[hook(2, id)].origin = lightSourcePosition;
    photons[hook(2, id)].direction = getRandomDirection(&rng1, &rng2, &rng3, &rng4);
    photons[hook(2, id)].energy = 1.0f;
  } else {
    photons[hook(2, id)].direction = getRandomDirection(&rng1, &rng2, &rng3, &rng4);
  }

  tracePhotonRM(&photons[hook(2, id)], getRandom(&rng1, &rng2, &rng3, &rng4));
  storePhoton(&photons[hook(2, id)], resolution, simulationBuffer);

  seed[hook(1, id)].s0 = rng1;
  seed[hook(1, id)].s1 = rng2;
  seed[hook(1, id)].s2 = rng3;
  seed[hook(1, id)].s3 = rng4;
}