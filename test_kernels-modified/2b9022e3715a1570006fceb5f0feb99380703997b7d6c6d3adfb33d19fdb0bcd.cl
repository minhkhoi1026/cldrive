//{"background_label_id":7,"bbox_data":10,"clip_bbox":8,"locPredTransposed":9,"loc_data":1,"nthreads":0,"num_loc_classes":6,"num_priors":4,"prior_data":2,"share_location":5,"variance_encoded_in_target":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeBBoxesCORNER(const int nthreads, global const float* loc_data, global const float* prior_data, const int variance_encoded_in_target, const int num_priors, const int share_location, const int num_loc_classes, const int background_label_id, const int clip_bbox, const int locPredTransposed, global float* bbox_data) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    float bbox_xmin, bbox_ymin, bbox_xmax, bbox_ymax;
    const int i = index % 4;
    const int p = ((index / 4 / num_loc_classes) % num_priors) * 4;

    const int c = (index / 4) % num_loc_classes;
    int label = share_location ? -1 : c;
    if (label == background_label_id)
      return;

    float4 loc_vec = vload4(0, loc_data + index - i);
    float4 bbox_vec, prior_variance;
    if (variance_encoded_in_target) {
      bbox_vec = loc_vec;
    } else {
      const int start_index = num_priors * 4 + p;
      prior_variance = vload4(0, prior_data + start_index);
      bbox_vec = loc_vec * prior_variance;
    }

    if (locPredTransposed) {
      bbox_ymin = bbox_vec.x;
      bbox_xmin = bbox_vec.y;
      bbox_ymax = bbox_vec.z;
      bbox_xmax = bbox_vec.w;
    } else {
      bbox_xmin = bbox_vec.x;
      bbox_ymin = bbox_vec.y;
      bbox_xmax = bbox_vec.z;
      bbox_ymax = bbox_vec.w;
    }

    float4 prior_vec = vload4(0, prior_data + p);
    float val;
    switch (i) {
      case 0:
        val = prior_vec.x + bbox_xmin;
        break;
      case 1:
        val = prior_vec.y + bbox_ymin;
        break;
      case 2:
        val = prior_vec.z + bbox_xmax;
        break;
      case 3:
        val = prior_vec.w + bbox_ymax;
        break;
    }

    if (clip_bbox)
      val = max(min(val, (float)1.), (float)0.);

    bbox_data[hook(10, index)] = val;
  }
}