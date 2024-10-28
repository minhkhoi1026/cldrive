//{"BtoA_similarities":3,"BtoA_temp":4,"BtoA_temp_global":5,"delta":8,"fv_length":6,"global_sim":0,"graph_a":1,"graph_b":2,"graph_b_size":7,"num_threads":9,"work_group_size":10,"work_groups":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fsk(global int* global_sim, global const float* graph_a, global const float* graph_b, global float* BtoA_similarities, global float* BtoA_temp, global float* BtoA_temp_global, const int fv_length, const int graph_b_size, const float delta, const int num_threads, const int work_group_size, const int work_groups) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  if (gid < num_threads) {
    float curr_min = 1.0;
    int fva_start = gid * fv_length;

    for (int j = 0; j < graph_b_size; j++) {
      float distance = 0.0;
      int fvb_start = j * fv_length;
      for (int k = 0, fv_a = fva_start; k < fv_length; k++, fv_a++) {
        int fv_b = fvb_start + k;

        float fv_max = graph_b[hook(2, fv_b)];
        if (graph_a[hook(1, fv_a)] > graph_b[hook(2, fv_b)]) {
          fv_max = graph_a[hook(1, fv_a)];
        }
        if (fv_max < 1.0) {
          fv_max = 1.0;
        }

        distance += fabs(graph_a[hook(1, fv_a)] - graph_b[hook(2, fv_b)]) / fv_max;
      }

      float curr_sim = distance / fv_length;
      if (curr_sim < curr_min) {
        curr_min = curr_sim;
      }

      BtoA_temp[hook(4, gid)] = curr_sim;

      barrier(0x02);

      if (lid == 0) {
        float local_sim = 1.0;
        for (int local_i = 0; local_i < work_group_size; local_i++) {
          if (gid + local_i < num_threads) {
            if (BtoA_temp[hook(4, gid + local_i)] < local_sim) {
              local_sim = BtoA_temp[hook(4, gid + local_i)];
            }
          }
        }
        int global_index = (int)(gid / work_group_size);
        BtoA_temp_global[hook(5, global_index)] = local_sim;
      }

      barrier(0x02);

      if (gid == 0) {
        float synch_sim = 1.0;
        for (int i = 0; i < work_groups; i++) {
          if (BtoA_temp_global[hook(5, i)] < synch_sim) {
            synch_sim = BtoA_temp_global[hook(5, i)];
          }
        }
        BtoA_similarities[hook(3, j)] = synch_sim;
      }

      barrier(0x02);
    }

    if (curr_min < delta) {
      atomic_add(global_sim, 1);
    }
  }
}