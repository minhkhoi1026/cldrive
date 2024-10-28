//{"cdata_weight":13,"cdisp_step1":11,"cdisp_step2":12,"channels":8,"cimg_step":15,"cleft":2,"cmax_data_term":14,"cmsg_step1":9,"cmsg_step2":10,"cright":3,"cth":16,"data_cost":20,"data_cost_":1,"h":4,"left":17,"level":6,"nr_plane":7,"right":18,"selected_disp_pyr":0,"selected_disparity":19,"w":5}
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

kernel void compute_data_cost_0(global const short* selected_disp_pyr, global short* data_cost_, global uchar* cleft, global uchar* cright, int h, int w, int level, int nr_plane, int channels, int cmsg_step1, int cmsg_step2, int cdisp_step1, int cdisp_step2, float cdata_weight, float cmax_data_term, int cimg_step, int cth) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < h && x < w) {
    int y0 = y << level;
    int yt = (y + 1) << level;

    int x0 = x << level;
    int xt = (x + 1) << level;

    global const short* selected_disparity = selected_disp_pyr + y / 2 * cmsg_step2 + x / 2;
    global short* data_cost = data_cost_ + y * cmsg_step1 + x;

    for (int d = 0; d < nr_plane; d++) {
      float val = 0.0f;
      for (int yi = y0; yi < yt; yi++) {
        for (int xi = x0; xi < xt; xi++) {
          int sel_disp = selected_disparity[hook(19, d * cdisp_step2)];
          int xr = xi - sel_disp;

          if (xr < 0 || sel_disp < cth)
            val += cdata_weight * cmax_data_term;

          else {
            global uchar* left_x = cleft + yi * cimg_step + xi * channels;
            global uchar* right_x = cright + yi * cimg_step + xr * channels;

            if (channels == 1)
              val += compute_1(left_x, right_x, cdata_weight, cmax_data_term);
            else
              val += compute_3(left_x, right_x, cdata_weight, cmax_data_term);
          }
        }
      }
      data_cost[hook(20, cdisp_step1 * d)] = convert_short_sat_rte(val);
    }
  }
}