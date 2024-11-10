//{"ctime":9,"hasSpkd":1,"itr":8,"logItrOffset":7,"logLayrOffset":6,"logSpk":4,"logSpkByte":10,"logSpkOut":5,"logSpkOutByte":11,"offsets":3,"spkd":0,"spksOut":2}
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
kernel void spikedLog2(global float* spkd, global uchar* hasSpkd, global float* spksOut, global int* offsets, global int* logSpk, global int* logSpkOut, global int* logLayrOffset, global int* logItrOffset, global int* itr, global float* ctime) {
  unsigned int x = get_global_id(0) + get_global_id(1) + get_global_id(2);

  if (x == 0) {
    if (*ctime < 100.0)
      printf("\n%.2f: %s", *ctime, __func__);
  }

  int layr = get_global_id(2);

  unsigned int nind = (get_global_size(0) * get_global_id(1) + get_global_id(0)) * 8;
  unsigned int absPos = offsets[hook(3, layr)] + nind;

  unsigned int bI = (nind / 32) + logLayrOffset[hook(6, layr)] + (*logItrOffset) * (*itr);
  global unsigned char* logSpkByte = &logSpk[hook(4, bI)];
  global unsigned char* logSpkOutByte = &logSpkOut[hook(5, bI)];
  int b = 0, c = 0;
  unsigned char zz = 0, zy = 0;
  unsigned int maxN;
  const unsigned int eight = 8;

  maxN = max(eight, offsets[hook(3, layr + 1)] - absPos);

  for (int i = 0; i < maxN && i >= 0; i++) {
    if (hasSpkd[hook(1, absPos + i)] > 0) {
      b = fabs(spkd[hook(0, absPos + i)] - *ctime) < (0.5F * 0.01F);
      zz |= b << i;
      c = fabs(spksOut[hook(2, absPos + i)] - *ctime) < (0.5F * 0.01F);
      zy |= b << i;
    }
  }
  logSpkByte[hook(10, (nind >> 3) & 3)] = zz;
  logSpkOutByte[hook(11, (nind >> 3) & 3)] = zy;
}