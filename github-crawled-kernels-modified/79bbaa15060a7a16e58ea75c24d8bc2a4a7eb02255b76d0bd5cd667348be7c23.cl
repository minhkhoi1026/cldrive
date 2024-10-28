//{"A":1,"B":2,"C":0,"hA":4,"hB":6,"wA":3,"wB":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float2 float2;
inline float2 cmult(float2 a, float2 b) {
  return (float2)(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}
inline float2 add(float2 a, float2 b) {
  return (float2)(a.x + b.x, a.y + b.y);
}

kernel void complexMatrixMul(global float* C, global float* A, global float* B, int wA, int hA, int wB, int hB) {
  int tx = get_global_id(0);
  int ty = get_global_id(1);

  if (tx >= wB || ty >= hA) {
    return;
  }
  float2 value = (float2)(0, 0);
  for (int k = 0; k < wA; ++k) {
    int offSetA = (ty * wA + k) * 2;
    float2 elementA = (float2)(A[hook(1, offSetA)], A[hook(1, offSetA + 1)]);
    int offSetB = (k * wB + tx) * 2;
    float2 elementB = (float2)(B[hook(2, offSetB)], B[hook(2, offSetB + 1)]);
    value = add(value, cmult(elementA, elementB));
  }
  int offSetC = (ty * wB + tx) * 2;
  C[hook(0, offSetC)] = value.x;
  C[hook(0, offSetC + 1)] = value.y;
}