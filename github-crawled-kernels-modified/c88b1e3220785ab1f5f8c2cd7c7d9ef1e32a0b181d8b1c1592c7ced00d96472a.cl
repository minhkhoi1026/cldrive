//{"border_max":4,"height_overlap":2,"kullback_leiblers":1,"search_window_size":5,"similarities":0,"width_overlap":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void precompute_similarities_2nd_pass(global float* similarities, global float* kullback_leiblers, const int height_overlap, const int width_overlap, const int border_max, const int search_window_size) {
  const int h = get_global_id(0);
  const int w = get_global_id(1);

  const int wsh = (search_window_size - 1) / 2;

  const int height_sim = height_overlap - search_window_size + 1;
  const int width_sim = width_overlap - search_window_size + 1;

  if (h < height_sim && w < width_sim - border_max) {
    for (int hh = 0; hh < wsh; hh++) {
      for (int ww = 0; ww < search_window_size; ww++) {
        const int idx = hh * search_window_size * height_sim * width_sim + ww * height_sim * width_sim + h * width_sim + w;

        const int idx_sym = (search_window_size - 1 - hh) * search_window_size * height_sim * width_sim + (search_window_size - 1 - ww) * height_sim * width_sim + (h - (wsh - hh)) * width_sim + (w - (wsh - ww));

        similarities[hook(0, idx)] = similarities[hook(0, idx_sym)];
        kullback_leiblers[hook(1, idx)] = kullback_leiblers[hook(1, idx_sym)];
      }
    }
  }
}