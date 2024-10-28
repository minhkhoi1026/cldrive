//{"ctime":8,"cur":2,"delaysBase":12,"hasSpkd":5,"inscur":3,"offsets":7,"pot":0,"rec":1,"spInIndex":10,"spOutIndex":11,"spRegister":9,"spkd":4,"spksOut":6}
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
kernel void iterate_RS(global float* pot, global float* rec, global float* cur, global float* inscur, global float* spkd, global uchar* hasSpkd, global float* spksOut, global int* offsets, global float* ctime, global float* spRegister, global int* spInIndex, global int* spOutIndex, global float* delaysBase) {
  unsigned int x = get_global_id(0) + get_global_id(1) + get_global_id(2);

  if (x == 0) {
    if (*ctime < 100.0)
      printf("\n%.2f: %s", *ctime, __func__);
  }

  int layr = get_global_id(2);
  int nind = get_global_size(0) * get_global_id(1) + get_global_id(0);
  int absPos = offsets[hook(7, layr)] + nind;
  float p, r, c;
  p = pot[hook(0, absPos)];
  r = rec[hook(1, absPos)];
  float ii = inscur[hook(3, absPos)], tk;
  c = cur[hook(2, absPos)];
  if (absPos < offsets[hook(7, layr + 1)]) {
    inscur[hook(3, absPos)] = 0;

    float2 uv = x_RK_RS(p, r, c + ii, 0.01F);
    if (p >= 30) {
      spksOut[hook(6, absPos)] = *ctime;

      spkd[hook(4, absPos)] = *ctime;
      hasSpkd[hook(5, absPos)] = 1;
      p = -65.0F;
      r = r + 8.0F;
    } else {
      if (uv.x >= -82.F) {
        p = uv.x;
        r = uv.y;
      }
    }
    pot[hook(0, absPos)] = p;
    rec[hook(1, absPos)] = r;
  }
}