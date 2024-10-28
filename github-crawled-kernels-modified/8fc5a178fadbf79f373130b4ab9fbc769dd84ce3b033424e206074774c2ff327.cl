//{"D":2,"R":1,"X":0,"d":5,"dataR":4,"dataX":3,"dists":6,"r":8,"x":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void l1NormMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(6, i)].x += dot(fabs(x[hook(7, i)] - r[hook(8, 0)]), (float4)(1.f));
    dists[hook(6, i)].y += dot(fabs(x[hook(7, i)] - r[hook(8, 1)]), (float4)(1.f));
    dists[hook(6, i)].z += dot(fabs(x[hook(7, i)] - r[hook(8, 2)]), (float4)(1.f));
    dists[hook(6, i)].w += dot(fabs(x[hook(7, i)] - r[hook(8, 3)]), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(6, i)].x += dot(pown(x[hook(7, i)] - r[hook(8, 0)], 2), (float4)(1.f));
    dists[hook(6, i)].y += dot(pown(x[hook(7, i)] - r[hook(8, 1)], 2), (float4)(1.f));
    dists[hook(6, i)].z += dot(pown(x[hook(7, i)] - r[hook(8, 2)], 2), (float4)(1.f));
    dists[hook(6, i)].w += dot(pown(x[hook(7, i)] - r[hook(8, 3)], 2), (float4)(1.f));
  }
}
inline void l1NormMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(6, i)].x = 1.f / (1.f + a) * dot(fabs(x[hook(7, i)].lo - r[hook(8, 0)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(7, i)].hi - r[hook(8, 0)].hi), (float4)(1.f));
    dists[hook(6, i)].y = 1.f / (1.f + a) * dot(fabs(x[hook(7, i)].lo - r[hook(8, 1)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(7, i)].hi - r[hook(8, 1)].hi), (float4)(1.f));
    dists[hook(6, i)].z = 1.f / (1.f + a) * dot(fabs(x[hook(7, i)].lo - r[hook(8, 2)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(7, i)].hi - r[hook(8, 2)].hi), (float4)(1.f));
    dists[hook(6, i)].w = 1.f / (1.f + a) * dot(fabs(x[hook(7, i)].lo - r[hook(8, 3)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(7, i)].hi - r[hook(8, 3)].hi), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(6, i)].x = 1.f / (1.f + a) * dot(pown(x[hook(7, i)].lo - r[hook(8, 0)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(7, i)].hi - r[hook(8, 0)].hi, 2), (float4)(1.f));
    dists[hook(6, i)].y = 1.f / (1.f + a) * dot(pown(x[hook(7, i)].lo - r[hook(8, 1)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(7, i)].hi - r[hook(8, 1)].hi, 2), (float4)(1.f));
    dists[hook(6, i)].z = 1.f / (1.f + a) * dot(pown(x[hook(7, i)].lo - r[hook(8, 2)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(7, i)].hi - r[hook(8, 2)].hi, 2), (float4)(1.f));
    dists[hook(6, i)].w = 1.f / (1.f + a) * dot(pown(x[hook(7, i)].lo - r[hook(8, 3)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(7, i)].hi - r[hook(8, 3)].hi, 2), (float4)(1.f));
  }
}
kernel void rbcComputeDists_SharedXR(global float4* X, global float4* R, global float4* D, local float4* dataX, local float4* dataR, unsigned int d) {
  unsigned int gXdim = get_global_size(0);
  unsigned int lXdim = get_local_size(0);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);
  unsigned int lX = get_local_id(0);
  unsigned int lY = get_local_id(1);

  float4 dists[4];
  dists[hook(6, 0)] = (float4)(0.f);
  dists[hook(6, 1)] = (float4)(0.f);
  dists[hook(6, 2)] = (float4)(0.f);
  dists[hook(6, 3)] = (float4)(0.f);

  unsigned int d4 = d >> 2;

  unsigned int dBlockIterations = (d4 / lXdim) + (d4 % lXdim > 0);

  unsigned int dLast = select(lXdim, d4 % lXdim, d4 % lXdim);

  for (int i = 0; i < dBlockIterations; ++i) {
    if ((i < (dBlockIterations - 1)) || (lX < dLast)) {
      unsigned int gPosX = (gY << 2) * d4 + i * lXdim + lX;
      unsigned int gPosR = (get_group_id(0) * (lXdim << 2) + (lY << 2)) * d4 + i * lXdim + lX;
      unsigned int lPos = (lY << 2) * lXdim + lX;

      dataX[hook(3, lPos)] = X[hook(0, gPosX)];
      dataX[hook(3, lPos + lXdim)] = X[hook(0, gPosX + d4)];
      dataX[hook(3, lPos + 2 * lXdim)] = X[hook(0, gPosX + 2 * d4)];
      dataX[hook(3, lPos + 3 * lXdim)] = X[hook(0, gPosX + 3 * d4)];

      dataR[hook(4, lPos)] = R[hook(1, gPosR)];
      dataR[hook(4, lPos + lXdim)] = R[hook(1, gPosR + d4)];
      dataR[hook(4, lPos + 2 * lXdim)] = R[hook(1, gPosR + 2 * d4)];
      dataR[hook(4, lPos + 3 * lXdim)] = R[hook(1, gPosR + 3 * d4)];
    }

    barrier(0x01);

    unsigned int dIterations = select(lXdim, dLast, i == (dBlockIterations - 1));

    for (int j = 0; j < dIterations; ++j) {
      unsigned int lPosX = (lY << 2) * lXdim + j;
      unsigned int lPosR = (lX << 2) * lXdim + j;

      float4 x[4];
      x[hook(7, 0)] = dataX[hook(3, lPosX)];
      x[hook(7, 1)] = dataX[hook(3, lPosX + lXdim)];
      x[hook(7, 2)] = dataX[hook(3, lPosX + 2 * lXdim)];
      x[hook(7, 3)] = dataX[hook(3, lPosX + 3 * lXdim)];

      float4 r[4];
      r[hook(8, 0)] = dataR[hook(4, lPosR)];
      r[hook(8, 1)] = dataR[hook(4, lPosR + lXdim)];
      r[hook(8, 2)] = dataR[hook(4, lPosR + 2 * lXdim)];
      r[hook(8, 3)] = dataR[hook(4, lPosR + 3 * lXdim)];

      euclideanSquaredMetric(x, r, dists, 4);
    }

    barrier(0x01);
  }

  unsigned int gPosD = (gY << 2) * gXdim + gX;

  D[hook(2, gPosD)] = dists[hook(6, 0)];
  D[hook(2, gPosD + gXdim)] = dists[hook(6, 1)];
  D[hook(2, gPosD + 2 * gXdim)] = dists[hook(6, 2)];
  D[hook(2, gPosD + 3 * gXdim)] = dists[hook(6, 3)];
}