//{"blk":4,"cols":2,"input_itemsets_d":1,"input_itemsets_l":7,"offset_c":6,"offset_r":5,"penalty":3,"reference_d":0,"reference_l":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int maximum(int a, int b, int c) {
  int k;
  if (a <= b)
    k = b;
  else
    k = a;

  if (k <= c)
    return (c);
  else
    return (k);
}

__attribute__((num_simd_work_items(2))) __attribute__((reqd_work_group_size(16, 1, 1))) kernel void nw_kernel1(global int* restrict reference_d, global int* restrict input_itemsets_d, int cols, int penalty, int blk, int offset_r, int offset_c) {
  int bx = get_group_id(0);

  int tx = get_local_id(0);

  int base = offset_r * cols + offset_c;

  local int input_itemsets_l[(16 + 1) * (16 + 1)];
  local int reference_l[16 * 16];

  int b_index_x = bx;
  int b_index_y = blk - 1 - bx;

  int index = base + cols * 16 * b_index_y + 16 * b_index_x + tx + cols + 1;
  int index_n = base + cols * 16 * b_index_y + 16 * b_index_x + tx + 1;
  int index_w = base + cols * 16 * b_index_y + 16 * b_index_x + cols;
  int index_nw = base + cols * 16 * b_index_y + 16 * b_index_x;

  if (tx == 0) {
    input_itemsets_l[hook(7, 0 + tx * (16 + 1))] = input_itemsets_d[hook(1, index_nw + tx)];
  }

  barrier(0x01);

  for (int ty = 0; ty < 16; ty++) {
    reference_l[hook(8, tx + ty * 16)] = reference_d[hook(0, index + cols * ty)];
  }

  barrier(0x01);

  input_itemsets_l[hook(7, 0 + (tx + 1) * (16 + 1))] = input_itemsets_d[hook(1, index_w + cols * tx)];

  barrier(0x01);

  input_itemsets_l[hook(7, (tx + 1) + 0 * (16 + 1))] = input_itemsets_d[hook(1, index_n)];

  barrier(0x01);

  for (int m = 0; m < 16; m++) {
    if (tx <= m) {
      int t_index_x = tx + 1;
      int t_index_y = m - tx + 1;

      input_itemsets_l[hook(7, t_index_x + t_index_y * (16 + 1))] = maximum(input_itemsets_l[hook(7, (t_index_x - 1) + (t_index_y - 1) * (16 + 1))] + reference_l[hook(8, (t_index_x - 1) + (t_index_y - 1) * 16)], input_itemsets_l[hook(7, (t_index_x - 1) + (t_index_y) * (16 + 1))] - (penalty), input_itemsets_l[hook(7, (t_index_x) + (t_index_y - 1) * (16 + 1))] - (penalty));
    }
    barrier(0x01);
  }

  barrier(0x01);

  for (int m = 16 - 2; m >= 0; m--) {
    if (tx <= m) {
      int t_index_x = tx + 16 - m;
      int t_index_y = 16 - tx;

      input_itemsets_l[hook(7, t_index_x + t_index_y * (16 + 1))] = maximum(input_itemsets_l[hook(7, (t_index_x - 1) + (t_index_y - 1) * (16 + 1))] + reference_l[hook(8, (t_index_x - 1) + (t_index_y - 1) * 16)], input_itemsets_l[hook(7, (t_index_x - 1) + (t_index_y) * (16 + 1))] - (penalty), input_itemsets_l[hook(7, (t_index_x) + (t_index_y - 1) * (16 + 1))] - (penalty));
    }
    barrier(0x01);
  }

  for (int ty = 0; ty < 16; ty++) {
    input_itemsets_d[hook(1, index + cols * ty)] = input_itemsets_l[hook(7, (tx + 1) + (ty + 1) * (16 + 1))];
  }

  return;
}