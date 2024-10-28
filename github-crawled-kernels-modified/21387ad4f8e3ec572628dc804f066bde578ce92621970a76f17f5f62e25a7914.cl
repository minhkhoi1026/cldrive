//{"clusters":1,"feature":0,"l_clusters":6,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"p_feature":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_c(global float* restrict feature, global float* restrict clusters, global int* restrict membership, int npoints, int nclusters, int nfeatures) {
  int index = 0;

  float l_clusters[128 * 8];
  for (int i = 0; i < nclusters * nfeatures; i++) {
    l_clusters[hook(6, i)] = clusters[hook(1, i)];
  }

  for (int point_id = 0; point_id < npoints; point_id++) {
    float p_feature[8];
    for (int i = 0; i < nfeatures; i++)
      p_feature[hook(7, i)] = feature[hook(0, point_id * nfeatures + i)];

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
}