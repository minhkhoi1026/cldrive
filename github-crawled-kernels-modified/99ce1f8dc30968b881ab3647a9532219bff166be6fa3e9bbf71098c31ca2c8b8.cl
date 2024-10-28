//{"ctime":9,"hasSpkd":1,"itr":8,"logItrOffset":7,"logLayrOffset":6,"logSpk":4,"logSpkOut":5,"offsets":3,"spkd":0,"spksOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float vdash(float v, float rec, float cur) {
  return 0.04F * v * v + 5 * v + 140 - rec + cur;
}

inline float udash_RS(float v, float rec) {
  return 0.02F * (0.2F * v - rec);
}

inline float udash_IB(float v, float rec) {
  return 0.02F * (0.2F * v - rec);
}

inline float2 x_RK_RS(float x, float u, float cur, float dt) {
  float k1 = vdash(x, u, cur);
  float k1_rec = udash_RS(x, u);
  float k2 = vdash(x + 0.5F * dt * k1, u + 0.5F * dt * k1_rec, cur);
  float k2_rec = udash_RS(x + 0.5F * dt * k1, u + 0.5F * dt * k1_rec);
  float k3 = vdash(x + 0.5F * dt * k2, u + 0.5F * dt * k2_rec, cur);
  float k3_rec = udash_RS(x + 0.5F * dt * k2, u + 0.5F * dt * k2_rec);
  float k4 = vdash(x + dt * k3, u + dt * k3_rec, cur);
  float k4_rec = udash_RS(x + dt * k3, u + dt * k3_rec);
  float2 xx;
  xx.x = x + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
  xx.y = u + dt * (k1_rec + 2 * k2_rec + 2 * k3_rec + k4_rec) / 6;
  return xx;
}
kernel void spikedLog3(global float* spkd, global uchar* hasSpkd, global float* spksOut, global int* offsets, global int* logSpk, global int* logSpkOut, global int* logLayrOffset, global int* logItrOffset, global int* itr, global float* ctime) {
  size_t x = get_global_id(0) + get_global_id(1) + get_global_id(2);

  if (x == 0) {
    if (*ctime < 100.0)
      printf("\n%.2f: %s", *ctime, __func__);
  }

  int layr = get_global_id(2);

  size_t nNum = get_global_size(0) * get_global_id(1) + get_global_id(0);
  unsigned int absPos = offsets[hook(3, layr)] + nNum;

  local unsigned int spikedInt, spkoutInt;
  spikedInt = 0;
  spkoutInt = 0;

  bool isSpkd = 0, isSpkOut = 0;

  if (absPos < offsets[hook(3, layr + 1)]) {
    if (hasSpkd[hook(1, absPos)] > 0) {
      isSpkd = fabs(spkd[hook(0, absPos)] - *ctime) < (0.5F * 0.01F);
      isSpkOut = fabs(spksOut[hook(2, absPos)] - *ctime) < (0.5F * 0.01F);
    }
  }

  barrier(0x02);

  unsigned int sd = (isSpkd) << (31 - (nNum % 32));
  unsigned int so = (isSpkOut) << (31 - (nNum % 32));

  atomic_or(&spikedInt, sd);
  atomic_or(&spkoutInt, so);

  unsigned int globalIndex = logLayrOffset[hook(6, layr)] + (*logItrOffset) * (*itr);

  barrier(0x01);

  if ((nNum % 32) == 0) {
    if (absPos < offsets[hook(3, layr + 1)]) {
      logSpk[hook(4, globalIndex + (nNum >> 5))] = spikedInt;
      logSpkOut[hook(5, globalIndex + (nNum >> 5))] = spkoutInt;
    }
  }
}