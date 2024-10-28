//{"C_cuda":5,"E_C":0,"J_cuda":4,"N_C":2,"S_C":3,"W_C":1,"cols":6,"q0sqr":8,"rows":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void srad_cuda_1(global float* E_C, global float* W_C, global float* N_C, global float* S_C, global float* J_cuda, global float* C_cuda, int cols, int rows, float q0sqr) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int index = cols * 64 * by + 64 * bx + cols * ty + tx;
  int index_n = cols * 64 * by + 64 * bx + tx - cols;
  int index_s = cols * 64 * by + 64 * bx + cols * 64 + tx;
  int index_w = cols * 64 * by + 64 * bx + cols * ty - 1;
  int index_e = cols * 64 * by + 64 * bx + cols * ty + 64;

  float n, w, e, s, jc, g2, l, num, den, qsqr, c;

  if (by == 0) {
    index_n = 64 * bx + tx;
  } else if (by == get_num_groups(1) - 1) {
    index_s = cols * 64 * by + 64 * bx + cols * (64 - 1) + tx;
  }

  if (bx == 0) {
    index_w = cols * 64 * by + cols * ty;
  } else if (bx == get_num_groups(0) - 1) {
    index_e = cols * 64 * by + 64 * bx + cols * ty + 64 - 1;
  }

  int index_yp1_x = cols * 64 * by + 64 * bx + cols * (ty + 1) + tx;
  int index_ym1_x = cols * 64 * by + 64 * bx + cols * (ty - 1) + tx;
  int index_y_xp1 = cols * 64 * by + 64 * bx + cols * ty + (tx + 1);
  int index_y_xm1 = cols * 64 * by + 64 * bx + cols * ty + (tx - 1);

  jc = J_cuda[hook(4, index)];

  if (ty == 0 && tx == 0) {
    n = J_cuda[hook(4, index_n)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_w)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  } else if (ty == 0 && tx == 64 - 1) {
    n = J_cuda[hook(4, index_n)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_e)] - jc;
  } else if (ty == 64 - 1 && tx == 64 - 1) {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_s)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_e)] - jc;
  } else if (ty == 64 - 1 && tx == 0) {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_s)] - jc;
    w = J_cuda[hook(4, index_w)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  } else if (ty == 0) {
    n = J_cuda[hook(4, index_n)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  } else if (tx == 64 - 1) {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_e)] - jc;
  } else if (ty == 64 - 1) {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_s)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  } else if (tx == 0) {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_w)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  } else {
    n = J_cuda[hook(4, index_ym1_x)] - jc;
    s = J_cuda[hook(4, index_yp1_x)] - jc;
    w = J_cuda[hook(4, index_y_xm1)] - jc;
    e = J_cuda[hook(4, index_y_xp1)] - jc;
  }

  g2 = (n * n + s * s + w * w + e * e) / (jc * jc);

  l = (n + s + w + e) / jc;

  num = (0.5f * g2) - ((1.0f / 16.0f) * (l * l));
  den = 1 + (.25f * l);
  qsqr = num / (den * den);

  den = (qsqr - q0sqr) / (q0sqr * (1 + q0sqr));
  c = 1.0f / (1.0f + den);

  if (c < 0) {
    C_cuda[hook(5, index)] = 0;
  } else if (c > 1) {
    C_cuda[hook(5, index)] = 1;
  } else {
    C_cuda[hook(5, index)] = c;
  }

  E_C[hook(0, index)] = e;
  W_C[hook(1, index)] = w;
  S_C[hook(3, index)] = s;
  N_C[hook(2, index)] = n;
}