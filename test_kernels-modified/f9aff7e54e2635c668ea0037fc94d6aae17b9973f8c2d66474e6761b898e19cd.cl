//{"d_I":12,"d_Ne":1,"d_Nr":0,"d_c":11,"d_dE":8,"d_dN":6,"d_dS":7,"d_dW":9,"d_iN":2,"d_iS":3,"d_jE":4,"d_jW":5,"d_q0sqr":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void srad_kernel(int d_Nr, long d_Ne, global int* restrict d_iN, global int* restrict d_iS, global int* restrict d_jE, global int* restrict d_jW, global float* restrict d_dN, global float* restrict d_dS, global float* restrict d_dE, global float* restrict d_dW, float d_q0sqr, global float* restrict d_c, global float* restrict d_I) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = bx * 32 + tx;
  int row;
  int col;

  float d_Jc;
  float d_dN_loc, d_dS_loc, d_dW_loc, d_dE_loc;
  float d_c_loc;
  float d_G2, d_L, d_num, d_den, d_qsqr;

  row = (ei + 1) % d_Nr - 1;
  col = (ei + 1) / d_Nr + 1 - 1;
  if ((ei + 1) % d_Nr == 0) {
    row = d_Nr - 1;
    col = col - 1;
  }

  if (ei < d_Ne) {
    d_Jc = d_I[hook(12, ei)];

    d_dN_loc = d_I[hook(12, d_iN[rhook(2, row) + d_Nr * col)] - d_Jc;
    d_dS_loc = d_I[hook(12, d_iS[rhook(3, row) + d_Nr * col)] - d_Jc;
    d_dW_loc = d_I[hook(12, row + d_Nr * d_jW[chook(5, col))] - d_Jc;
    d_dE_loc = d_I[hook(12, row + d_Nr * d_jE[chook(4, col))] - d_Jc;

    d_G2 = (d_dN_loc * d_dN_loc + d_dS_loc * d_dS_loc + d_dW_loc * d_dW_loc + d_dE_loc * d_dE_loc) / (d_Jc * d_Jc);

    d_L = (d_dN_loc + d_dS_loc + d_dW_loc + d_dE_loc) / d_Jc;

    d_num = (0.5 * d_G2) - ((1.0 / 16.0) * (d_L * d_L));
    d_den = 1 + (0.25 * d_L);
    d_qsqr = d_num / (d_den * d_den);

    d_den = (d_qsqr - d_q0sqr) / (d_q0sqr * (1 + d_q0sqr));
    d_c_loc = 1.0 / (1.0 + d_den);

    if (d_c_loc < 0) {
      d_c_loc = 0;
    } else if (d_c_loc > 1) {
      d_c_loc = 1;
    }

    d_dN[hook(6, ei)] = d_dN_loc;
    d_dS[hook(7, ei)] = d_dS_loc;
    d_dW[hook(9, ei)] = d_dW_loc;
    d_dE[hook(8, ei)] = d_dE_loc;
    d_c[hook(11, ei)] = d_c_loc;
  }
}