//{"cdisp_step1":19,"cdisp_step2":20,"cmsg_step1":21,"cmsg_step2":22,"ctemp":8,"d_cur":33,"d_cur_":5,"d_new":32,"d_new_":1,"data_cost":38,"data_cost_":12,"data_cost_cur":27,"data_cost_new":25,"data_cost_selected":26,"data_cost_selected_":11,"disparity_selected_cur":29,"disparity_selected_new":28,"h":13,"h2":16,"l_cur":35,"l_cur_":6,"l_new":34,"l_new_":2,"left":23,"nr_plane":15,"nr_plane2":18,"r_cur":37,"r_cur_":7,"r_new":36,"r_new_":3,"right":24,"selected_disp_pyr_cur":10,"selected_disp_pyr_new":9,"u_cur":31,"u_cur_":4,"u_new":30,"u_new_":0,"w":14,"w2":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float compute_3(global uchar* left, global uchar* right, float cdata_weight, float cmax_data_term) {
  float tb = 0.114f * abs((int)left[hook(23, 0)] - right[hook(24, 0)]);
  float tg = 0.587f * abs((int)left[hook(23, 1)] - right[hook(24, 1)]);
  float tr = 0.299f * abs((int)left[hook(23, 2)] - right[hook(24, 2)]);

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
      short cur = data_cost_new[hook(25, j * cdisp_step1)];
      if (cur < minimum) {
        minimum = cur;
        id = j;
      }
    }

    data_cost_selected[hook(26, i * cdisp_step1)] = data_cost_cur[hook(27, id * cdisp_step1)];
    disparity_selected_new[hook(28, i * cdisp_step1)] = disparity_selected_cur[hook(29, id * cdisp_step2)];

    u_new[hook(30, i * cdisp_step1)] = u_cur[hook(31, id * cdisp_step2)];
    d_new[hook(32, i * cdisp_step1)] = d_cur[hook(33, id * cdisp_step2)];
    l_new[hook(34, i * cdisp_step1)] = l_cur[hook(35, id * cdisp_step2)];
    r_new[hook(36, i * cdisp_step1)] = r_cur[hook(37, id * cdisp_step2)];

    data_cost_new[hook(25, id * cdisp_step1)] = 32767;
  }
}

kernel void init_message_0(global short* u_new_, global short* d_new_, global short* l_new_, global short* r_new_, global short* u_cur_, global const short* d_cur_, global const short* l_cur_, global const short* r_cur_, global short* ctemp, global short* selected_disp_pyr_new, global const short* selected_disp_pyr_cur, global short* data_cost_selected_, global const short* data_cost_, int h, int w, int nr_plane, int h2, int w2, int nr_plane2, int cdisp_step1, int cdisp_step2, int cmsg_step1, int cmsg_step2) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < h && x < w) {
    global const short* u_cur = u_cur_ + min(h2 - 1, y / 2 + 1) * cmsg_step2 + x / 2;
    global const short* d_cur = d_cur_ + max(0, y / 2 - 1) * cmsg_step2 + x / 2;
    global const short* l_cur = l_cur_ + y / 2 * cmsg_step2 + min(w2 - 1, x / 2 + 1);
    global const short* r_cur = r_cur_ + y / 2 * cmsg_step2 + max(0, x / 2 - 1);

    global short* data_cost_new = ctemp + y * cmsg_step1 + x;

    global const short* disparity_selected_cur = selected_disp_pyr_cur + y / 2 * cmsg_step2 + x / 2;
    global const short* data_cost = data_cost_ + y * cmsg_step1 + x;

    for (int d = 0; d < nr_plane2; d++) {
      int idx2 = d * cdisp_step2;

      short val = data_cost[hook(38, d * cdisp_step1)] + u_cur[hook(31, idx2)] + d_cur[hook(33, idx2)] + l_cur[hook(35, idx2)] + r_cur[hook(37, idx2)];
      data_cost_new[hook(25, d * cdisp_step1)] = val;
    }

    global short* data_cost_selected = data_cost_selected_ + y * cmsg_step1 + x;
    global short* disparity_selected_new = selected_disp_pyr_new + y * cmsg_step1 + x;

    global short* u_new = u_new_ + y * cmsg_step1 + x;
    global short* d_new = d_new_ + y * cmsg_step1 + x;
    global short* l_new = l_new_ + y * cmsg_step1 + x;
    global short* r_new = r_new_ + y * cmsg_step1 + x;

    u_cur = u_cur_ + y / 2 * cmsg_step2 + x / 2;
    d_cur = d_cur_ + y / 2 * cmsg_step2 + x / 2;
    l_cur = l_cur_ + y / 2 * cmsg_step2 + x / 2;
    r_cur = r_cur_ + y / 2 * cmsg_step2 + x / 2;

    get_first_k_element_increase_0(u_new, d_new, l_new, r_new, u_cur, d_cur, l_cur, r_cur, data_cost_selected, disparity_selected_new, data_cost_new, data_cost, disparity_selected_cur, nr_plane, nr_plane2, cdisp_step1, cdisp_step2);
  }
}