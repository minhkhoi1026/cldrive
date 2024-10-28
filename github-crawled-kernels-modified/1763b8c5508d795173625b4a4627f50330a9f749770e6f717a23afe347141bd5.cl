//{"cdata_weight":16,"cdisp_step1":14,"cdisp_step2":15,"channels":10,"cimg_step":18,"cleft":2,"cmax_data_term":17,"cmsg_step1":12,"cmsg_step2":13,"cols":7,"cright":3,"cth":19,"data_cost":25,"data_cost_":1,"dline":23,"h":8,"left":20,"level":5,"nr_plane":9,"right":21,"rows":6,"selected_disp_pyr":0,"selected_disparity":22,"smem":4,"vdline":24,"winsz":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(20, 0)] - right[hook(21, 0)]);
  float tg = 0.587f * abs((int)left[hook(20, 1)] - right[hook(21, 1)]);
  float tr = 0.299f * abs((int)left[hook(20, 2)] - right[hook(21, 2)]);

  return fmin(cdata_weight * (tr + tg + tb), cdata_weight * cmax_data_term);
}

inline float compute_1(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  return fmin(cdata_weight * abs((int)*left - (int)*right), cdata_weight * cmax_data_term);
}

inline short round_short(float v) {
  return convert_short_sat_rte(v);
}

kernel void compute_data_cost_reduce_1(global const float* selected_disp_pyr, global float* data_cost_, global uchar* cleft, global uchar* cright, local float* smem, int level, int rows, int cols, int h, int nr_plane, int channels, int winsz, int cmsg_step1, int cmsg_step2, int cdisp_step1, int cdisp_step2, float cdata_weight, float cmax_data_term, int cimg_step, int cth)

{
  int x_out = get_group_id(0);
  int y_out = get_group_id(1) % h;
  int d = (get_group_id(1) / h) * get_local_size(2) + get_local_id(2);

  int tid = get_local_id(0);

  global const float* selected_disparity = selected_disp_pyr + y_out / 2 * cmsg_step2 + x_out / 2;
  global float* data_cost = data_cost_ + y_out * cmsg_step1 + x_out;

  if (d < nr_plane) {
    int sel_disp = selected_disparity[hook(22, d * cdisp_step2)];

    int x0 = x_out << level;
    int y0 = y_out << level;

    int len = min(y0 + winsz, rows) - y0;

    float val = 0.0f;
    if (x0 + tid < cols) {
      if (x0 + tid - sel_disp < 0 || sel_disp < cth)
        val = cdata_weight * cmax_data_term * len;
      else {
        global uchar* lle = cleft + y0 * cimg_step + channels * (x0 + tid);
        global uchar* lri = cright + y0 * cimg_step + channels * (x0 + tid - sel_disp);

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

    dline[hook(23, tid)] = val;
  }

  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 64) {
      if (tid < 32)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 32)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 32) {
      if (tid < 16)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 16)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 16) {
      if (tid < 8)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 8)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 8) {
      if (tid < 4)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 4)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 4) {
      if (tid < 2)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 2)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (winsz >= 2) {
      if (tid < 1)
        vdline[hook(24, tid)] += vdline[hook(24, tid + 1)];
    }
  }
  barrier(0x01);

  if (d < nr_plane) {
    local volatile float* vdline = smem + winsz * get_local_id(2);
    if (tid == 0)
      data_cost[hook(25, cdisp_step1 * d)] = vdline[hook(24, 0)];
  }
}