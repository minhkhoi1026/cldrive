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

kernel void matrixMul(global float* C, global float* A, global float* B, int wA, int hA, int wB, int hB) {
  int tx = get_global_id(0);
  int ty = get_global_id(1);

  if (tx >= wB || ty >= hA) {
    return;
  }

  float value = 0;
  for (int k = 0; k < wA; ++k) {
    float elementA = A[hook(1, ty * wA + k)];
    float elementB = B[hook(2, k * wB + tx)];
    value += elementA * elementB;
  }

  C[hook(0, ty * wB + tx)] = value;
}