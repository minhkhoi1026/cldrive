//{"A":1,"B":2,"C":0,"dimB0":5,"dimB1":6,"dimB2":7,"hA":4,"wA":3}
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

kernel void dftMatrixMul(global float* C, global float* A, global float* B, int wA, int hA, int dimB0, int dimB1, int dimB2) {
  int proj = get_global_id(0);
  int u = get_global_id(1);
  int v = get_global_id(2);

  if (proj >= dimB0 || u >= dimB1 || v >= dimB2) {
    return;
  }

  float2 value = (float2)(0, 0);
  for (int k = 0; k < dimB0; k++) {
    int offSetA = (proj * wA + k) * 2;
    float2 elementA = (float2)(A[hook(1, offSetA)], A[hook(1, offSetA + 1)]);

    int offSetB = (v * dimB0 * dimB1 + u * dimB0 + k) * 2;
    float2 elementB = (float2)(B[hook(2, offSetB)], B[hook(2, offSetB + 1)]);
    value = add(value, cmult(elementA, elementB));
  }

  int offSetC = (v * dimB0 * dimB1 + u * dimB0 + proj) * 2;
  C[hook(0, offSetC)] = value.x;
  C[hook(0, offSetC + 1)] = value.y;
}