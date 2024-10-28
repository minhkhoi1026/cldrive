//{"clusters":1,"feature":0,"membership":2,"nclusters":4,"nfeatures":5,"npoints":3,"offset":6,"size":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_compute(global float* feature, global float* clusters, global int* membership, int npoints, int nclusters, int nfeatures, int offset, int size) {
  unsigned int point_id = get_global_id(0);
  int index = 0;
  if (point_id < npoints) {
    float min_dist = 0x1.fffffep127f;
    for (int i = 0; i < nclusters; i++) {
      float dist = 0;
      float ans = 0;
      for (int l = 0; l < nfeatures; l++) {
        ans += (feature[hook(0, l * npoints + point_id)] - clusters[hook(1, i * nfeatures + l)]) * (feature[hook(0, l * npoints + point_id)] - clusters[hook(1, i * nfeatures + l)]);
      }

      dist = ans;
      if (dist < min_dist) {
        min_dist = dist;
        index = i;
      }
    }
    membership[hook(2, point_id)] = index;
  }

  return;
}