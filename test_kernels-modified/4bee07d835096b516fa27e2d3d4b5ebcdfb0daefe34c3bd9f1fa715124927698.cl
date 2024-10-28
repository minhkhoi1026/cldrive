//{"all_weights":0,"best_params":1,"best_weights":2,"height_ori":3,"search_window_size":5,"width_ori":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_best_weights(global float* all_weights, global int* best_params, global float* best_weights, const int height_ori, const int width_ori, const int search_window_size) {
  const int tx = get_global_id(0);
  const int weights_size = search_window_size * search_window_size * height_ori * width_ori;

  if (tx < height_ori * width_ori) {
    const int best_idx = best_params[hook(1, tx)];
    for (int i = 0; i < search_window_size * search_window_size; i++) {
      best_weights[hook(2, i * height_ori * width_ori + tx)] = all_weights[hook(0, best_idx * weights_size + i * height_ori * width_ori + tx)];
    }
  }
}