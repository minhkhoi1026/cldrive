//{"A":4,"Asub":8,"B":5,"Bsub":9,"C":7,"alpha":3,"beta":6,"ncolA":2,"ncolB":1,"nrowA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_gemm(const unsigned int nrowA, const unsigned int ncolB, const unsigned int ncolA, const float alpha, global const float* A, global const float* B, const float beta, global float* C, local float* Asub, local float* Bsub) {
  const unsigned int lidx = get_local_id(0);
  const unsigned int lidy = get_local_id(1);
  const unsigned int TS = get_local_size(0);
  const unsigned int gidx = TS * get_group_id(0) + lidx;
  const unsigned int gidy = TS * get_group_id(1) + lidy;

  float acc = 0.0f;

  const int numtiles = ncolA / TS;
  for (int t = 0; t < numtiles; t++) {
    const int tiledRow = TS * t + lidx;
    const int tiledCol = TS * t + lidy;
    Asub[hook(8, lidy * TS + lidx)] = A[hook(4, tiledCol * nrowA + gidx)];
    Bsub[hook(9, lidy * TS + lidx)] = B[hook(5, gidy * ncolA + tiledRow)];

    barrier(0x01);

    for (int k = 0; k < TS; k++) {
      acc += Asub[hook(8, k * TS + lidx)] * Bsub[hook(9, lidy * TS + k)] * alpha;
    }

    barrier(0x01);
  }

  C[hook(7, gidy * nrowA + gidx)] = fma(beta, C[hook(7, gidy * nrowA + gidx)], acc);
}