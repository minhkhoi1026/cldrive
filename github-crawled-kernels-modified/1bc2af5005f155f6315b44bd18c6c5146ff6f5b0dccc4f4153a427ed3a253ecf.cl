//{"clusters":1,"feature":0,"l_clusters":6,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"p_feature0":7,"p_feature1":8,"p_feature10":17,"p_feature11":18,"p_feature12":19,"p_feature13":20,"p_feature14":21,"p_feature15":22,"p_feature2":9,"p_feature3":10,"p_feature4":11,"p_feature5":12,"p_feature6":13,"p_feature7":14,"p_feature8":15,"p_feature9":16}
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
  int index8 = 0;
  int index9 = 0;
  int index10 = 0;
  int index11 = 0;
  int index12 = 0;
  int index13 = 0;
  int index14 = 0;
  int index15 = 0;

  float l_clusters[128 * 8];

  for (int i = 0; i < nclusters * nfeatures; i++) {
    l_clusters[hook(6, i)] = clusters[hook(1, i)];
  }

  for (int point_id = 0; point_id < npoints / 16; point_id++) {
    int point_id0 = point_id * 16;
    int point_id1 = point_id * 16 + 1;
    int point_id2 = point_id * 16 + 2;
    int point_id3 = point_id * 16 + 3;
    int point_id4 = point_id * 16 + 4;
    int point_id5 = point_id * 16 + 5;
    int point_id6 = point_id * 16 + 6;
    int point_id7 = point_id * 16 + 7;
    int point_id8 = point_id * 16 + 8;
    int point_id9 = point_id * 16 + 9;
    int point_id10 = point_id * 16 + 10;
    int point_id11 = point_id * 16 + 11;
    int point_id12 = point_id * 16 + 12;
    int point_id13 = point_id * 16 + 13;
    int point_id14 = point_id * 16 + 14;
    int point_id15 = point_id * 16 + 15;

    float p_feature0[8];
    float p_feature1[8];
    float p_feature2[8];
    float p_feature3[8];
    float p_feature4[8];
    float p_feature5[8];
    float p_feature6[8];
    float p_feature7[8];
    float p_feature8[8];
    float p_feature9[8];
    float p_feature10[8];
    float p_feature11[8];
    float p_feature12[8];
    float p_feature13[8];
    float p_feature14[8];
    float p_feature15[8];

    p_feature0[hook(7, 0)] = feature[hook(0, point_id0 * nfeatures + 0)];
    p_feature0[hook(7, 1)] = feature[hook(0, point_id0 * nfeatures + 1)];
    p_feature0[hook(7, 2)] = feature[hook(0, point_id0 * nfeatures + 2)];
    p_feature0[hook(7, 3)] = feature[hook(0, point_id0 * nfeatures + 3)];
    p_feature0[hook(7, 4)] = feature[hook(0, point_id0 * nfeatures + 4)];
    p_feature0[hook(7, 5)] = feature[hook(0, point_id0 * nfeatures + 5)];
    p_feature0[hook(7, 6)] = feature[hook(0, point_id0 * nfeatures + 6)];
    p_feature0[hook(7, 7)] = feature[hook(0, point_id0 * nfeatures + 7)];

    p_feature1[hook(8, 0)] = feature[hook(0, point_id1 * nfeatures + 0)];
    p_feature1[hook(8, 1)] = feature[hook(0, point_id1 * nfeatures + 1)];
    p_feature1[hook(8, 2)] = feature[hook(0, point_id1 * nfeatures + 2)];
    p_feature1[hook(8, 3)] = feature[hook(0, point_id1 * nfeatures + 3)];
    p_feature1[hook(8, 4)] = feature[hook(0, point_id1 * nfeatures + 4)];
    p_feature1[hook(8, 5)] = feature[hook(0, point_id1 * nfeatures + 5)];
    p_feature1[hook(8, 6)] = feature[hook(0, point_id1 * nfeatures + 6)];
    p_feature1[hook(8, 7)] = feature[hook(0, point_id1 * nfeatures + 7)];

    p_feature2[hook(9, 0)] = feature[hook(0, point_id2 * nfeatures + 0)];
    p_feature2[hook(9, 1)] = feature[hook(0, point_id2 * nfeatures + 1)];
    p_feature2[hook(9, 2)] = feature[hook(0, point_id2 * nfeatures + 2)];
    p_feature2[hook(9, 3)] = feature[hook(0, point_id2 * nfeatures + 3)];
    p_feature2[hook(9, 4)] = feature[hook(0, point_id2 * nfeatures + 4)];
    p_feature2[hook(9, 5)] = feature[hook(0, point_id2 * nfeatures + 5)];
    p_feature2[hook(9, 6)] = feature[hook(0, point_id2 * nfeatures + 6)];
    p_feature2[hook(9, 7)] = feature[hook(0, point_id2 * nfeatures + 7)];

    p_feature3[hook(10, 0)] = feature[hook(0, point_id3 * nfeatures + 0)];
    p_feature3[hook(10, 1)] = feature[hook(0, point_id3 * nfeatures + 1)];
    p_feature3[hook(10, 2)] = feature[hook(0, point_id3 * nfeatures + 2)];
    p_feature3[hook(10, 3)] = feature[hook(0, point_id3 * nfeatures + 3)];
    p_feature3[hook(10, 4)] = feature[hook(0, point_id3 * nfeatures + 4)];
    p_feature3[hook(10, 5)] = feature[hook(0, point_id3 * nfeatures + 5)];
    p_feature3[hook(10, 6)] = feature[hook(0, point_id3 * nfeatures + 6)];
    p_feature3[hook(10, 7)] = feature[hook(0, point_id3 * nfeatures + 7)];

    p_feature4[hook(11, 0)] = feature[hook(0, point_id4 * nfeatures + 0)];
    p_feature4[hook(11, 1)] = feature[hook(0, point_id4 * nfeatures + 1)];
    p_feature4[hook(11, 2)] = feature[hook(0, point_id4 * nfeatures + 2)];
    p_feature4[hook(11, 3)] = feature[hook(0, point_id4 * nfeatures + 3)];
    p_feature4[hook(11, 4)] = feature[hook(0, point_id4 * nfeatures + 4)];
    p_feature4[hook(11, 5)] = feature[hook(0, point_id4 * nfeatures + 5)];
    p_feature4[hook(11, 6)] = feature[hook(0, point_id4 * nfeatures + 6)];
    p_feature4[hook(11, 7)] = feature[hook(0, point_id4 * nfeatures + 7)];

    p_feature5[hook(12, 0)] = feature[hook(0, point_id5 * nfeatures + 0)];
    p_feature5[hook(12, 1)] = feature[hook(0, point_id5 * nfeatures + 1)];
    p_feature5[hook(12, 2)] = feature[hook(0, point_id5 * nfeatures + 2)];
    p_feature5[hook(12, 3)] = feature[hook(0, point_id5 * nfeatures + 3)];
    p_feature5[hook(12, 4)] = feature[hook(0, point_id5 * nfeatures + 4)];
    p_feature5[hook(12, 5)] = feature[hook(0, point_id5 * nfeatures + 5)];
    p_feature5[hook(12, 6)] = feature[hook(0, point_id5 * nfeatures + 6)];
    p_feature5[hook(12, 7)] = feature[hook(0, point_id5 * nfeatures + 7)];

    p_feature6[hook(13, 0)] = feature[hook(0, point_id6 * nfeatures + 0)];
    p_feature6[hook(13, 1)] = feature[hook(0, point_id6 * nfeatures + 1)];
    p_feature6[hook(13, 2)] = feature[hook(0, point_id6 * nfeatures + 2)];
    p_feature6[hook(13, 3)] = feature[hook(0, point_id6 * nfeatures + 3)];
    p_feature6[hook(13, 4)] = feature[hook(0, point_id6 * nfeatures + 4)];
    p_feature6[hook(13, 5)] = feature[hook(0, point_id6 * nfeatures + 5)];
    p_feature6[hook(13, 6)] = feature[hook(0, point_id6 * nfeatures + 6)];
    p_feature6[hook(13, 7)] = feature[hook(0, point_id6 * nfeatures + 7)];

    p_feature7[hook(14, 0)] = feature[hook(0, point_id7 * nfeatures + 0)];
    p_feature7[hook(14, 1)] = feature[hook(0, point_id7 * nfeatures + 1)];
    p_feature7[hook(14, 2)] = feature[hook(0, point_id7 * nfeatures + 2)];
    p_feature7[hook(14, 3)] = feature[hook(0, point_id7 * nfeatures + 3)];
    p_feature7[hook(14, 4)] = feature[hook(0, point_id7 * nfeatures + 4)];
    p_feature7[hook(14, 5)] = feature[hook(0, point_id7 * nfeatures + 5)];
    p_feature7[hook(14, 6)] = feature[hook(0, point_id7 * nfeatures + 6)];
    p_feature7[hook(14, 7)] = feature[hook(0, point_id7 * nfeatures + 7)];

    p_feature8[hook(15, 0)] = feature[hook(0, point_id8 * nfeatures + 0)];
    p_feature8[hook(15, 1)] = feature[hook(0, point_id8 * nfeatures + 1)];
    p_feature8[hook(15, 2)] = feature[hook(0, point_id8 * nfeatures + 2)];
    p_feature8[hook(15, 3)] = feature[hook(0, point_id8 * nfeatures + 3)];
    p_feature8[hook(15, 4)] = feature[hook(0, point_id8 * nfeatures + 4)];
    p_feature8[hook(15, 5)] = feature[hook(0, point_id8 * nfeatures + 5)];
    p_feature8[hook(15, 6)] = feature[hook(0, point_id8 * nfeatures + 6)];
    p_feature8[hook(15, 7)] = feature[hook(0, point_id8 * nfeatures + 7)];

    p_feature9[hook(16, 0)] = feature[hook(0, point_id9 * nfeatures + 0)];
    p_feature9[hook(16, 1)] = feature[hook(0, point_id9 * nfeatures + 1)];
    p_feature9[hook(16, 2)] = feature[hook(0, point_id9 * nfeatures + 2)];
    p_feature9[hook(16, 3)] = feature[hook(0, point_id9 * nfeatures + 3)];
    p_feature9[hook(16, 4)] = feature[hook(0, point_id9 * nfeatures + 4)];
    p_feature9[hook(16, 5)] = feature[hook(0, point_id9 * nfeatures + 5)];
    p_feature9[hook(16, 6)] = feature[hook(0, point_id9 * nfeatures + 6)];
    p_feature9[hook(16, 7)] = feature[hook(0, point_id9 * nfeatures + 7)];

    p_feature10[hook(17, 0)] = feature[hook(0, point_id10 * nfeatures + 0)];
    p_feature10[hook(17, 1)] = feature[hook(0, point_id10 * nfeatures + 1)];
    p_feature10[hook(17, 2)] = feature[hook(0, point_id10 * nfeatures + 2)];
    p_feature10[hook(17, 3)] = feature[hook(0, point_id10 * nfeatures + 3)];
    p_feature10[hook(17, 4)] = feature[hook(0, point_id10 * nfeatures + 4)];
    p_feature10[hook(17, 5)] = feature[hook(0, point_id10 * nfeatures + 5)];
    p_feature10[hook(17, 6)] = feature[hook(0, point_id10 * nfeatures + 6)];
    p_feature10[hook(17, 7)] = feature[hook(0, point_id10 * nfeatures + 7)];

    p_feature11[hook(18, 0)] = feature[hook(0, point_id11 * nfeatures + 0)];
    p_feature11[hook(18, 1)] = feature[hook(0, point_id11 * nfeatures + 1)];
    p_feature11[hook(18, 2)] = feature[hook(0, point_id11 * nfeatures + 2)];
    p_feature11[hook(18, 3)] = feature[hook(0, point_id11 * nfeatures + 3)];
    p_feature11[hook(18, 4)] = feature[hook(0, point_id11 * nfeatures + 4)];
    p_feature11[hook(18, 5)] = feature[hook(0, point_id11 * nfeatures + 5)];
    p_feature11[hook(18, 6)] = feature[hook(0, point_id11 * nfeatures + 6)];
    p_feature11[hook(18, 7)] = feature[hook(0, point_id11 * nfeatures + 7)];

    p_feature12[hook(19, 0)] = feature[hook(0, point_id12 * nfeatures + 0)];
    p_feature12[hook(19, 1)] = feature[hook(0, point_id12 * nfeatures + 1)];
    p_feature12[hook(19, 2)] = feature[hook(0, point_id12 * nfeatures + 2)];
    p_feature12[hook(19, 3)] = feature[hook(0, point_id12 * nfeatures + 3)];
    p_feature12[hook(19, 4)] = feature[hook(0, point_id12 * nfeatures + 4)];
    p_feature12[hook(19, 5)] = feature[hook(0, point_id12 * nfeatures + 5)];
    p_feature12[hook(19, 6)] = feature[hook(0, point_id12 * nfeatures + 6)];
    p_feature12[hook(19, 7)] = feature[hook(0, point_id12 * nfeatures + 7)];

    p_feature13[hook(20, 0)] = feature[hook(0, point_id13 * nfeatures + 0)];
    p_feature13[hook(20, 1)] = feature[hook(0, point_id13 * nfeatures + 1)];
    p_feature13[hook(20, 2)] = feature[hook(0, point_id13 * nfeatures + 2)];
    p_feature13[hook(20, 3)] = feature[hook(0, point_id13 * nfeatures + 3)];
    p_feature13[hook(20, 4)] = feature[hook(0, point_id13 * nfeatures + 4)];
    p_feature13[hook(20, 5)] = feature[hook(0, point_id13 * nfeatures + 5)];
    p_feature13[hook(20, 6)] = feature[hook(0, point_id13 * nfeatures + 6)];
    p_feature13[hook(20, 7)] = feature[hook(0, point_id13 * nfeatures + 7)];

    p_feature14[hook(21, 0)] = feature[hook(0, point_id14 * nfeatures + 0)];
    p_feature14[hook(21, 1)] = feature[hook(0, point_id14 * nfeatures + 1)];
    p_feature14[hook(21, 2)] = feature[hook(0, point_id14 * nfeatures + 2)];
    p_feature14[hook(21, 3)] = feature[hook(0, point_id14 * nfeatures + 3)];
    p_feature14[hook(21, 4)] = feature[hook(0, point_id14 * nfeatures + 4)];
    p_feature14[hook(21, 5)] = feature[hook(0, point_id14 * nfeatures + 5)];
    p_feature14[hook(21, 6)] = feature[hook(0, point_id14 * nfeatures + 6)];
    p_feature14[hook(21, 7)] = feature[hook(0, point_id14 * nfeatures + 7)];

    p_feature15[hook(22, 0)] = feature[hook(0, point_id15 * nfeatures + 0)];
    p_feature15[hook(22, 1)] = feature[hook(0, point_id15 * nfeatures + 1)];
    p_feature15[hook(22, 2)] = feature[hook(0, point_id15 * nfeatures + 2)];
    p_feature15[hook(22, 3)] = feature[hook(0, point_id15 * nfeatures + 3)];
    p_feature15[hook(22, 4)] = feature[hook(0, point_id15 * nfeatures + 4)];
    p_feature15[hook(22, 5)] = feature[hook(0, point_id15 * nfeatures + 5)];
    p_feature15[hook(22, 6)] = feature[hook(0, point_id15 * nfeatures + 6)];
    p_feature15[hook(22, 7)] = feature[hook(0, point_id15 * nfeatures + 7)];

    float min_dist0 = 0x1.fffffep127f;
    float min_dist1 = 0x1.fffffep127f;
    float min_dist2 = 0x1.fffffep127f;
    float min_dist3 = 0x1.fffffep127f;
    float min_dist4 = 0x1.fffffep127f;
    float min_dist5 = 0x1.fffffep127f;
    float min_dist6 = 0x1.fffffep127f;
    float min_dist7 = 0x1.fffffep127f;
    float min_dist8 = 0x1.fffffep127f;
    float min_dist9 = 0x1.fffffep127f;
    float min_dist10 = 0x1.fffffep127f;
    float min_dist11 = 0x1.fffffep127f;
    float min_dist12 = 0x1.fffffep127f;
    float min_dist13 = 0x1.fffffep127f;
    float min_dist14 = 0x1.fffffep127f;
    float min_dist15 = 0x1.fffffep127f;

    for (int i = 0; i < nclusters; i++) {
      float dist0 = 0;
      float dist1 = 0;
      float dist2 = 0;
      float dist3 = 0;
      float dist4 = 0;
      float dist5 = 0;
      float dist6 = 0;
      float dist7 = 0;
      float dist8 = 0;
      float dist9 = 0;
      float dist10 = 0;
      float dist11 = 0;
      float dist12 = 0;
      float dist13 = 0;
      float dist14 = 0;
      float dist15 = 0;
      float ans0 = 0;
      float ans1 = 0;
      float ans2 = 0;
      float ans3 = 0;
      float ans4 = 0;
      float ans5 = 0;
      float ans6 = 0;
      float ans7 = 0;
      float ans8 = 0;
      float ans9 = 0;
      float ans10 = 0;
      float ans11 = 0;
      float ans12 = 0;
      float ans13 = 0;
      float ans14 = 0;
      float ans15 = 0;

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
        float feature_tmp8 = p_feature8[hook(15, l)];
        float feature_tmp9 = p_feature9[hook(16, l)];
        float feature_tmp10 = p_feature10[hook(17, l)];
        float feature_tmp11 = p_feature11[hook(18, l)];
        float feature_tmp12 = p_feature12[hook(19, l)];
        float feature_tmp13 = p_feature13[hook(20, l)];
        float feature_tmp14 = p_feature14[hook(21, l)];
        float feature_tmp15 = p_feature15[hook(22, l)];

        float sub_tmp0 = feature_tmp0 - cluster_tmp;
        float sub_tmp1 = feature_tmp1 - cluster_tmp;
        float sub_tmp2 = feature_tmp2 - cluster_tmp;
        float sub_tmp3 = feature_tmp3 - cluster_tmp;
        float sub_tmp4 = feature_tmp4 - cluster_tmp;
        float sub_tmp5 = feature_tmp5 - cluster_tmp;
        float sub_tmp6 = feature_tmp6 - cluster_tmp;
        float sub_tmp7 = feature_tmp7 - cluster_tmp;
        float sub_tmp8 = feature_tmp8 - cluster_tmp;
        float sub_tmp9 = feature_tmp9 - cluster_tmp;
        float sub_tmp10 = feature_tmp10 - cluster_tmp;
        float sub_tmp11 = feature_tmp11 - cluster_tmp;
        float sub_tmp12 = feature_tmp12 - cluster_tmp;
        float sub_tmp13 = feature_tmp13 - cluster_tmp;
        float sub_tmp14 = feature_tmp14 - cluster_tmp;
        float sub_tmp15 = feature_tmp15 - cluster_tmp;

        ans0 += sub_tmp0 * sub_tmp0;
        ans1 += sub_tmp1 * sub_tmp1;
        ans2 += sub_tmp2 * sub_tmp2;
        ans3 += sub_tmp3 * sub_tmp3;
        ans4 += sub_tmp4 * sub_tmp4;
        ans5 += sub_tmp5 * sub_tmp5;
        ans6 += sub_tmp6 * sub_tmp6;
        ans7 += sub_tmp7 * sub_tmp7;
        ans8 += sub_tmp8 * sub_tmp8;
        ans9 += sub_tmp9 * sub_tmp9;
        ans10 += sub_tmp10 * sub_tmp10;
        ans11 += sub_tmp11 * sub_tmp11;
        ans12 += sub_tmp12 * sub_tmp12;
        ans13 += sub_tmp13 * sub_tmp13;
        ans14 += sub_tmp14 * sub_tmp14;
        ans15 += sub_tmp15 * sub_tmp15;
      }

      dist0 = ans0;
      dist1 = ans1;
      dist2 = ans2;
      dist3 = ans3;
      dist4 = ans4;
      dist5 = ans5;
      dist6 = ans6;
      dist7 = ans7;
      dist8 = ans8;
      dist9 = ans9;
      dist10 = ans10;
      dist11 = ans11;
      dist12 = ans12;
      dist13 = ans13;
      dist14 = ans14;
      dist15 = ans15;

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
      if (dist8 < min_dist8) {
        min_dist8 = dist8;
        index8 = i;
      }
      if (dist9 < min_dist9) {
        min_dist9 = dist9;
        index9 = i;
      }
      if (dist10 < min_dist10) {
        min_dist10 = dist10;
        index10 = i;
      }
      if (dist11 < min_dist11) {
        min_dist11 = dist11;
        index11 = i;
      }
      if (dist12 < min_dist12) {
        min_dist12 = dist12;
        index12 = i;
      }
      if (dist13 < min_dist13) {
        min_dist13 = dist13;
        index13 = i;
      }
      if (dist14 < min_dist14) {
        min_dist14 = dist14;
        index14 = i;
      }
      if (dist15 < min_dist15) {
        min_dist15 = dist15;
        index15 = i;
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
    membership[hook(2, point_id8)] = index8;
    membership[hook(2, point_id9)] = index9;
    membership[hook(2, point_id10)] = index10;
    membership[hook(2, point_id11)] = index11;
    membership[hook(2, point_id12)] = index12;
    membership[hook(2, point_id13)] = index13;
    membership[hook(2, point_id14)] = index14;
    membership[hook(2, point_id15)] = index15;
  }
}