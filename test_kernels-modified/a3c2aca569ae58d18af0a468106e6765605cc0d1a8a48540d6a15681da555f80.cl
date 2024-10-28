//{"d_I":10,"d_Nc":2,"d_Nr":1,"d_c":9,"d_dE":7,"d_dN":5,"d_dS":6,"d_dW":8,"d_iS":3,"d_jE":4,"d_lambda":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) __attribute__((max_global_work_dim(0))) kernel void srad2_kernel(float d_lambda, int d_Nr, int d_Nc, global int* restrict d_iS, global int* restrict d_jE, global float* restrict d_dN, global float* restrict d_dS, global float* restrict d_dE, global float* restrict d_dW, global float* restrict d_c, global float* restrict d_I) {
  for (int col = 0; col < d_Nc; ++col) {
    for (int row = 0; row < d_Nr; ++row) {
      int ei = col * d_Nr + row;

      float d_cN, d_cS, d_cW, d_cE;
      float d_D;

      d_cN = d_c[hook(9, ei)];
      d_cS = d_c[hook(9, d_iS[rhook(3, row) + d_Nr * col)];
      d_cW = d_c[hook(9, ei)];
      d_cE = d_c[hook(9, row + d_Nr * d_jE[chook(4, col))];

      d_D = d_cN * d_dN[hook(5, ei)] + d_cS * d_dS[hook(6, ei)] + d_cW * d_dW[hook(8, ei)] + d_cE * d_dE[hook(7, ei)];

      d_I[hook(10, ei)] = d_I[hook(10, ei)] + 0.25 * d_lambda * d_D;
    }
  }
}