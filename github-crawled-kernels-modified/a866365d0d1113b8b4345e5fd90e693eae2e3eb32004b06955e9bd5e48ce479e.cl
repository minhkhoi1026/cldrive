//{"d_I":13,"d_Nc":2,"d_Ne":3,"d_Nr":1,"d_c":12,"d_dE":10,"d_dN":8,"d_dS":9,"d_dW":11,"d_iN":4,"d_iS":5,"d_jE":6,"d_jW":7,"d_lambda":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void srad2_kernel(float d_lambda, int d_Nr, int d_Nc, long d_Ne, global int* d_iN, global int* d_iS, global int* d_jE, global int* d_jW, global float* d_dN, global float* d_dS, global float* d_dE, global float* d_dW, global float* d_c, global float* d_I) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = bx * 512 + tx;
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
    d_cN = d_c[hook(12, ei)];
    d_cS = d_c[hook(12, d_iS[rhook(5, row) + d_Nr * col)];
    d_cW = d_c[hook(12, ei)];
    d_cE = d_c[hook(12, row + d_Nr * d_jE[chook(6, col))];

    d_D = d_cN * d_dN[hook(8, ei)] + d_cS * d_dS[hook(9, ei)] + d_cW * d_dW[hook(11, ei)] + d_cE * d_dE[hook(10, ei)];

    d_I[hook(13, ei)] = d_I[hook(13, ei)] + 0.25 * d_lambda * d_D;
  }
}