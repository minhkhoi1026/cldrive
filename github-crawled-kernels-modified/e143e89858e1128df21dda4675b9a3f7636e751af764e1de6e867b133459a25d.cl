//{"clusters":6,"features":0,"features_flipped":1,"membership":5,"nclusters":4,"nfeatures":2,"npoints":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeansPoint(global float* features, global float* features_flipped, int nfeatures, int npoints, int nclusters, global int* membership, constant float* clusters) {
  const unsigned int block_id = get_num_groups(0) * get_group_id(1) + get_group_id(0);

  const unsigned int point_id = block_id * get_local_size(0) * get_local_size(1) + get_local_id(0);

  int index = -1;

  if (point_id < npoints) {
    int i, j;
    float min_dist = 0x1.fffffep127f;
    float dist;

    for (i = 0; i < nclusters; i++) {
      int cluster_base_index = i * nfeatures;
      float ans = 0.0;

      for (j = 0; j < nfeatures; j++) {
        int addr = point_id + j * npoints;
        float diff = (features[hook(0, addr)] - clusters[hook(6, cluster_base_index + j)]);
        ans += diff * diff;
      }
      dist = ans;

      if (dist < min_dist) {
        min_dist = dist;
        index = i;
      }
    }
  }
  if (point_id < npoints) {
    membership[hook(5, point_id)] = index;
  }
}