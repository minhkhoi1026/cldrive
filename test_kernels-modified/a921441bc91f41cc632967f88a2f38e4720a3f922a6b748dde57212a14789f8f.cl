//{"blank":5,"in_data":2,"in_offset":3,"merge_repeated":6,"num_threads":7,"out_data":0,"out_offset":1,"seq_num":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CtcAlign(global float* out_data, global int* out_offset, global const float* in_data, global const int* in_offset, const int seq_num, const int blank, const int merge_repeated, const int num_threads) {
  int tid = get_global_id(0);

  if (tid == 0) {
    int index = 0;

    for (int seq_id = 0; seq_id < seq_num; seq_id++) {
      float prev_token = -1;
      out_offset[hook(1, seq_id)] = index;

      for (int i = in_offset[hook(3, seq_id)]; i < in_offset[hook(3, seq_id + 1)]; i++) {
        if (in_data[hook(2, i)] != blank && !(merge_repeated && in_data[hook(2, i)] == prev_token)) {
          out_data[hook(0, index++)] = in_data[hook(2, i)];
          prev_token = in_data[hook(2, i)];
        }
      }
    }

    out_offset[hook(1, seq_num)] = index;
  }
}