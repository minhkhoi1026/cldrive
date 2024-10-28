//{"block_hist":19,"block_hists":12,"blocks_in_group":5,"blocks_total":6,"cblock_hist_size":3,"cblock_stride_x":0,"cblock_stride_y":1,"cnbins":2,"final_hist":18,"gauss_w_lut":11,"grad":9,"grad_ptr":15,"grad_quadstep":7,"hist":14,"hist_":17,"img_block_width":4,"qangle":10,"qangle_ptr":16,"qangle_step":8,"smem":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_hists_lut_kernel(const int cblock_stride_x, const int cblock_stride_y, const int cnbins, const int cblock_hist_size, const int img_block_width, const int blocks_in_group, const int blocks_total, const int grad_quadstep, const int qangle_step, global const float* grad, global const uchar* qangle, global const float* gauss_w_lut, global float* block_hists, local float* smem) {
  const int lx = get_local_id(0);
  const int lp = lx / 24;
  const int gid = get_group_id(0) * blocks_in_group + lp;
  const int gidY = gid / img_block_width;
  const int gidX = gid - gidY * img_block_width;

  const int lidX = lx - lp * 24;
  const int lidY = get_local_id(1);

  const int cell_x = lidX / 12;
  const int cell_y = lidY;
  const int cell_thread_x = lidX - cell_x * 12;

  local float* hists = smem + lp * cnbins * (2 * 2 * 12 + 2 * 2);
  local float* final_hist = hists + cnbins * (2 * 2 * 12);

  const int offset_x = gidX * cblock_stride_x + (cell_x << 2) + cell_thread_x;
  const int offset_y = gidY * cblock_stride_y + (cell_y << 2);

  global const float* grad_ptr = (gid < blocks_total) ? grad + offset_y * grad_quadstep + (offset_x << 1) : grad;
  global const uchar* qangle_ptr = (gid < blocks_total) ? qangle + offset_y * qangle_step + (offset_x << 1) : qangle;

  local float* hist = hists + 12 * (cell_y * 2 + cell_x) + cell_thread_x;
  for (int bin_id = 0; bin_id < cnbins; ++bin_id)
    hist[hook(14, bin_id * 48)] = 0.f;

  const int dist_x = -4 + cell_thread_x - 4 * cell_x;
  const int dist_center_x = dist_x - 4 * (1 - 2 * cell_x);

  const int dist_y_begin = -4 - 4 * lidY;
  for (int dist_y = dist_y_begin; dist_y < dist_y_begin + 12; ++dist_y) {
    float2 vote = (float2)(grad_ptr[hook(15, 0)], grad_ptr[hook(15, 1)]);
    uchar2 bin = (uchar2)(qangle_ptr[hook(16, 0)], qangle_ptr[hook(16, 1)]);

    grad_ptr += grad_quadstep;
    qangle_ptr += qangle_step;

    int dist_center_y = dist_y - 4 * (1 - 2 * cell_y);

    int idx = (dist_center_y + 8) * 16 + (dist_center_x + 8);
    float gaussian = gauss_w_lut[hook(11, idx)];
    idx = (dist_y + 8) * 16 + (dist_x + 8);
    float interp_weight = gauss_w_lut[hook(11, 256 + idx)];

    hist[hook(14, bin.x * 48)] += gaussian * interp_weight * vote.x;
    hist[hook(14, bin.y * 48)] += gaussian * interp_weight * vote.y;
  }
  barrier(0x01);

  volatile local float* hist_ = hist;
  for (int bin_id = 0; bin_id < cnbins; ++bin_id, hist_ += 48) {
    if (cell_thread_x < 6)
      hist_[hook(17, 0)] += hist_[hook(17, 6)];
    barrier(0x01);
    if (cell_thread_x < 3)
      hist_[hook(17, 0)] += hist_[hook(17, 3)];

    if (cell_thread_x == 0)
      final_hist[hook(18, (cell_x * 2 + cell_y) * cnbins + bin_id)] = hist_[hook(17, 0)] + hist_[hook(17, 1)] + hist_[hook(17, 2)];
  }

  int tid = (cell_y * 2 + cell_x) * 12 + cell_thread_x;
  if ((tid < cblock_hist_size) && (gid < blocks_total)) {
    global float* block_hist = block_hists + (gidY * img_block_width + gidX) * cblock_hist_size;
    block_hist[hook(19, tid)] = final_hist[hook(18, tid)];
  }
}