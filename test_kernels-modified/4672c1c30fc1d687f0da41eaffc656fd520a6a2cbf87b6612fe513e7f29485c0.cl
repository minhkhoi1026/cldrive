//{"background_label_id":5,"bbox_data":6,"loc_data":0,"num_loc_classes":4,"num_priors":2,"prior_data":1,"share_location":3,"variance":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_bbox_center_no_variance_kernel(const global float* loc_data, const global float* prior_data, const int num_priors, const int share_location, const int num_loc_classes, const int background_label_id, global float* bbox_data) {
  int index = get_global_id(0);
  const int c = index % num_loc_classes;
  const int idx_p = (index % num_priors) * 4;
  const int idx = index * 4;
  const global float* variance = prior_data + num_priors * 4;

  if (!share_location && c == background_label_id) {
    return;
  }

  const float p_xmin = prior_data[hook(1, idx_p)];
  const float p_ymin = prior_data[hook(1, idx_p + 1)];
  const float p_xmax = prior_data[hook(1, idx_p + 2)];
  const float p_ymax = prior_data[hook(1, idx_p + 3)];
  const float prior_width = p_xmax - p_xmin;
  const float prior_height = p_ymax - p_ymin;
  const float prior_center_x = (p_xmin + p_xmax) / 2.;
  const float prior_center_y = (p_ymin + p_ymax) / 2.;

  const float xmin = loc_data[hook(0, idx)];
  const float ymin = loc_data[hook(0, idx + 1)];
  const float xmax = loc_data[hook(0, idx + 2)];
  const float ymax = loc_data[hook(0, idx + 3)];

  float decode_bbox_center_x = variance[hook(7, idx_p)] * xmin * prior_width + prior_center_x;
  float decode_bbox_center_y = variance[hook(7, idx_p + 1)] * ymin * prior_height + prior_center_y;
  float decode_bbox_width = exp(variance[hook(7, idx_p + 2)] * xmax) * prior_width;
  float decode_bbox_height = exp(variance[hook(7, idx_p + 3)] * ymax) * prior_height;

  bbox_data[hook(6, idx)] = decode_bbox_center_x - decode_bbox_width / 2.f;
  bbox_data[hook(6, idx + 1)] = decode_bbox_center_y - decode_bbox_height / 2.f;
  bbox_data[hook(6, idx + 2)] = decode_bbox_center_x + decode_bbox_width / 2.f;
  bbox_data[hook(6, idx + 3)] = decode_bbox_center_y + decode_bbox_height / 2.f;
}