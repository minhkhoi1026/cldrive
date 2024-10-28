//{"background_label_id":5,"bbox_data":6,"loc_data":0,"num_loc_classes":4,"num_priors":2,"prior_data":1,"share_location":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_bbox_corner_size_variance_kernel(const global float* loc_data, const global float* prior_data, const int num_priors, const int share_location, const int num_loc_classes, const int background_label_id, global float* bbox_data) {
  int index = get_global_id(0);
  const int c = index % num_loc_classes;
  const int idx_p = (index % num_priors) * 4;
  const int idx = index * 4;

  if (!share_location && c == background_label_id) {
    return;
  }

  const float p_xmin = prior_data[hook(1, idx_p)];
  const float p_ymin = prior_data[hook(1, idx_p + 1)];
  const float p_xmax = prior_data[hook(1, idx_p + 2)];
  const float p_ymax = prior_data[hook(1, idx_p + 3)];
  const float prior_width = p_xmax - p_xmin;
  const float prior_height = p_ymax - p_ymin;

  bbox_data[hook(6, idx)] = p_xmin + loc_data[hook(0, idx)] * prior_width;
  bbox_data[hook(6, idx + 1)] = p_ymin + loc_data[hook(0, idx + 1)] * prior_height;
  bbox_data[hook(6, idx + 2)] = p_xmax + loc_data[hook(0, idx + 2)] * prior_width;
  bbox_data[hook(6, idx + 3)] = p_ymax + loc_data[hook(0, idx + 3)] * prior_height;
}