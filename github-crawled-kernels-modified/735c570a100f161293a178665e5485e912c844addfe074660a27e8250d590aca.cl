//{"d_I":10,"d_Ne":2,"d_Nr":1,"d_c":9,"d_dE":7,"d_dN":5,"d_dS":6,"d_dW":8,"d_iS":3,"d_jE":4,"d_lambda":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void srad2_kernel(float d_lambda, int d_Nr, long d_Ne, global int* restrict d_iS, global int* restrict d_jE, global float* restrict d_dN, global float* restrict d_dS, global float* restrict d_dE, global float* restrict d_dW, global float* restrict d_c, global float* restrict d_I) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = bx * 32 + tx;
  int row;
  int col;

  float d_cN, d_cS, d_cW, d_cE;
  float d_D;

  row = (ei + 1) % d_Nr - 1;
  col = (ei + 1) / d_Nr + 1 - 1;
  if ((ei + 1) % d_Nr == 0) {
    row = d_Nr - 1;
    col = col - 1;
  }

  if (ei < d_Ne) {
    d_cN = d_c[hook(9, ei)];
    d_cS = d_c[hook(9, d_iS[rhook(3, row) + d_Nr * col)];
    d_cW = d_c[hook(9, ei)];
    d_cE = d_c[hook(9, row + d_Nr * d_jE[chook(4, col))];

    d_D = d_cN * d_dN[hook(5, ei)] + d_cS * d_dS[hook(6, ei)] + d_cW * d_dW[hook(8, ei)] + d_cE * d_dE[hook(7, ei)];

    d_I[hook(10, ei)] = d_I[hook(10, ei)] + 0.25 * d_lambda * d_D;
  }
}