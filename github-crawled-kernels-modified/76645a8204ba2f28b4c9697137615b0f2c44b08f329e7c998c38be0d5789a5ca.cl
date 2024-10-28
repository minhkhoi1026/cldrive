//{"aF":12,"aH":11,"flags":5,"gap_extend":4,"gap_open":3,"i_max":7,"j_max":8,"max_scores":6,"seq1":0,"seq2":1,"subs_matrix":2,"x":9,"y":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_f32(global const char* seq1, global const char* seq2, constant const float* subs_matrix, float gap_open, float gap_extend, global char* flags, global float* max_scores, global int* i_max, global int* j_max, int x, int y) {
  float epsilon = 0.0001f;
  int id = get_global_id(0);
  int w = get_global_size(0);
  float inf = gap_open + gap_extend + 1;
  float aF[256] = {0};
  float aH[256] = {-inf};

  float diagonal;
  float E, E_sub, F, F_sub, H, H_diag, H_left;

  int temp_i_max = 0;
  int temp_j_max = 0;
  float temp_max_score = 0;

  bool H_eq_diag;
  bool H_gt_zero;
  bool H_eq_E;

  char flag;

  int s1 = id;
  int s2 = id;
  int t1;

  for (int i = 1; i < x; i++, s1 += w) {
    E = -inf;
    H_diag = 0;
    H = 0;
    flags[hook(5, w * i)] = 0;
    t1 = 128 * seq1[hook(0, w * (i - 1) + id)];
    for (int j = 1; j < y; j++, s2 += w) {
      diagonal = H_diag + subs_matrix[hook(2, t1 + seq2[whook(1, w * (j - 1) + id))];
      H_left = aH[hook(11, j)];
      H_diag = H_left;

      E_sub = E - gap_extend;
      E = H - gap_open;
      E = fmax(E, E_sub);

      F_sub = aF[hook(12, j)] - gap_extend;
      F = H_left - gap_open;
      F = fmax(F, F_sub);
      aF[hook(12, j)] = F;

      H = fmax(E, F);
      H = fmax(H, diagonal);
      H = fmax(H, 0.0f);
      aH[hook(11, j)] = H;

      H_eq_diag = (fabs(H - diagonal) < epsilon);
      H_gt_zero = (H > epsilon);
      H_eq_E = (fabs(H - E) < epsilon);
      flag = (fabs(E - E_sub) < epsilon);
      flag <<= 1;
      flag |= (fabs(F - F_sub) < epsilon);
      flag <<= 1;
      flag |= (H_eq_E || H_eq_diag) && H_gt_zero;
      flag <<= 1;
      flag |= (((fabs(H - F) < epsilon) && !H_eq_E) || H_eq_diag) && H_gt_zero;
      flags[hook(5, w * (y * i + j) + id)] = flag;

      if ((H - temp_max_score) > epsilon) {
        temp_max_score = H;
        temp_i_max = i;
        temp_j_max = j;
      }
    }
  }

  i_max[hook(7, id)] = temp_i_max;
  j_max[hook(8, id)] = temp_j_max;
  max_scores[hook(6, id)] = temp_max_score;
}