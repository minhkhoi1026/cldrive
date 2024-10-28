//{"a":0,"b":2,"extend_gap":5,"jj":13,"m":1,"match":6,"maxCol1":17,"maxScore":12,"mismatch":7,"nbb":3,"next_lastCol":9,"next_maxRow":11,"open_extend_gap":4,"prev_lastCol":8,"prev_maxRow":10,"private_b1":14,"ptr_b":15,"row1":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((num_compute_units(1))) __attribute__((task)) kernel void sw(global const char* restrict a, const int m, global const char* restrict b, const int nbb, const int open_extend_gap, const int extend_gap, const int match, const int mismatch, global const int* restrict prev_lastCol, global int* restrict next_lastCol, global const int* restrict prev_maxRow, global int* restrict next_maxRow, global int* restrict maxScore, const int jj) {
  int row1[512] = {0}, maxCol1[512] = {0};
  int score = 0, auxLastCol = 0;

  char private_b1[512];

  global const char* ptr_b = b + jj * 512;

  for (int i = 0; i < 512; i++)
    private_b1[hook(14, i)] = ptr_b[hook(15, i)];

  for (int i = 0; i < m; i++) {
    char a_i = a[hook(0, i)];
    int previous = 0;
    int maxRow_i = 0;
    int score_i = 0;
    if (jj != 0) {
      row1[hook(16, 0)] = prev_lastCol[hook(8, i)];
      maxRow_i = prev_maxRow[hook(10, i)];
    }

    for (int j = 0; j < 512; j++) {
      int current = row1[hook(16, j)] + (a_i == private_b1[hook(14, j)] ? match : -mismatch);

      current = max(current, maxRow_i);
      current = max(current, maxCol1[hook(17, j)]);
      current = max(current, 0);

      score_i = max(score_i, current);

      int aux1 = maxRow_i - extend_gap;
      int aux2 = maxCol1[hook(17, j)] - extend_gap;
      int aux3 = current - open_extend_gap;
      maxRow_i = max(aux1, aux3);
      maxCol1[hook(17, j)] = max(aux2, aux3);

      row1[hook(16, j)] = previous;
      previous = current;
    }

    if (jj != nbb - 1) {
      next_lastCol[hook(9, i)] = auxLastCol;
      auxLastCol = previous;

      next_maxRow[hook(11, i)] = maxRow_i;
    }

    score = max(score, score_i);
  }

  maxScore[hook(12, 0)] = max(maxScore[hook(12, 0)], score);
}