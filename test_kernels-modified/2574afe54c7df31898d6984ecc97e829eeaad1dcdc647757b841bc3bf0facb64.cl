//{"particleData":0,"passedTime":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float dotVec(float px, float py, float pz, float px_, float py_, float pz_) {
  return px * px_ + py * py_ + pz * pz_;
}

inline float lengthVec(float x, float y, float z) {
  return sqrt(dotVec(x, y, z, x, y, z)) + 0.0000001;
}

kernel void collisionKernel(global float* particleData, int size, float passedTime) {
  int j = get_global_id(0);
  bool colliding = false;

  float px = particleData[hook(0, j * 8 + 0)];
  float py = particleData[hook(0, j * 8 + 1)];
  float pz = particleData[hook(0, j * 8 + 2)];
  float vx = particleData[hook(0, j * 8 + 3)];
  float vy = particleData[hook(0, j * 8 + 4)];
  float vz = particleData[hook(0, j * 8 + 5)];
  float radius = particleData[hook(0, j * 8 + 6)];
  float mass = particleData[hook(0, j * 8 + 7)];

  barrier(0x01);
  for (int k = j + 1; k < size; k++) {
    float px_ = particleData[hook(0, k * 8 + 0)];
    float py_ = particleData[hook(0, k * 8 + 1)];
    float pz_ = particleData[hook(0, k * 8 + 2)];
    float vx_ = particleData[hook(0, k * 8 + 3)];
    float vy_ = particleData[hook(0, k * 8 + 4)];
    float vz_ = particleData[hook(0, k * 8 + 5)];
    float radius_ = particleData[hook(0, k * 8 + 6)];
    float mass_ = particleData[hook(0, k * 8 + 7)];

    float dpx = px_ - px;
    float dpy = py_ - py;
    float dpz = pz_ - pz;

    float dpLenSqSubR = dotVec(dpx, dpy, dpz, dpx, dpy, dpz);

    float sumR = (radius + radius_);
    dpLenSqSubR -= sumR * sumR;

    float dvx = vx - vx_;
    float dvy = vy - vy_;
    float dvz = vz - vz_;

    dvx *= passedTime;
    dvy *= passedTime;
    dvz *= passedTime;

    float dvLenSq = dotVec(dvx, dvy, dvz, dvx, dvy, dvz);

    if (dvLenSq < dpLenSqSubR) {
      colliding = false;
      break;
    }

    float dvLen = lengthVec(dvx, dvy, dvz);
    float dvxScl = dvx / dvLen;
    float dvyScl = dvy / dvLen;
    float dvzScl = dvz / dvLen;

    float d = dotVec(dvxScl, dvyScl, dvzScl, dpx, dpy, dpz);

    if (d <= 0) {
      colliding = false;
      break;
    }

    float dpLenSq = dotVec(dpx, dpy, dpz, dpx, dpy, dpz);

    float f = dpLenSq - (d * d);

    float sumRSq = sumR * sumR;

    if (f >= sumRSq) {
      colliding = false;
      break;
    }

    float t = sumRSq - f;

    float distance = d - sqrt(t);

    float magnitude = lengthVec(dvx, dvy, dvz);

    if (magnitude < distance) {
      colliding = false;
      break;
    }

    float vLen = lengthVec(vx, vy, vz);
    float vxNorm = vx / vLen;
    float vyNorm = vy / vLen;
    float vzNorm = vz / vLen;
    particleData[hook(0, j * 8 + 0)] = (px + (vxNorm * distance * passedTime));
    particleData[hook(0, j * 8 + 1)] = (py + (vyNorm * distance * passedTime));
    particleData[hook(0, j * 8 + 2)] = (pz + (vzNorm * distance * passedTime));

    float v_Len = lengthVec(vx_, vy_, vz_);
    float vx_Norm = vx_ / v_Len;
    float vy_Norm = vy_ / v_Len;
    float vz_Norm = vz_ / v_Len;
    particleData[hook(0, k * 8 + 0)] = (px_ + (vx_Norm * distance * passedTime));
    particleData[hook(0, k * 8 + 1)] = (py_ + (vy_Norm * distance * passedTime));
    particleData[hook(0, k * 8 + 2)] = (pz_ + (vz_Norm * distance * passedTime));

    float dpLen = lengthVec(dpx, dpy, dpz);
    float nx = dpx / dpLen;
    float ny = dpy / dpLen;
    float nz = dpz / dpLen;

    float a1 = dotVec(vx, vy, vz, nx, ny, nz);
    float a2 = dotVec(vx_, vy_, vz_, nx, ny, nz);

    float p = (2 * (a1 - a2)) / (mass + mass_);

    float avx = vx - (nx * mass_ * p);
    float avy = vy - (ny * mass_ * p);
    float avz = vz - (nz * mass_ * p);

    float bvx = vx_ + (nx * mass * p);
    float bvy = vy_ + (ny * mass * p);
    float bvz = vz_ + (nz * mass * p);

    particleData[hook(0, j * 8 + 3)] = avx;
    particleData[hook(0, j * 8 + 4)] = avy;
    particleData[hook(0, j * 8 + 5)] = avz;

    particleData[hook(0, k * 8 + 3)] = bvx;
    particleData[hook(0, k * 8 + 4)] = bvy;
    particleData[hook(0, k * 8 + 5)] = bvz;
  }

  particleData[hook(0, j * 8 + 0)] = px + vx * passedTime;
  particleData[hook(0, j * 8 + 1)] = py + vy * passedTime;
  particleData[hook(0, j * 8 + 2)] = pz + vz * passedTime;
}