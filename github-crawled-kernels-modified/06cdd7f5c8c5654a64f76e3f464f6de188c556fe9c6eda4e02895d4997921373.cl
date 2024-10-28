//{"cdisp_step1":7,"cmsg_step1":6,"cndisp":8,"ctemp":2,"data_cost":9,"data_cost_selected":10,"data_cost_selected_":0,"h":3,"nr_plane":5,"selected_disp_pyr":1,"selected_disparity":11,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_first_k_initial_local_1(global float* data_cost_selected_, global float* selected_disp_pyr, global float* ctemp, int h, int w, int nr_plane, int cmsg_step1, int cdisp_step1, int cndisp) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < h && x < w) {
    global float* selected_disparity = selected_disp_pyr + y * cmsg_step1 + x;
    global float* data_cost_selected = data_cost_selected_ + y * cmsg_step1 + x;
    global float* data_cost = ctemp + y * cmsg_step1 + x;

    int nr_local_minimum = 0;

    float prev = data_cost[hook(9, 0 * cdisp_step1)];
    float cur = data_cost[hook(9, 1 * cdisp_step1)];
    float next = data_cost[hook(9, 2 * cdisp_step1)];

    for (int d = 1; d < cndisp - 1 && nr_local_minimum < nr_plane; d++) {
      if (cur < prev && cur < next) {
        data_cost_selected[hook(10, nr_local_minimum * cdisp_step1)] = cur;
        selected_disparity[hook(11, nr_local_minimum * cdisp_step1)] = d;
        data_cost[hook(9, d * cdisp_step1)] = 0x1.fffffep127f;

        nr_local_minimum++;
      }

      prev = cur;
      cur = next;
      next = data_cost[hook(9, (d + 1) * cdisp_step1)];
    }

    for (int i = nr_local_minimum; i < nr_plane; i++) {
      float minimum = 0x1.fffffep127f;
      int id = 0;

      for (int d = 0; d < cndisp; d++) {
        cur = data_cost[hook(9, d * cdisp_step1)];
        if (cur < minimum) {
          minimum = cur;
          id = d;
        }
      }

      data_cost_selected[hook(10, i * cdisp_step1)] = minimum;
      selected_disparity[hook(11, i * cdisp_step1)] = id;
      data_cost[hook(9, id * cdisp_step1)] = 0x1.fffffep127f;
    }
  }
}