//{"cdata_weight":12,"cdisp_step1":15,"channels":9,"cimg_step":11,"cleft":1,"cmax_data_term":13,"cmsg_step1":16,"cndisp":10,"cols":6,"cright":2,"ctemp":0,"cth":14,"data_cost":21,"dline":19,"h":7,"left":17,"level":4,"right":18,"rows":5,"smem":3,"vdline":20,"winsz":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(17, 0)] - right[hook(18, 0)]);
  float tg = 0.587f * abs((int)left[hook(17, 1)] - right[hook(18, 1)]);
  float tr = 0.299f * abs((int)left[hook(17, 2)] - right[hook(18, 2)]);

  return fmin(cdata_weight * (tr + tg + tb), cdata_weight * cmax_data_term);
}

inline float compute_1(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  return fmin(cdata_weight * abs((int)*left - (int)*right), cdata_weight * cmax_data_term);
}

inline short round_short(float v) {
  return convert_short_sat_rte(v);
}

kernel void init_data_cost_reduce_1(global float* ctemp, global uchar* cleft, global uchar* cright, local float* smem, int level, int rows, int cols, int h, int winsz, int channels, int cndisp, int cimg_step, float cdata_weight, float cmax_data_term, int cth, int cdisp_step1, int cmsg_step1) {
  int x_out = get_group_id(0);
  int y_out = get_group_id(1) % h;
  int d = (get_group_id(1) / h) * get_local_size(2) + get_local_id(2);

  int tid = get_local_id(0);

  if (d < cndisp) {
    int x0 = x_out << level;
    int y0 = y_out << level;

    int len = min(y0 + winsz, rows) - y0;

    float val = 0.0f;

    if (x0 + tid < cols) {
      if (x0 + tid - d < 0 || d < cth)
        val = cdata_weight * cmax_data_term * len;
      else {
        global uchar* lle = cleft + y0 * cimg_step + channels * (x0 + tid);
        global uchar* lri = cright + y0 * cimg_step + channels * (x0 + tid - d);

        for (int y = 0; y < len; ++y) {
          if (channels == 1)
            val += compute_1(lle, lri, cdata_weight, cmax_data_term);
          else
            val += compute_3(lle, lri, cdata_weight, cmax_data_term);

          lle += cimg_step;
          lri += cimg_step;
        }
      }
    }

    local float* dline = smem + winsz * get_local_id(2);

    dline[hook(19, tid)] = val;
  }
  barrier(0x01);

  if (d < cndisp) {
    local float* dline = smem + winsz * get_local_id(2);
    if (winsz >= 256)
      if (tid < 128)
        dline[hook(19, tid)] += dline[hook(19, tid + 128)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local float* dline = smem + winsz * get_local_id(2);
    if (winsz >= 128)
      if (tid < 64)
        dline[hook(19, tid)] += dline[hook(19, tid + 64)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 64)
      if (tid < 32)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 32)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 32)
      if (tid < 16)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 16)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 16)
      if (tid < 8)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 8)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 8)
      if (tid < 4)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 4)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 4)
      if (tid < 2)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 2)];
  }
  barrier(0x01);

  if (d < cndisp) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 2)
      if (tid < 1)
        vdline[hook(20, tid)] += vdline[hook(20, tid + 1)];
  }
  barrier(0x01);

  if (d < cndisp) {
    global float* data_cost = ctemp + y_out * cmsg_step1 + x_out;
    local float* dline = smem + winsz * get_local_id(2);
    if (tid == 0)
      data_cost[hook(21, cdisp_step1 * d)] = dline[hook(19, 0)];
  }
}