//{"C_cuda":5,"E_C":0,"J_cuda":4,"N_C":2,"S_C":3,"W_C":1,"cols":6,"east":16,"east[ty]":15,"north":10,"north[ty]":9,"q0sqr":8,"rows":7,"south":12,"south[ty]":11,"temp":18,"temp[ty + 1]":19,"temp[ty - 1]":20,"temp[ty]":17,"temp_result":22,"temp_result[ty]":21,"west":14,"west[ty]":13}
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

  local float temp[64][64];
  local float temp_result[64][64];

  local float north[64][64];
  local float south[64][64];
  local float east[64][64];
  local float west[64][64];

  north[hook(10, ty)][hook(9, tx)] = J_cuda[hook(4, index_n)];
  south[hook(12, ty)][hook(11, tx)] = J_cuda[hook(4, index_s)];
  if (by == 0) {
    north[hook(10, ty)][hook(9, tx)] = J_cuda[hook(4, 64 * bx + tx)];
  } else if (by == get_num_groups(1) - 1) {
    south[hook(12, ty)][hook(11, tx)] = J_cuda[hook(4, cols * 64 * (get_num_groups(1) - 1) + 64 * bx + cols * (64 - 1) + tx)];
  }
  barrier(0x01);

  west[hook(14, ty)][hook(13, tx)] = J_cuda[hook(4, index_w)];
  east[hook(16, ty)][hook(15, tx)] = J_cuda[hook(4, index_e)];

  if (bx == 0) {
    west[hook(14, ty)][hook(13, tx)] = J_cuda[hook(4, cols * 64 * by + cols * ty)];
  } else if (bx == get_num_groups(0) - 1) {
    east[hook(16, ty)][hook(15, tx)] = J_cuda[hook(4, cols * 64 * by + 64 * (get_num_groups(0) - 1) + cols * ty + 64 - 1)];
  }

  barrier(0x01);

  temp[hook(18, ty)][hook(17, tx)] = J_cuda[hook(4, index)];

  barrier(0x01);

  jc = temp[hook(18, ty)][hook(17, tx)];

  if (ty == 0 && tx == 0) {
    n = north[hook(10, ty)][hook(9, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = west[hook(14, ty)][hook(13, tx)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  } else if (ty == 0 && tx == 64 - 1) {
    n = north[hook(10, ty)][hook(9, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = east[hook(16, ty)][hook(15, tx)] - jc;
  } else if (ty == 64 - 1 && tx == 64 - 1) {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = south[hook(12, ty)][hook(11, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = east[hook(16, ty)][hook(15, tx)] - jc;
  } else if (ty == 64 - 1 && tx == 0) {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = south[hook(12, ty)][hook(11, tx)] - jc;
    w = west[hook(14, ty)][hook(13, tx)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  }

  else if (ty == 0) {
    n = north[hook(10, ty)][hook(9, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  } else if (tx == 64 - 1) {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = east[hook(16, ty)][hook(15, tx)] - jc;
  } else if (ty == 64 - 1) {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = south[hook(12, ty)][hook(11, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  } else if (tx == 0) {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = west[hook(14, ty)][hook(13, tx)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  } else {
    n = temp[hook(18, ty - 1)][hook(20, tx)] - jc;
    s = temp[hook(18, ty + 1)][hook(19, tx)] - jc;
    w = temp[hook(18, ty)][hook(17, tx - 1)] - jc;
    e = temp[hook(18, ty)][hook(17, tx + 1)] - jc;
  }

  g2 = (n * n + s * s + w * w + e * e) / (jc * jc);

  l = (n + s + w + e) / jc;

  num = (0.5f * g2) - ((1.0f / 16.0f) * (l * l));
  den = 1 + (.25f * l);
  qsqr = num / (den * den);

  den = (qsqr - q0sqr) / (q0sqr * (1 + q0sqr));
  c = 1.0f / (1.0f + den);

  if (c < 0) {
    temp_result[hook(22, ty)][hook(21, tx)] = 0;
  } else if (c > 1) {
    temp_result[hook(22, ty)][hook(21, tx)] = 1;
  } else {
    temp_result[hook(22, ty)][hook(21, tx)] = c;
  }

  barrier(0x01);

  C_cuda[hook(5, index)] = temp_result[hook(22, ty)][hook(21, tx)];
  E_C[hook(0, index)] = e;
  W_C[hook(1, index)] = w;
  S_C[hook(3, index)] = s;
  N_C[hook(2, index)] = n;
}