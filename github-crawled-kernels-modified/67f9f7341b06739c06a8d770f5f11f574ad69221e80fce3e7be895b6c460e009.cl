//{"background_label_id":5,"bbox_data":6,"loc_data":0,"num_loc_classes":4,"num_priors":2,"prior_data":1,"share_location":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_bbox_corner_variance_kernel(const global float* loc_data, const global float* prior_data, const int num_priors, const int share_location, const int num_loc_classes, const int background_label_id, global float* bbox_data) {
  int index = get_global_id(0);
  const int c = index % num_loc_classes;
  const int idx_p = (index % num_priors) * 4;
  const int idx = index * 4;

  if (!share_location && c == background_label_id) {
    return;
  }

  bbox_data[hook(6, idx)] = prior_data[hook(1, idx_p)] + loc_data[hook(0, idx)];
  bbox_data[hook(6, idx + 1)] = prior_data[hook(1, idx_p + 1)] + loc_data[hook(0, idx + 1)];
  bbox_data[hook(6, idx + 2)] = prior_data[hook(1, idx_p + 2)] + loc_data[hook(0, idx + 2)];
  bbox_data[hook(6, idx + 3)] = prior_data[hook(1, idx_p + 3)] + loc_data[hook(0, idx + 3)];
}