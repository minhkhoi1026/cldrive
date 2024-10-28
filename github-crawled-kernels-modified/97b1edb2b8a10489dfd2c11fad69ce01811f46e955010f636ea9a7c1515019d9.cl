//{"NUM_CLUSTERS":6,"NUM_FEATURES":4,"NUM_POINTS":5,"g_centroids":1,"g_labels":2,"g_points":0,"l_centroids":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong ccoord2ind(ulong dim, ulong row, ulong col) {
  return dim * col + row;
}

ulong ccoord2abc(ulong dim, ulong row, ulong col) {
  return get_local_size(0) * (dim * col + row) + get_local_id(0);
}

kernel void lloyd_cluster_merge(global double const* const restrict g_points, global double* const restrict g_centroids, global ulong const* const restrict g_labels,

                                local double* const restrict l_centroids,

                                ulong const NUM_FEATURES, ulong const NUM_POINTS, ulong const NUM_CLUSTERS) {
  ulong const g_cluster_offset = get_global_id(0) * NUM_FEATURES * NUM_CLUSTERS;
  for (ulong f = 0; f < NUM_FEATURES; ++f) {
    for (ulong c = 0; c < NUM_CLUSTERS; ++c) {
      l_centroids[hook(3, ccoord2abc(NUM_CLUSTERS, c, f))] = 0;
    }
  }

  barrier(0x01);

  ulong r;
  for (r = get_global_id(0) * 1; r < NUM_POINTS - 1 + 1; r += get_global_size(0) * 1)

  {
    ulong label = (*(&g_labels[hook(2, r)]));
    for (ulong f = 0; f < NUM_FEATURES; ++f) {
      double point = (*(&g_points[hook(0, ccoord2ind(NUM_POINTS, r, f))]));
      l_centroids[hook(3, ccoord2abc(NUM_CLUSTERS, label, f))] += point;
    }
  }

  barrier(0x01);

  for (ulong f = 0; f < NUM_FEATURES; ++f) {
    for (ulong c = 0; c < NUM_CLUSTERS; ++c) {
      double centroid = l_centroids[hook(3, ccoord2abc(NUM_CLUSTERS, c, f))];
      g_centroids[hook(1, g_cluster_offset + ccoord2ind(NUM_CLUSTERS, c, f))] = centroid;
    }
  }
}