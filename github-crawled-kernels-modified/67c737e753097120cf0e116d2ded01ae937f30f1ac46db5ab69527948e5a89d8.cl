//{"cols":5,"dataCount":4,"globalHist":3,"hist_step":7,"inc_x":6,"inc_y":7,"left_col":4,"rows":6,"src":0,"src_offset":2,"src_step":1,"subhist":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size((256), 1, 1))) void calc_sub_hist_D0(global const uint4* src, int src_step, int src_offset, global int* globalHist, int dataCount, int cols, int inc_x, int inc_y, int hist_step) {
  local int subhist[((256) << (4))];
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int gx = get_group_id(0);
  int gsize = get_global_size(0);
  int lsize = get_local_size(0);
  const int shift = 8;
  const int mask = (256) - 1;
  int offset = (lid & ((16) - 1));
  uint4 data, temp1, temp2, temp3, temp4;
  src += src_offset;

  for (int i = 0, idx = lid; i < ((16) >> 2); i++, idx += lsize) {
    subhist[hook(11, idx)] = 0;
    subhist[hook(11, idx += lsize)] = 0;
    subhist[hook(11, idx += lsize)] = 0;
    subhist[hook(11, idx += lsize)] = 0;
  }
  barrier(0x01);

  int y = gid / cols;
  int x = gid - mul24(y, cols);
  for (int idx = gid; idx < dataCount; idx += gsize) {
    data = src[hook(0, mad24(y, src_step, x))];
    temp1 = ((data & mask) << (4)) + offset;
    data >>= shift;
    temp2 = ((data & mask) << (4)) + offset;
    data >>= shift;
    temp3 = ((data & mask) << (4)) + offset;
    data >>= shift;
    temp4 = ((data & mask) << (4)) + offset;

    atomic_inc(subhist + temp1.x);
    atomic_inc(subhist + temp1.y);
    atomic_inc(subhist + temp1.z);
    atomic_inc(subhist + temp1.w);

    atomic_inc(subhist + temp2.x);
    atomic_inc(subhist + temp2.y);
    atomic_inc(subhist + temp2.z);
    atomic_inc(subhist + temp2.w);

    atomic_inc(subhist + temp3.x);
    atomic_inc(subhist + temp3.y);
    atomic_inc(subhist + temp3.z);
    atomic_inc(subhist + temp3.w);

    atomic_inc(subhist + temp4.x);
    atomic_inc(subhist + temp4.y);
    atomic_inc(subhist + temp4.z);
    atomic_inc(subhist + temp4.w);

    x += inc_x;
    int off = ((x >= cols) ? -1 : 0);
    x = mad24(off, cols, x);
    y += inc_y - off;
  }
  barrier(0x01);

  int bin1 = 0, bin2 = 0, bin3 = 0, bin4 = 0;
  for (int i = 0; i < (16); i += 4) {
    bin1 += subhist[hook(11, (lid << (4)) + i)];
    bin2 += subhist[hook(11, (lid << (4)) + i + 1)];
    bin3 += subhist[hook(11, (lid << (4)) + i + 2)];
    bin4 += subhist[hook(11, (lid << (4)) + i + 3)];
  }

  globalHist[hook(3, mad24(gx, hist_step, lid))] = bin1 + bin2 + bin3 + bin4;
}

kernel void __attribute__((reqd_work_group_size(1, (256), 1))) calc_sub_hist_border_D0(global const uchar* src, int src_step, int src_offset, global int* globalHist, int left_col, int cols, int rows, int hist_step) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int lidy = get_local_id(1);
  int gx = get_group_id(0);
  int gy = get_group_id(1);
  int gn = get_num_groups(0);
  int rowIndex = mad24(gy, gn, gx);

  local int subhist[((256))];
  subhist[hook(11, lidy)] = 0;
  barrier(0x01);

  gidx = ((gidx >= left_col) ? (gidx + cols) : gidx);
  if (gidy < rows) {
    int src_index = src_offset + mad24(gidy, src_step, gidx);
    int p = (int)src[hook(0, src_index)];

    atomic_inc(subhist + p);
  }
  barrier(0x01);

  globalHist[hook(3, mad24(rowIndex, hist_step, lidy))] += subhist[hook(11, lidy)];
}