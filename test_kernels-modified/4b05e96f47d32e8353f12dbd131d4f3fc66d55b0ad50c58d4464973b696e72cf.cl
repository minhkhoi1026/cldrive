//{"M":4,"SEQA":0,"SEQB":1,"alignedA":2,"alignedB":3,"ptr":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void needwun(char SEQA[128], char SEQB[128], char alignedA[128 + 128], char alignedB[128 + 128], int M[(128 + 1) * (128 + 1)], char ptr[(128 + 1) * (128 + 1)]);
struct bench_args_t {
  char seqA[128];
  char seqB[128];
  char alignedA[128 + 128];
  char alignedB[128 + 128];
  int M[(128 + 1) * (128 + 1)];
  char ptr[(128 + 1) * (128 + 1)];
};
kernel void __attribute__((task)) workload(global char* restrict SEQA, global char* restrict SEQB, global char* restrict alignedA, global char* restrict alignedB) {
  local int M[(128 + 1) * (128 + 1)];
  local char ptr[(128 + 1) * (128 + 1)];

  int score, up_left, up, left, max;
  int row, row_up, r;
  int a_idx, b_idx;
  int a_str_idx, b_str_idx;

init_row:
  for (a_idx = 0; a_idx < (128 + 1); a_idx++) {
    M[hook(4, a_idx)] = a_idx * -1;
  }
init_col:
  for (b_idx = 0; b_idx < (128 + 1); b_idx++) {
    M[hook(4, b_idx * (128 + 1))] = b_idx * -1;
  }

fill_out:
  for (b_idx = 1; b_idx < (128 + 1); b_idx++) {
  fill_in:
    for (a_idx = 1; a_idx < (128 + 1); a_idx++) {
      if (SEQA[hook(0, a_idx - 1)] == SEQB[hook(1, b_idx - 1)]) {
        score = 1;
      } else {
        score = -1;
      }

      row_up = (b_idx - 1) * (128 + 1);
      row = (b_idx) * (128 + 1);

      up_left = M[hook(4, row_up + (a_idx - 1))] + score;
      up = M[hook(4, row_up + (a_idx))] + -1;
      left = M[hook(4, row + (a_idx - 1))] + -1;

      max = (((up_left) > ((((up) > (left)) ? (up) : (left)))) ? (up_left) : ((((up) > (left)) ? (up) : (left))));

      M[hook(4, row + a_idx)] = max;
      if (max == left) {
        ptr[hook(5, row + a_idx)] = '<';
      } else if (max == up) {
        ptr[hook(5, row + a_idx)] = '^';
      } else {
        ptr[hook(5, row + a_idx)] = '\\';
      }
    }
  }

  a_idx = 128;
  b_idx = 128;
  a_str_idx = 0;
  b_str_idx = 0;

trace:
  while (a_idx > 0 || b_idx > 0) {
    r = b_idx * (128 + 1);
    if (ptr[hook(5, r + a_idx)] == '\\') {
      alignedA[hook(2, a_str_idx++)] = SEQA[hook(0, a_idx - 1)];
      alignedB[hook(3, b_str_idx++)] = SEQB[hook(1, b_idx - 1)];
      a_idx--;
      b_idx--;
    } else if (ptr[hook(5, r + a_idx)] == '<') {
      alignedA[hook(2, a_str_idx++)] = SEQA[hook(0, a_idx - 1)];
      alignedB[hook(3, b_str_idx++)] = '-';
      a_idx--;
    } else {
      alignedA[hook(2, a_str_idx++)] = '-';
      alignedB[hook(3, b_str_idx++)] = SEQB[hook(1, b_idx - 1)];
      b_idx--;
    }
  }

pad_a:
  for (; a_str_idx < 128 + 128; a_str_idx++) {
    alignedA[hook(2, a_str_idx)] = '_';
  }
pad_b:
  for (; b_str_idx < 128 + 128; b_str_idx++) {
    alignedB[hook(3, b_str_idx)] = '_';
  }
}