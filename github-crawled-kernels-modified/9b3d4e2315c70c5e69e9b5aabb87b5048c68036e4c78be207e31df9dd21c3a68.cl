//{"A":0,"B":1,"C":2,"alpha":3,"beta":4,"n":5,"pA":6,"pB":7,"pC":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(global float4 const* restrict A, global float4 const* restrict B, global float4* restrict C, float alpha, float beta, unsigned int n) {
  const unsigned int j = get_global_id(0);
  const unsigned int i = get_global_id(1);

  global float4 const* pA = &A[hook(0, (n >> 2) * ((unsigned int)1) * i)];
  global float4 const* pB = &B[hook(1, (n >> 2) * ((unsigned int)4) * j)];

  float4 ab = (float4)0.0f;
  for (unsigned int k = 0; k < (n >> 2); k += 2, pA += 2, pB += 2) {
    float4 a_0 = pA[hook(6, (n >> 2) * 0 + 0)];
    float4 a_1 = pA[hook(6, (n >> 2) * 0 + 1)];

    float4 b0_0 = pB[hook(7, (n >> 2) * 0 + 0)];
    float4 b0_1 = pB[hook(7, (n >> 2) * 0 + 1)];
    float4 b1_0 = pB[hook(7, (n >> 2) * 1 + 0)];
    float4 b1_1 = pB[hook(7, (n >> 2) * 1 + 1)];
    float4 b2_0 = pB[hook(7, (n >> 2) * 2 + 0)];
    float4 b2_1 = pB[hook(7, (n >> 2) * 2 + 1)];
    float4 b3_0 = pB[hook(7, (n >> 2) * 3 + 0)];
    float4 b3_1 = pB[hook(7, (n >> 2) * 3 + 1)];

    ab += (float4)(dot(a_0, b0_0), dot(a_0, b1_0), dot(a_0, b2_0), dot(a_0, b3_0));
    ab += (float4)(dot(a_1, b0_1), dot(a_1, b1_1), dot(a_1, b2_1), dot(a_1, b3_1));
  }

  global float4* pC = &C[hook(2, (n >> 2) * ((unsigned int)1) * i + j)];
  pC[hook(8, (n >> 2) * 0)] = alpha * ab + beta * pC[hook(8, (n >> 2) * 0)];
}