//{"D":2,"R":1,"X":0,"a":3,"dists":4,"r":6,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void l1NormMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(4, i)].x += dot(fabs(x[hook(5, i)] - r[hook(6, 0)]), (float4)(1.f));
    dists[hook(4, i)].y += dot(fabs(x[hook(5, i)] - r[hook(6, 1)]), (float4)(1.f));
    dists[hook(4, i)].z += dot(fabs(x[hook(5, i)] - r[hook(6, 2)]), (float4)(1.f));
    dists[hook(4, i)].w += dot(fabs(x[hook(5, i)] - r[hook(6, 3)]), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(4, i)].x += dot(pown(x[hook(5, i)] - r[hook(6, 0)], 2), (float4)(1.f));
    dists[hook(4, i)].y += dot(pown(x[hook(5, i)] - r[hook(6, 1)], 2), (float4)(1.f));
    dists[hook(4, i)].z += dot(pown(x[hook(5, i)] - r[hook(6, 2)], 2), (float4)(1.f));
    dists[hook(4, i)].w += dot(pown(x[hook(5, i)] - r[hook(6, 3)], 2), (float4)(1.f));
  }
}
inline void l1NormMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(4, i)].x = 1.f / (1.f + a) * dot(fabs(x[hook(5, i)].lo - r[hook(6, 0)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(5, i)].hi - r[hook(6, 0)].hi), (float4)(1.f));
    dists[hook(4, i)].y = 1.f / (1.f + a) * dot(fabs(x[hook(5, i)].lo - r[hook(6, 1)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(5, i)].hi - r[hook(6, 1)].hi), (float4)(1.f));
    dists[hook(4, i)].z = 1.f / (1.f + a) * dot(fabs(x[hook(5, i)].lo - r[hook(6, 2)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(5, i)].hi - r[hook(6, 2)].hi), (float4)(1.f));
    dists[hook(4, i)].w = 1.f / (1.f + a) * dot(fabs(x[hook(5, i)].lo - r[hook(6, 3)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(5, i)].hi - r[hook(6, 3)].hi), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(4, i)].x = 1.f / (1.f + a) * dot(pown(x[hook(5, i)].lo - r[hook(6, 0)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(5, i)].hi - r[hook(6, 0)].hi, 2), (float4)(1.f));
    dists[hook(4, i)].y = 1.f / (1.f + a) * dot(pown(x[hook(5, i)].lo - r[hook(6, 1)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(5, i)].hi - r[hook(6, 1)].hi, 2), (float4)(1.f));
    dists[hook(4, i)].z = 1.f / (1.f + a) * dot(pown(x[hook(5, i)].lo - r[hook(6, 2)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(5, i)].hi - r[hook(6, 2)].hi, 2), (float4)(1.f));
    dists[hook(4, i)].w = 1.f / (1.f + a) * dot(pown(x[hook(5, i)].lo - r[hook(6, 3)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(5, i)].hi - r[hook(6, 3)].hi, 2), (float4)(1.f));
  }
}
kernel void rbcComputeDists_Kinect(global float8* X, global float8* R, global float4* D, float a) {
  unsigned int gXdim = get_global_size(0);

  unsigned int gX = get_global_id(0);
  unsigned int gY = get_global_id(1);

  unsigned int gPosX = gY << 2;
  unsigned int gPosR = gX << 2;

  float8 x[4];
  x[hook(5, 0)] = X[hook(0, gPosX)];
  x[hook(5, 1)] = X[hook(0, gPosX + 1)];
  x[hook(5, 2)] = X[hook(0, gPosX + 2)];
  x[hook(5, 3)] = X[hook(0, gPosX + 3)];

  float8 r[4];
  r[hook(6, 0)] = R[hook(1, gPosR)];
  r[hook(6, 1)] = R[hook(1, gPosR + 1)];
  r[hook(6, 2)] = R[hook(1, gPosR + 2)];
  r[hook(6, 3)] = R[hook(1, gPosR + 3)];

  float4 dists[4];

  euclideanSquaredMetric8(x, r, dists, a, 4);

  unsigned int gPosD = (gY << 2) * gXdim + gX;

  D[hook(2, gPosD)] = dists[hook(4, 0)];
  D[hook(2, gPosD + gXdim)] = dists[hook(4, 1)];
  D[hook(2, gPosD + 2 * gXdim)] = dists[hook(4, 2)];
  D[hook(2, gPosD + 3 * gXdim)] = dists[hook(4, 3)];
}