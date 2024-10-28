//{"N":0,"dists":2,"r":4,"val":1,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void l1NormMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(2, i)].x += dot(fabs(x[hook(3, i)] - r[hook(4, 0)]), (float4)(1.f));
    dists[hook(2, i)].y += dot(fabs(x[hook(3, i)] - r[hook(4, 1)]), (float4)(1.f));
    dists[hook(2, i)].z += dot(fabs(x[hook(3, i)] - r[hook(4, 2)]), (float4)(1.f));
    dists[hook(2, i)].w += dot(fabs(x[hook(3, i)] - r[hook(4, 3)]), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric(float4* x, float4* r, float4* dists, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(2, i)].x += dot(pown(x[hook(3, i)] - r[hook(4, 0)], 2), (float4)(1.f));
    dists[hook(2, i)].y += dot(pown(x[hook(3, i)] - r[hook(4, 1)], 2), (float4)(1.f));
    dists[hook(2, i)].z += dot(pown(x[hook(3, i)] - r[hook(4, 2)], 2), (float4)(1.f));
    dists[hook(2, i)].w += dot(pown(x[hook(3, i)] - r[hook(4, 3)], 2), (float4)(1.f));
  }
}
inline void l1NormMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(2, i)].x = 1.f / (1.f + a) * dot(fabs(x[hook(3, i)].lo - r[hook(4, 0)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(3, i)].hi - r[hook(4, 0)].hi), (float4)(1.f));
    dists[hook(2, i)].y = 1.f / (1.f + a) * dot(fabs(x[hook(3, i)].lo - r[hook(4, 1)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(3, i)].hi - r[hook(4, 1)].hi), (float4)(1.f));
    dists[hook(2, i)].z = 1.f / (1.f + a) * dot(fabs(x[hook(3, i)].lo - r[hook(4, 2)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(3, i)].hi - r[hook(4, 2)].hi), (float4)(1.f));
    dists[hook(2, i)].w = 1.f / (1.f + a) * dot(fabs(x[hook(3, i)].lo - r[hook(4, 3)].lo), (float4)(1.f)) + a * dot(fabs(x[hook(3, i)].hi - r[hook(4, 3)].hi), (float4)(1.f));
  }
}
inline void euclideanSquaredMetric8(float8* x, float8* r, float4* dists, float a, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i) {
    dists[hook(2, i)].x = 1.f / (1.f + a) * dot(pown(x[hook(3, i)].lo - r[hook(4, 0)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(3, i)].hi - r[hook(4, 0)].hi, 2), (float4)(1.f));
    dists[hook(2, i)].y = 1.f / (1.f + a) * dot(pown(x[hook(3, i)].lo - r[hook(4, 1)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(3, i)].hi - r[hook(4, 1)].hi, 2), (float4)(1.f));
    dists[hook(2, i)].z = 1.f / (1.f + a) * dot(pown(x[hook(3, i)].lo - r[hook(4, 2)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(3, i)].hi - r[hook(4, 2)].hi, 2), (float4)(1.f));
    dists[hook(2, i)].w = 1.f / (1.f + a) * dot(pown(x[hook(3, i)].lo - r[hook(4, 3)].lo, 2), (float4)(1.f)) + a * dot(pown(x[hook(3, i)].hi - r[hook(4, 3)].hi, 2), (float4)(1.f));
  }
}
kernel void rbcNInit(global uint4* N, unsigned int val) {
  unsigned int gX = get_global_id(0);

  N[hook(0, gX)] = (uint4)(val);
}