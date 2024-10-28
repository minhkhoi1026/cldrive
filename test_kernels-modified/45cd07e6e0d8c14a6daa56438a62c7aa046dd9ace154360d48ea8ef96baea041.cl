//{"f3BoundingBox":5,"f4ForcePos":9,"fDeltaTime":4,"fForce":8,"fGravity":6,"iForceActive":7,"iFunction":2,"pos":0,"uiParticleCount":3,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void particle_kernel(global float4* pos, global float4* vel, const int iFunction, const unsigned int uiParticleCount, const float fDeltaTime, const float4 f3BoundingBox, const float fGravity, const int iForceActive, const float fForce, const float4 f4ForcePos) {
  unsigned int i = get_global_id(0);

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(1, i)];

  if (iFunction == 0) {
    float n = rootn((float)uiParticleCount, 3);
    float dx = f3BoundingBox.x / (n + 1.0f);
    float dy = f3BoundingBox.y / (n + 1.0f);
    float dz = f3BoundingBox.z / (n + 1.0f);

    float x = i % (int)n * dx + dx - (f3BoundingBox.x / 2);
    float y = ((int)(i / n)) % (int)n * dy + dy - (f3BoundingBox.y / 2);
    float z = ((int)(i / pown(n, 2))) % (int)n * dz + dz - (f3BoundingBox.z / 2);

    float vx = cos((float)(1234 * i));
    float vy = sin((float)(1234 * i));
    float vz = cos((float)(1234 * i));

    p.x = x;
    p.y = y;
    p.z = z;

    v.x = vx;
    v.y = vy;
    v.z = vz;
  } else if (iFunction == 1) {
    p.x += v.x * fDeltaTime;
    p.y += v.y * fDeltaTime;
    p.z += v.z * fDeltaTime;

    v.y -= fGravity * fDeltaTime;

    float bbx_half = f3BoundingBox.x / 2;
    float bby_half = f3BoundingBox.y / 2;
    float bbz_half = f3BoundingBox.z / 2;

    if (p.x < -bbx_half) {
      p.x = -2 * bbx_half - p.x;
      v.x *= -0.9f;
    } else if (p.x > bbx_half) {
      p.x = 2 * bbx_half - p.x;
      v.x *= -0.9f;
    }

    if (p.y < -bby_half) {
      p.y = -2 * bby_half - p.y;
      v.y *= -0.45;
      v.x *= 0.9;
    } else if (p.y > bby_half) {
      p.y = 2 * bby_half - p.y;
      v.y *= -0.9f;
    }

    if (p.z < -bbz_half) {
      p.z = -2 * bbz_half - p.z;
      v.z *= -0.9f;
    } else if (p.z > bbz_half) {
      p.z = 2 * bbz_half - p.z;
      v.z *= -0.9f;
    }

    if (iForceActive != 0) {
      float dx = f4ForcePos.x - p.x;
      float dy = f4ForcePos.y - p.y;
      float dz = f4ForcePos.z - p.z;

      float dist = sqrt((dx * dx + dy * dy + dz * dz));
      if (dist < 1)
        dist = 1;
      v.y += dy / dist * fForce / dist;
      v.x += dx / dist * fForce / dist;
      v.z += dz / dist * fForce / dist;
    }
  } else if (iFunction == 2) {
    float bbx_half = f3BoundingBox.x / 2;
    float bby_half = f3BoundingBox.y / 2;
    float bbz_half = f3BoundingBox.z / 2;

    if (p.x < -bbx_half) {
      v.x *= -0.95f;
      p.x = -bbx_half + v.x;
    } else if (p.x > bbx_half) {
      v.x *= -0.95f;
      p.x = bbx_half + v.x;
    }

    if (p.y < -bby_half) {
      v.y *= -0.45;
      v.x *= 0.95;
      p.y = -bby_half + v.y;
    } else if (p.y > bby_half) {
      v.y *= -0.95f;
      p.y = bby_half + v.y;
    }

    if (p.z < -bbz_half) {
      p.z = -2 * bbz_half - p.z;
      v.z *= -0.9f;
    } else if (p.z > bbz_half) {
      p.z = 2 * bbz_half - p.z;
      v.z *= -0.9f;
    }
  }

  pos[hook(0, i)] = p;
  vel[hook(1, i)] = v;
}