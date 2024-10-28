//{"clusters":1,"feature":0,"l_clusters":6,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"p_feature":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_c(global float* restrict feature, global float* restrict clusters, global int* restrict membership, int npoints, int nclusters, int nfeatures) {
  unsigned int point_id = get_global_id(0);
  unsigned int local_id = get_local_id(0);
  int index = 0;

  local float l_clusters[128 * 8];
  if (local_id < nclusters) {
    l_clusters[hook(6, local_id * 8 + 0)] = clusters[hook(1, local_id * 8 + 0)];
    l_clusters[hook(6, local_id * 8 + 1)] = clusters[hook(1, local_id * 8 + 1)];
    l_clusters[hook(6, local_id * 8 + 2)] = clusters[hook(1, local_id * 8 + 2)];
    l_clusters[hook(6, local_id * 8 + 3)] = clusters[hook(1, local_id * 8 + 3)];
    l_clusters[hook(6, local_id * 8 + 4)] = clusters[hook(1, local_id * 8 + 4)];
    l_clusters[hook(6, local_id * 8 + 5)] = clusters[hook(1, local_id * 8 + 5)];
    l_clusters[hook(6, local_id * 8 + 6)] = clusters[hook(1, local_id * 8 + 6)];
    l_clusters[hook(6, local_id * 8 + 7)] = clusters[hook(1, local_id * 8 + 7)];
  }

  float p_feature[8];
  p_feature[hook(7, 0)] = feature[hook(0, point_id * nfeatures + 0)];
  p_feature[hook(7, 1)] = feature[hook(0, point_id * nfeatures + 1)];
  p_feature[hook(7, 2)] = feature[hook(0, point_id * nfeatures + 2)];
  p_feature[hook(7, 3)] = feature[hook(0, point_id * nfeatures + 3)];
  p_feature[hook(7, 4)] = feature[hook(0, point_id * nfeatures + 4)];
  p_feature[hook(7, 5)] = feature[hook(0, point_id * nfeatures + 5)];
  p_feature[hook(7, 6)] = feature[hook(0, point_id * nfeatures + 6)];
  p_feature[hook(7, 7)] = feature[hook(0, point_id * nfeatures + 7)];

  barrier(0x01);

  float min_dist = 0x1.fffffep127f;

  for (int i = 0; i < nclusters; i++) {
    float dist = 0;
    float ans = 0;

    for (int l = 0; l < nfeatures; l++) {
      float cluster_tmp = l_clusters[hook(6, i * nfeatures + l)];
      float feature_tmp = p_feature[hook(7, l)];
      float sub_tmp = feature_tmp - cluster_tmp;
      ans += sub_tmp * sub_tmp;
    }
    dist = ans;

    if (dist < min_dist) {
      min_dist = dist;
      index = i;
    }
  }
  membership[hook(2, point_id)] = index;
}