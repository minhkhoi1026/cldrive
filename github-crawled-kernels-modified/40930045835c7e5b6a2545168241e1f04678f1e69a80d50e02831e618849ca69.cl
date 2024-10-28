//{"blk":5,"block_width":6,"cols":3,"input_itemsets_d":1,"input_itemsets_l":11,"offset":10,"offset_c":9,"offset_r":8,"output_itemsets_d":2,"penalty":4,"reference_d":0,"reference_l":12,"worksize":7}
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

kernel void nw_kernel2_gpu(global int* reference_d, global int* input_itemsets_d, global int* output_itemsets_d,

                           int cols, int penalty, int blk, int block_width, int worksize, int offset_r, int offset_c, int offset) {
  local int input_itemsets_l[(32 + 1) * (32 + 1)];
  local int reference_l[32 * 32];

  int bx = offset + get_group_id(0);

  int tx = get_local_id(0);

  int base = offset_r * cols + offset_c;

  int b_index_x = bx + block_width - blk;
  int b_index_y = block_width - bx - 1;

  int index = base + cols * 32 * b_index_y + 32 * b_index_x + tx + (cols + 1);
  int index_n = base + cols * 32 * b_index_y + 32 * b_index_x + tx + (1);
  int index_w = base + cols * 32 * b_index_y + 32 * b_index_x + (cols);
  int index_nw = base + cols * 32 * b_index_y + 32 * b_index_x;

  if (tx == 0)
    input_itemsets_l[hook(11, 0 + tx * (32 + 1))] = input_itemsets_d[hook(1, index_nw)];

  for (int ty = 0; ty < 32; ty++)
    reference_l[hook(12, tx + ty * 32)] = reference_d[hook(0, index + cols * ty)];

  barrier(0x01);

  input_itemsets_l[hook(11, 0 + (tx + 1) * (32 + 1))] = input_itemsets_d[hook(1, index_w + cols * tx)];

  barrier(0x01);

  input_itemsets_l[hook(11, (tx + 1) + 0 * (32 + 1))] = input_itemsets_d[hook(1, index_n)];

  barrier(0x01);

  for (int m = 0; m < 32; m++) {
    if (tx <= m) {
      int t_index_x = tx + 1;
      int t_index_y = m - tx + 1;

      input_itemsets_l[hook(11, t_index_x + t_index_y * (32 + 1))] = maximum(input_itemsets_l[hook(11, (t_index_x - 1) + (t_index_y - 1) * (32 + 1))] + reference_l[hook(12, (t_index_x - 1) + (t_index_y - 1) * 32)], input_itemsets_l[hook(11, (t_index_x - 1) + (t_index_y) * (32 + 1))] - (penalty), input_itemsets_l[hook(11, (t_index_x) + (t_index_y - 1) * (32 + 1))] - (penalty));
    }
    barrier(0x01);
  }

  for (int m = 32 - 2; m >= 0; m--) {
    if (tx <= m) {
      int t_index_x = tx + 32 - m;
      int t_index_y = 32 - tx;

      input_itemsets_l[hook(11, t_index_x + t_index_y * (32 + 1))] = maximum(input_itemsets_l[hook(11, (t_index_x - 1) + (t_index_y - 1) * (32 + 1))] + reference_l[hook(12, (t_index_x - 1) + (t_index_y - 1) * 32)], input_itemsets_l[hook(11, (t_index_x - 1) + (t_index_y) * (32 + 1))] - (penalty), input_itemsets_l[hook(11, (t_index_x) + (t_index_y - 1) * (32 + 1))] - (penalty));
    }

    barrier(0x01);
  }

  for (int ty = 0; ty < 32; ty++)
    input_itemsets_d[hook(1, index + ty * cols)] = input_itemsets_l[hook(11, (tx + 1) + (ty + 1) * (32 + 1))];

  return;
}