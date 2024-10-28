//{"coarse_match_length":5,"coarse_match_threshold":6,"current_position":7,"device_batch_result":2,"device_query":1,"device_target":0,"length":3,"query_sequence_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ga_cl12(global char* device_target, global char* device_query, global char* device_batch_result, unsigned int length, int query_sequence_length, int coarse_match_length, int coarse_match_threshold, int current_position) {
  size_t tid = get_global_id(0);
  if (tid > length)
    return;

  bool match = false;
  int max_length = query_sequence_length - coarse_match_length;

  for (int i = 0; i <= max_length; i++) {
    int distance = 0;
    for (int j = 0; j < coarse_match_length; j++) {
      if (device_target[hook(0, current_position + tid + j)] != device_query[hook(1, i + j)]) {
        distance++;
      }
    }

    if (distance < coarse_match_threshold) {
      match = true;
      break;
    }
  }
  if (match) {
    device_batch_result[hook(2, tid)] = 1;
  }
}