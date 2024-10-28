//{"background_label_id":7,"bbox_data":9,"clip_bbox":8,"loc_data":1,"nthreads":0,"num_loc_classes":6,"num_priors":4,"prior_data":2,"share_location":5,"variance_encoded_in_target":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DecodeBBoxesCENTER_SIZE(const int nthreads, global const float* loc_data, global const float* prior_data, const int variance_encoded_in_target, const int num_priors, const int share_location, const int num_loc_classes, const int background_label_id, const int clip_bbox, global float* bbox_data) {
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

    bbox_xmin = bbox_vec.x;
    bbox_ymin = bbox_vec.y;
    bbox_xmax = bbox_vec.z;
    bbox_ymax = bbox_vec.w;

    float4 prior_vec = vload4(0, prior_data + p);
    float prior_width = prior_vec.z - prior_vec.x;
    float prior_height = prior_vec.w - prior_vec.y;
    float prior_center_x = (prior_vec.x + prior_vec.z) * .5;
    float prior_center_y = (prior_vec.y + prior_vec.w) * .5;

    float decode_bbox_center_x, decode_bbox_center_y;
    float decode_bbox_width, decode_bbox_height;
    decode_bbox_center_x = bbox_xmin * prior_width + prior_center_x;
    decode_bbox_center_y = bbox_ymin * prior_height + prior_center_y;
    decode_bbox_width = exp(bbox_xmax) * prior_width;
    decode_bbox_height = exp(bbox_ymax) * prior_height;

    float val;
    switch (i) {
      case 0:
        val = decode_bbox_center_x - decode_bbox_width * .5;
        break;
      case 1:
        val = decode_bbox_center_y - decode_bbox_height * .5;
        break;
      case 2:
        val = decode_bbox_center_x + decode_bbox_width * .5;
        break;
      case 3:
        val = decode_bbox_center_y + decode_bbox_height * .5;
        break;
    }

    if (clip_bbox)
      val = max(min(val, (float)1.), (float)0.);

    bbox_data[hook(9, index)] = val;
  }
}