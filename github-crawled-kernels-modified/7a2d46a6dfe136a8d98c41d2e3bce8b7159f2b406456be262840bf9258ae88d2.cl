//{"clusters":1,"feature":0,"l_clusters":6,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"p_feature0":7,"p_feature1":8,"p_feature2":9,"p_feature3":10,"p_feature4":11,"p_feature5":12,"p_feature6":13,"p_feature7":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_c(global float* restrict feature, global float* restrict clusters, global int* restrict membership, int npoints, int nclusters, int nfeatures) {
  int index0 = 0;
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;
  int index5 = 0;
  int index6 = 0;
  int index7 = 0;

  float l_clusters[128 * 8];

  for (int i = 0; i < nclusters * nfeatures; i++) {
    l_clusters[hook(6, i)] = clusters[hook(1, i)];
  }

  for (int point_id = 0; point_id < npoints / 8; point_id++) {
    int point_id0 = point_id * 8;
    int point_id1 = point_id * 8 + 1;
    int point_id2 = point_id * 8 + 2;
    int point_id3 = point_id * 8 + 3;
    int point_id4 = point_id * 8 + 4;
    int point_id5 = point_id * 8 + 5;
    int point_id6 = point_id * 8 + 6;
    int point_id7 = point_id * 8 + 7;

    float p_feature0[8];
    float p_feature1[8];
    float p_feature2[8];
    float p_feature3[8];
    float p_feature4[8];
    float p_feature5[8];
    float p_feature6[8];
    float p_feature7[8];

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

    p_feature2[hook(9, 0)] = feature[hook(0, 0 * npoints + point_id2)];
    p_feature2[hook(9, 1)] = feature[hook(0, 1 * npoints + point_id2)];
    p_feature2[hook(9, 2)] = feature[hook(0, 2 * npoints + point_id2)];
    p_feature2[hook(9, 3)] = feature[hook(0, 3 * npoints + point_id2)];
    p_feature2[hook(9, 4)] = feature[hook(0, 4 * npoints + point_id2)];
    p_feature2[hook(9, 5)] = feature[hook(0, 5 * npoints + point_id2)];
    p_feature2[hook(9, 6)] = feature[hook(0, 6 * npoints + point_id2)];
    p_feature2[hook(9, 7)] = feature[hook(0, 7 * npoints + point_id2)];

    p_feature3[hook(10, 0)] = feature[hook(0, 0 * npoints + point_id3)];
    p_feature3[hook(10, 1)] = feature[hook(0, 1 * npoints + point_id3)];
    p_feature3[hook(10, 2)] = feature[hook(0, 2 * npoints + point_id3)];
    p_feature3[hook(10, 3)] = feature[hook(0, 3 * npoints + point_id3)];
    p_feature3[hook(10, 4)] = feature[hook(0, 4 * npoints + point_id3)];
    p_feature3[hook(10, 5)] = feature[hook(0, 5 * npoints + point_id3)];
    p_feature3[hook(10, 6)] = feature[hook(0, 6 * npoints + point_id3)];
    p_feature3[hook(10, 7)] = feature[hook(0, 7 * npoints + point_id3)];

    p_feature4[hook(11, 0)] = feature[hook(0, 0 * npoints + point_id4)];
    p_feature4[hook(11, 1)] = feature[hook(0, 1 * npoints + point_id4)];
    p_feature4[hook(11, 2)] = feature[hook(0, 2 * npoints + point_id4)];
    p_feature4[hook(11, 3)] = feature[hook(0, 3 * npoints + point_id4)];
    p_feature4[hook(11, 4)] = feature[hook(0, 4 * npoints + point_id4)];
    p_feature4[hook(11, 5)] = feature[hook(0, 5 * npoints + point_id4)];
    p_feature4[hook(11, 6)] = feature[hook(0, 6 * npoints + point_id4)];
    p_feature4[hook(11, 7)] = feature[hook(0, 7 * npoints + point_id4)];

    p_feature5[hook(12, 0)] = feature[hook(0, 0 * npoints + point_id5)];
    p_feature5[hook(12, 1)] = feature[hook(0, 1 * npoints + point_id5)];
    p_feature5[hook(12, 2)] = feature[hook(0, 2 * npoints + point_id5)];
    p_feature5[hook(12, 3)] = feature[hook(0, 3 * npoints + point_id5)];
    p_feature5[hook(12, 4)] = feature[hook(0, 4 * npoints + point_id5)];
    p_feature5[hook(12, 5)] = feature[hook(0, 5 * npoints + point_id5)];
    p_feature5[hook(12, 6)] = feature[hook(0, 6 * npoints + point_id5)];
    p_feature5[hook(12, 7)] = feature[hook(0, 7 * npoints + point_id5)];

    p_feature6[hook(13, 0)] = feature[hook(0, 0 * npoints + point_id6)];
    p_feature6[hook(13, 1)] = feature[hook(0, 1 * npoints + point_id6)];
    p_feature6[hook(13, 2)] = feature[hook(0, 2 * npoints + point_id6)];
    p_feature6[hook(13, 3)] = feature[hook(0, 3 * npoints + point_id6)];
    p_feature6[hook(13, 4)] = feature[hook(0, 4 * npoints + point_id6)];
    p_feature6[hook(13, 5)] = feature[hook(0, 5 * npoints + point_id6)];
    p_feature6[hook(13, 6)] = feature[hook(0, 6 * npoints + point_id6)];
    p_feature6[hook(13, 7)] = feature[hook(0, 7 * npoints + point_id6)];

    p_feature7[hook(14, 0)] = feature[hook(0, 0 * npoints + point_id7)];
    p_feature7[hook(14, 1)] = feature[hook(0, 1 * npoints + point_id7)];
    p_feature7[hook(14, 2)] = feature[hook(0, 2 * npoints + point_id7)];
    p_feature7[hook(14, 3)] = feature[hook(0, 3 * npoints + point_id7)];
    p_feature7[hook(14, 4)] = feature[hook(0, 4 * npoints + point_id7)];
    p_feature7[hook(14, 5)] = feature[hook(0, 5 * npoints + point_id7)];
    p_feature7[hook(14, 6)] = feature[hook(0, 6 * npoints + point_id7)];
    p_feature7[hook(14, 7)] = feature[hook(0, 7 * npoints + point_id7)];

    float min_dist0 = 0x1.fffffep127f;
    float min_dist1 = 0x1.fffffep127f;
    float min_dist2 = 0x1.fffffep127f;
    float min_dist3 = 0x1.fffffep127f;
    float min_dist4 = 0x1.fffffep127f;
    float min_dist5 = 0x1.fffffep127f;
    float min_dist6 = 0x1.fffffep127f;
    float min_dist7 = 0x1.fffffep127f;

    for (int i = 0; i < nclusters; i++) {
      float dist0 = 0;
      float dist1 = 0;
      float dist2 = 0;
      float dist3 = 0;
      float dist4 = 0;
      float dist5 = 0;
      float dist6 = 0;
      float dist7 = 0;
      float ans0 = 0;
      float ans1 = 0;
      float ans2 = 0;
      float ans3 = 0;
      float ans4 = 0;
      float ans5 = 0;
      float ans6 = 0;
      float ans7 = 0;

      for (int l = 0; l < nfeatures; l++) {
        float cluster_tmp = l_clusters[hook(6, i * nfeatures + l)];

        float feature_tmp0 = p_feature0[hook(7, l)];
        float feature_tmp1 = p_feature1[hook(8, l)];
        float feature_tmp2 = p_feature2[hook(9, l)];
        float feature_tmp3 = p_feature3[hook(10, l)];
        float feature_tmp4 = p_feature4[hook(11, l)];
        float feature_tmp5 = p_feature5[hook(12, l)];
        float feature_tmp6 = p_feature6[hook(13, l)];
        float feature_tmp7 = p_feature7[hook(14, l)];

        float sub_tmp0 = feature_tmp0 - cluster_tmp;
        float sub_tmp1 = feature_tmp1 - cluster_tmp;
        float sub_tmp2 = feature_tmp2 - cluster_tmp;
        float sub_tmp3 = feature_tmp3 - cluster_tmp;
        float sub_tmp4 = feature_tmp4 - cluster_tmp;
        float sub_tmp5 = feature_tmp5 - cluster_tmp;
        float sub_tmp6 = feature_tmp6 - cluster_tmp;
        float sub_tmp7 = feature_tmp7 - cluster_tmp;

        ans0 += sub_tmp0 * sub_tmp0;
        ans1 += sub_tmp1 * sub_tmp1;
        ans2 += sub_tmp2 * sub_tmp2;
        ans3 += sub_tmp3 * sub_tmp3;
        ans4 += sub_tmp4 * sub_tmp4;
        ans5 += sub_tmp5 * sub_tmp5;
        ans6 += sub_tmp6 * sub_tmp6;
        ans7 += sub_tmp7 * sub_tmp7;
      }

      dist0 = ans0;
      dist1 = ans1;
      dist2 = ans2;
      dist3 = ans3;
      dist4 = ans4;
      dist5 = ans5;
      dist6 = ans6;
      dist7 = ans7;

      if (dist0 < min_dist0) {
        min_dist0 = dist0;
        index0 = i;
      }
      if (dist1 < min_dist1) {
        min_dist1 = dist1;
        index1 = i;
      }
      if (dist2 < min_dist2) {
        min_dist2 = dist2;
        index2 = i;
      }
      if (dist3 < min_dist3) {
        min_dist3 = dist3;
        index3 = i;
      }
      if (dist4 < min_dist4) {
        min_dist4 = dist4;
        index4 = i;
      }
      if (dist5 < min_dist5) {
        min_dist5 = dist5;
        index5 = i;
      }
      if (dist6 < min_dist6) {
        min_dist6 = dist6;
        index6 = i;
      }
      if (dist7 < min_dist7) {
        min_dist7 = dist7;
        index7 = i;
      }
    }
    membership[hook(2, point_id0)] = index0;
    membership[hook(2, point_id1)] = index1;
    membership[hook(2, point_id2)] = index2;
    membership[hook(2, point_id3)] = index3;
    membership[hook(2, point_id4)] = index4;
    membership[hook(2, point_id5)] = index5;
    membership[hook(2, point_id6)] = index6;
    membership[hook(2, point_id7)] = index7;
  }
}