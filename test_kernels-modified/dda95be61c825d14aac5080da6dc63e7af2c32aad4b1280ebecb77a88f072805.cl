//{"blk":4,"block_width":5,"cols":2,"input_itemsets_d":1,"input_itemsets_l":8,"offset_c":7,"offset_r":6,"penalty":3,"similarity_d":0,"similarity_l":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int max3(int a, int b, int c) {
  int k = a > b ? a : b;
  return k > c ? k : c;
}

kernel void nw2(global int* similarity_d, global int* input_itemsets_d, int cols, int penalty, int blk, int block_width, int offset_r, int offset_c, local int* input_itemsets_l, local int* similarity_l) {
  int bx = get_group_id(0);

  int tx = get_local_id(0);

  int base = offset_r * cols + offset_c;
  int b_index_x = bx + block_width - blk;
  int b_index_y = block_width - bx - 1;
  int index_nw = base + cols * 32 * b_index_y + 32 * b_index_x;
  int index_w = index_nw + cols;
  int index_n = index_nw + tx + 1;
  int index = index_n + cols;
  if (tx == 0)
    input_itemsets_l[hook(8, tx * (32 + 1))] = input_itemsets_d[hook(1, index_nw)];
  for (int ty = 0; ty < 32; ++ty)
    similarity_l[hook(9, (ty) * 32 + (tx))] = similarity_d[hook(0, index + cols * ty)];
  barrier(0x01);
  input_itemsets_l[hook(8, (tx + 1) * (32 + 1))] = input_itemsets_d[hook(1, index_w + cols * tx)];
  barrier(0x01);
  input_itemsets_l[hook(8, (tx + 1))] = input_itemsets_d[hook(1, index_n)];
  barrier(0x01);
  for (int m = 0; m < 32; ++m) {
    if (tx <= m) {
      int t_index_x = tx + 1;
      int t_index_y = m - tx + 1;
      int match = input_itemsets_l[hook(8, (t_index_x - 1) + (t_index_y - 1) * (32 + 1))] + similarity_l[hook(9, (t_index_y - 1) * 32 + (t_index_x - 1))];
      int remove = input_itemsets_l[hook(8, (t_index_x - 1) + (t_index_y) * (32 + 1))] - penalty;
      int insert = input_itemsets_l[hook(8, (t_index_x) + (t_index_y - 1) * (32 + 1))] - penalty;
      input_itemsets_l[hook(8, (t_index_x) + (t_index_y) * (32 + 1))] = max3(match, remove, insert);
    }
    barrier(0x01);
  }
  for (int m = 32 - 2; m >= 0; --m) {
    if (tx <= m) {
      int t_index_x = tx + 32 - m;
      int t_index_y = 32 - tx;
      int match = input_itemsets_l[hook(8, (t_index_x - 1) + (t_index_y - 1) * (32 + 1))] + similarity_l[hook(9, (t_index_y - 1) * 32 + (t_index_x - 1))];
      int remove = input_itemsets_l[hook(8, (t_index_x - 1) + (t_index_y) * (32 + 1))] - penalty;
      int insert = input_itemsets_l[hook(8, (t_index_x) + (t_index_y - 1) * (32 + 1))] - penalty;
      input_itemsets_l[hook(8, (t_index_x) + (t_index_y) * (32 + 1))] = max3(match, remove, insert);
    }
    barrier(0x01);
  }
  for (int ty = 0; ty < 32; ++ty)
    input_itemsets_d[hook(1, index + ty * cols)] = input_itemsets_l[hook(8, (tx + 1) + (ty + 1) * (32 + 1))];
}