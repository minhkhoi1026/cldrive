//{"NUM_CLUSTERS":5,"NUM_FEATURES":3,"NUM_POINTS":4,"g_centroids":1,"g_labels":2,"g_points":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int ccoord2ind(unsigned int dim, unsigned int row, unsigned int col) {
  return dim * col + row;
}

kernel void lloyd_feature_sum_sequential(global float const* const restrict g_points, global float* const restrict g_centroids, global unsigned int const* const restrict g_labels, const unsigned int NUM_FEATURES, const unsigned int NUM_POINTS, const unsigned int NUM_CLUSTERS) {
  unsigned int const feature = get_global_id(0) % NUM_FEATURES;
  unsigned int const point_block = get_global_id(0) / NUM_FEATURES;
  unsigned int const num_point_blocks = get_global_size(0) / NUM_FEATURES;
  unsigned int const num_local_points = (NUM_POINTS + num_point_blocks - 1) / num_point_blocks;
  unsigned int const num_real_local_points = (num_local_points * (point_block + 1) > NUM_POINTS) ? sub_sat(NUM_POINTS, (num_local_points * point_block)) : num_local_points;
  unsigned int const point_offset = num_local_points * point_block;
  unsigned int const centroid_offset = NUM_CLUSTERS * NUM_FEATURES * point_block;
  unsigned int const feature_offset = centroid_offset + NUM_CLUSTERS * feature;

  for (unsigned int i = feature_offset; i < feature_offset + NUM_CLUSTERS; ++i) {
    g_centroids[hook(1, i)] = 0;
  }

  for (unsigned int p = point_offset; p < point_offset + num_real_local_points; ++p) {
    unsigned int label = g_labels[hook(2, p)];
    float point = g_points[hook(0, ccoord2ind(NUM_POINTS, p, feature))];

    g_centroids[hook(1, centroid_offset + ccoord2ind(NUM_CLUSTERS, label, feature))] += point;
  }
}