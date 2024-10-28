//{"clusters":1,"feature":0,"l_clusters":6,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"p_feature0":7,"p_feature1":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_c(global float* restrict feature, global float* restrict clusters, global int* restrict membership, int npoints, int nclusters, int nfeatures) {
  int index0 = 0;
  int index1 = 0;

  float l_clusters[128 * 8];

  for (int i = 0; i < nclusters * nfeatures; i++) {
    l_clusters[hook(6, i)] = clusters[hook(1, i)];
  }

  for (int point_id = 0; point_id < npoints / 2; point_id++) {
    int point_id0 = point_id * 2;
    int point_id1 = point_id * 2 + 1;

    float p_feature0[8];
    float p_feature1[8];

    p_feature0[hook(7, 0)] = feature[hook(0, 0 * npoints + point_id0)];
    p_feature0[hook(7, 1)] = feature[hook(0, 1 * npoints + point_id0)];
    p_feature0[hook(7, 2)] = feature[hook(0, 2 * npoints + point_id0)];
    p_feature0[hook(7, 3)] = feature[hook(0, 3 * npoints + point_id0)];
    p_feature0[hook(7, 4)] = feature[hook(0, 4 * npoints + point_id0)];
    p_feature0[hook(7, 5)] = feature[hook(0, 5 * npoints + point_id0)];
    p_feature0[hook(7, 6)] = feature[hook(0, 6 * npoints + point_id0)];
    p_feature0[hook(7, 7)] = feature[hook(0, 7 * npoints + point_id0)];

    p_feature1[hook(8, 0)] = feature[hook(0, 0 * npoints + point_id1)];
    p_feature1[hook(8, 1)] = feature[hook(0, 1 * npoints + point_id1)];
    p_feature1[hook(8, 2)] = feature[hook(0, 2 * npoints + point_id1)];
    p_feature1[hook(8, 3)] = feature[hook(0, 3 * npoints + point_id1)];
    p_feature1[hook(8, 4)] = feature[hook(0, 4 * npoints + point_id1)];
    p_feature1[hook(8, 5)] = feature[hook(0, 5 * npoints + point_id1)];
    p_feature1[hook(8, 6)] = feature[hook(0, 6 * npoints + point_id1)];
    p_feature1[hook(8, 7)] = feature[hook(0, 7 * npoints + point_id1)];

    float min_dist0 = 0x1.fffffep127f;
    float min_dist1 = 0x1.fffffep127f;

    for (int i = 0; i < nclusters; i++) {
      float dist0 = 0;
      float dist1 = 0;
      float ans0 = 0;
      float ans1 = 0;

      for (int l = 0; l < nfeatures; l++) {
        float cluster_tmp = l_clusters[hook(6, i * nfeatures + l)];
        float feature_tmp0 = p_feature0[hook(7, l)];
        float feature_tmp1 = p_feature1[hook(8, l)];
        float sub_tmp0 = feature_tmp0 - cluster_tmp;
        float sub_tmp1 = feature_tmp1 - cluster_tmp;
        ans0 += sub_tmp0 * sub_tmp0;
        ans1 += sub_tmp1 * sub_tmp1;
      }

      dist0 = ans0;
      dist1 = ans1;
      if (dist0 < min_dist0) {
        min_dist0 = dist0;
        index0 = i;
      }
      if (dist1 < min_dist1) {
        min_dist1 = dist1;
        index1 = i;
      }
    }
    membership[hook(2, point_id0)] = index0;
    membership[hook(2, point_id1)] = index1;
  }
}