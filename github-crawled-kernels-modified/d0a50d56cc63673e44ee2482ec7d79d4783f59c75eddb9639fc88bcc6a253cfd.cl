//{"cdata_weight":8,"cdisp_step1":10,"channels":6,"cimg_step":12,"cleft":1,"cmax_data_term":9,"cmsg_step1":7,"cndisp":13,"cright":2,"ctemp":0,"cth":11,"data_cost":16,"h":3,"left":14,"level":5,"right":15,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(14, 0)] - right[hook(15, 0)]);
  float tg = 0.587f * abs((int)left[hook(14, 1)] - right[hook(15, 1)]);
  float tr = 0.299f * abs((int)left[hook(14, 2)] - right[hook(15, 2)]);

  return fmin(cdata_weight * (tr + tg + tb), cdata_weight * cmax_data_term);
}

inline float compute_1(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  return fmin(cdata_weight * abs((int)*left - (int)*right), cdata_weight * cmax_data_term);
}

inline short round_short(float v) {
  return convert_short_sat_rte(v);
}

kernel void init_data_cost_0(global short* ctemp, global uchar* cleft, global uchar* cright, int h, int w, int level, int channels, int cmsg_step1, float cdata_weight, float cmax_data_term, int cdisp_step1, int cth, int cimg_step, int cndisp) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < h && x < w) {
    int y0 = y << level;
    int yt = (y + 1) << level;

    int x0 = x << level;
    int xt = (x + 1) << level;

    global short* data_cost = ctemp + y * cmsg_step1 + x;

    for (int d = 0; d < cndisp; ++d) {
      float val = 0.0f;
      for (int yi = y0; yi < yt; yi++) {
        for (int xi = x0; xi < xt; xi++) {
          int xr = xi - d;
          if (d < cth || xr < 0)
            val += cdata_weight * cmax_data_term;
          else {
            global uchar* lle = cleft + yi * cimg_step + xi * channels;
            global uchar* lri = cright + yi * cimg_step + xr * channels;

            if (channels == 1)
              val += compute_1(lle, lri, cdata_weight, cmax_data_term);
            else
              val += compute_3(lle, lri, cdata_weight, cmax_data_term);
          }
        }
      }
      data_cost[hook(16, cdisp_step1 * d)] = round_short(val);
    }
  }
}