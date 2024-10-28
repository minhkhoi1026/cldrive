//{"cdisc_single_jump":14,"cdisp_step1":12,"cmax_disc_term":11,"cmsg_step1":13,"ctemp":6,"d_":1,"d_cur":24,"d_new":23,"data":29,"data_cost_cur":18,"data_cost_new":17,"data_cost_selected":4,"disparity_selected_cur":20,"disparity_selected_new":19,"dst_disp":35,"h":7,"i":10,"l_":2,"l_cur":26,"l_new":25,"left":15,"msg1":30,"msg2":31,"msg3":32,"msg_dst":33,"nr_plane":9,"r_":3,"r_cur":28,"r_new":27,"right":16,"selected_disp_pyr_cur":5,"src_disp":34,"temp":36,"u_":0,"u_cur":22,"u_new":21,"w":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(15, 0)] - right[hook(16, 0)]);
  float tg = 0.587f * abs((int)left[hook(15, 1)] - right[hook(16, 1)]);
  float tr = 0.299f * abs((int)left[hook(15, 2)] - right[hook(16, 2)]);

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
      short cur = data_cost_new[hook(17, j * cdisp_step1)];
      if (cur < minimum) {
        minimum = cur;
        id = j;
      }
    }

    data_cost_selected[hook(4, i * cdisp_step1)] = data_cost_cur[hook(18, id * cdisp_step1)];
    disparity_selected_new[hook(19, i * cdisp_step1)] = disparity_selected_cur[hook(20, id * cdisp_step2)];

    u_new[hook(21, i * cdisp_step1)] = u_cur[hook(22, id * cdisp_step2)];
    d_new[hook(23, i * cdisp_step1)] = d_cur[hook(24, id * cdisp_step2)];
    l_new[hook(25, i * cdisp_step1)] = l_cur[hook(26, id * cdisp_step2)];
    r_new[hook(27, i * cdisp_step1)] = r_cur[hook(28, id * cdisp_step2)];

    data_cost_new[hook(17, id * cdisp_step1)] = 32767;
  }
}

inline void message_per_pixel_0(global const short* data, global short* msg_dst, global const short* msg1, global const short* msg2, global const short* msg3, global const short* dst_disp, global const short* src_disp, int nr_plane, global short* temp, float cmax_disc_term, int cdisp_step1, float cdisc_single_jump) {
  short minimum = 32767;
  for (int d = 0; d < nr_plane; d++) {
    int idx = d * cdisp_step1;
    short val = data[hook(29, idx)] + msg1[hook(30, idx)] + msg2[hook(31, idx)] + msg3[hook(32, idx)];

    if (val < minimum)
      minimum = val;

    msg_dst[hook(33, idx)] = val;
  }

  float sum = 0;
  for (int d = 0; d < nr_plane; d++) {
    float cost_min = minimum + cmax_disc_term;
    short src_disp_reg = src_disp[hook(34, d * cdisp_step1)];

    for (int d2 = 0; d2 < nr_plane; d2++)
      cost_min = fmin(cost_min, (msg_dst[hook(33, d2 * cdisp_step1)] + cdisc_single_jump * abs(dst_disp[hook(35, d2 * cdisp_step1)] - src_disp_reg)));

    temp[hook(36, d * cdisp_step1)] = convert_short_sat_rte(cost_min);
    sum += cost_min;
  }
  sum /= nr_plane;

  for (int d = 0; d < nr_plane; d++)
    msg_dst[hook(33, d * cdisp_step1)] = convert_short_sat_rte(temp[hook(36, d * cdisp_step1)] - sum);
}

inline void message_per_pixel_1(global const float* data, global float* msg_dst, global const float* msg1, global const float* msg2, global const float* msg3, global const float* dst_disp, global const float* src_disp, int nr_plane, global float* temp, float cmax_disc_term, int cdisp_step1, float cdisc_single_jump) {
  float minimum = 0x1.fffffep127f;
  for (int d = 0; d < nr_plane; d++) {
    int idx = d * cdisp_step1;
    float val = data[hook(29, idx)] + msg1[hook(30, idx)] + msg2[hook(31, idx)] + msg3[hook(32, idx)];

    if (val < minimum)
      minimum = val;

    msg_dst[hook(33, idx)] = val;
  }

  float sum = 0;
  for (int d = 0; d < nr_plane; d++) {
    float cost_min = minimum + cmax_disc_term;
    float src_disp_reg = src_disp[hook(34, d * cdisp_step1)];

    for (int d2 = 0; d2 < nr_plane; d2++)
      cost_min = fmin(cost_min, (msg_dst[hook(33, d2 * cdisp_step1)] + cdisc_single_jump * fabs(dst_disp[hook(35, d2 * cdisp_step1)] - src_disp_reg)));

    temp[hook(36, d * cdisp_step1)] = cost_min;
    sum += cost_min;
  }
  sum /= nr_plane;

  for (int d = 0; d < nr_plane; d++)
    msg_dst[hook(33, d * cdisp_step1)] = temp[hook(36, d * cdisp_step1)] - sum;
}

kernel void compute_message_1(global float* u_, global float* d_, global float* l_, global float* r_, global const float* data_cost_selected, global const float* selected_disp_pyr_cur, global float* ctemp, int h, int w, int nr_plane, int i, float cmax_disc_term, int cdisp_step1, int cmsg_step1, float cdisc_single_jump) {
  int y = get_global_id(1);
  int x = ((get_global_id(0)) << 1) + ((y + i) & 1);

  if (y > 0 && y < h - 1 && x > 0 && x < w - 1) {
    global const float* data = data_cost_selected + y * cmsg_step1 + x;

    global float* u = u_ + y * cmsg_step1 + x;
    global float* d = d_ + y * cmsg_step1 + x;
    global float* l = l_ + y * cmsg_step1 + x;
    global float* r = r_ + y * cmsg_step1 + x;

    global const float* disp = selected_disp_pyr_cur + y * cmsg_step1 + x;
    global float* temp = ctemp + y * cmsg_step1 + x;

    message_per_pixel_1(data, u, r - 1, u + cmsg_step1, l + 1, disp, disp - cmsg_step1, nr_plane, temp, cmax_disc_term, cdisp_step1, cdisc_single_jump);
    message_per_pixel_1(data, d, d - cmsg_step1, r - 1, l + 1, disp, disp + cmsg_step1, nr_plane, temp, cmax_disc_term, cdisp_step1, cdisc_single_jump);
    message_per_pixel_1(data, l, u + cmsg_step1, d - cmsg_step1, l + 1, disp, disp - 1, nr_plane, temp, cmax_disc_term, cdisp_step1, cdisc_single_jump);
    message_per_pixel_1(data, r, u + cmsg_step1, d - cmsg_step1, r - 1, disp, disp + 1, nr_plane, temp, cmax_disc_term, cdisp_step1, cdisc_single_jump);
  }
}