//{"cdisp_step1":12,"cmsg_step1":11,"cols":8,"d":36,"d_":1,"d_cur":22,"d_new":21,"data":27,"data_cost_cur":16,"data_cost_new":15,"data_cost_selected":4,"disp":6,"disp_selected":39,"disp_selected_pyr":5,"disparity_selected_cur":18,"disparity_selected_new":17,"dst_disp":33,"l":37,"l_":2,"l_cur":24,"l_new":23,"left":13,"msg1":28,"msg2":29,"msg3":30,"msg_dst":31,"nr_plane":10,"r":38,"r_":3,"r_cur":26,"r_new":25,"res_step":7,"right":14,"rows":9,"src_disp":32,"temp":34,"u":35,"u_":0,"u_cur":20,"u_new":19}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(13, 0)] - right[hook(14, 0)]);
  float tg = 0.587f * abs((int)left[hook(13, 1)] - right[hook(14, 1)]);
  float tr = 0.299f * abs((int)left[hook(13, 2)] - right[hook(14, 2)]);

  return fmin(cdata_weight * (tr + tg + tb), cdata_weight * cmax_data_term);
}

inline float compute_1(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  return fmin(cdata_weight * abs((int)*left - (int)*right), cdata_weight * cmax_data_term);
}

inline short round_short(float v) {
  return convert_short_sat_rte(v);
}

inline void get_first_k_element_increase_0(global short* u_new, global short* d_new, global short* l_new, global short* r_new, global const short* u_cur, global const short* d_cur, global const short* l_cur, global const short* r_cur, global short* data_cost_selected, global short* disparity_selected_new, global short* data_cost_new, global const short* data_cost_cur, global const short* disparity_selected_cur, int nr_plane, int nr_plane2, int cdisp_step1, int cdisp_step2) {
  for (int i = 0; i < nr_plane; i++) {
    short minimum = 32767;
    int id = 0;
    for (int j = 0; j < nr_plane2; j++) {
      short cur = data_cost_new[hook(15, j * cdisp_step1)];
      if (cur < minimum) {
        minimum = cur;
        id = j;
      }
    }

    data_cost_selected[hook(4, i * cdisp_step1)] = data_cost_cur[hook(16, id * cdisp_step1)];
    disparity_selected_new[hook(17, i * cdisp_step1)] = disparity_selected_cur[hook(18, id * cdisp_step2)];

    u_new[hook(19, i * cdisp_step1)] = u_cur[hook(20, id * cdisp_step2)];
    d_new[hook(21, i * cdisp_step1)] = d_cur[hook(22, id * cdisp_step2)];
    l_new[hook(23, i * cdisp_step1)] = l_cur[hook(24, id * cdisp_step2)];
    r_new[hook(25, i * cdisp_step1)] = r_cur[hook(26, id * cdisp_step2)];

    data_cost_new[hook(15, id * cdisp_step1)] = 32767;
  }
}

inline void message_per_pixel_0(global const short* data, global short* msg_dst, global const short* msg1, global const short* msg2, global const short* msg3, global const short* dst_disp, global const short* src_disp, int nr_plane, global short* temp, float cmax_disc_term, int cdisp_step1, float cdisc_single_jump) {
  short minimum = 32767;
  for (int d = 0; d < nr_plane; d++) {
    int idx = d * cdisp_step1;
    short val = data[hook(27, idx)] + msg1[hook(28, idx)] + msg2[hook(29, idx)] + msg3[hook(30, idx)];

    if (val < minimum)
      minimum = val;

    msg_dst[hook(31, idx)] = val;
  }

  float sum = 0;
  for (int d = 0; d < nr_plane; d++) {
    float cost_min = minimum + cmax_disc_term;
    short src_disp_reg = src_disp[hook(32, d * cdisp_step1)];

    for (int d2 = 0; d2 < nr_plane; d2++)
      cost_min = fmin(cost_min, (msg_dst[hook(31, d2 * cdisp_step1)] + cdisc_single_jump * abs(dst_disp[hook(33, d2 * cdisp_step1)] - src_disp_reg)));

    temp[hook(34, d * cdisp_step1)] = convert_short_sat_rte(cost_min);
    sum += cost_min;
  }
  sum /= nr_plane;

  for (int d = 0; d < nr_plane; d++)
    msg_dst[hook(31, d * cdisp_step1)] = convert_short_sat_rte(temp[hook(34, d * cdisp_step1)] - sum);
}

inline void message_per_pixel_1(global const float* data, global float* msg_dst, global const float* msg1, global const float* msg2, global const float* msg3, global const float* dst_disp, global const float* src_disp, int nr_plane, global float* temp, float cmax_disc_term, int cdisp_step1, float cdisc_single_jump) {
  float minimum = 0x1.fffffep127f;
  for (int d = 0; d < nr_plane; d++) {
    int idx = d * cdisp_step1;
    float val = data[hook(27, idx)] + msg1[hook(28, idx)] + msg2[hook(29, idx)] + msg3[hook(30, idx)];

    if (val < minimum)
      minimum = val;

    msg_dst[hook(31, idx)] = val;
  }

  float sum = 0;
  for (int d = 0; d < nr_plane; d++) {
    float cost_min = minimum + cmax_disc_term;
    float src_disp_reg = src_disp[hook(32, d * cdisp_step1)];

    for (int d2 = 0; d2 < nr_plane; d2++)
      cost_min = fmin(cost_min, (msg_dst[hook(31, d2 * cdisp_step1)] + cdisc_single_jump * fabs(dst_disp[hook(33, d2 * cdisp_step1)] - src_disp_reg)));

    temp[hook(34, d * cdisp_step1)] = cost_min;
    sum += cost_min;
  }
  sum /= nr_plane;

  for (int d = 0; d < nr_plane; d++)
    msg_dst[hook(31, d * cdisp_step1)] = temp[hook(34, d * cdisp_step1)] - sum;
}

kernel void compute_disp_0(global const short* u_, global const short* d_, global const short* l_, global const short* r_, global const short* data_cost_selected, global const short* disp_selected_pyr, global short* disp, int res_step, int cols, int rows, int nr_plane, int cmsg_step1, int cdisp_step1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y > 0 && y < rows - 1 && x > 0 && x < cols - 1) {
    global const short* data = data_cost_selected + y * cmsg_step1 + x;
    global const short* disp_selected = disp_selected_pyr + y * cmsg_step1 + x;

    global const short* u = u_ + (y + 1) * cmsg_step1 + (x + 0);
    global const short* d = d_ + (y - 1) * cmsg_step1 + (x + 0);
    global const short* l = l_ + (y + 0) * cmsg_step1 + (x + 1);
    global const short* r = r_ + (y + 0) * cmsg_step1 + (x - 1);

    short best = 0;
    short best_val = 32767;

    for (int i = 0; i < nr_plane; ++i) {
      int idx = i * cdisp_step1;
      short val = data[hook(27, idx)] + u[hook(35, idx)] + d[hook(36, idx)] + l[hook(37, idx)] + r[hook(38, idx)];

      if (val < best_val) {
        best_val = val;
        best = disp_selected[hook(39, idx)];
      }
    }
    disp[hook(6, res_step * y + x)] = best;
  }
}