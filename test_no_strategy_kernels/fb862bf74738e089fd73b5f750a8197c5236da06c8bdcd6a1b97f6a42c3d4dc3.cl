//{"feature":0,"feature_swap":1,"nfeatures":3,"npoints":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kmeans_kernel_swap(global float* feature, global float* feature_swap, int npoints, int nfeatures) {
  unsigned int tid = get_global_id(0);
  if (tid >= npoints)
    return;

  for (int i = 0; i < nfeatures; i++)
    feature_swap[hook(1, i * npoints + tid)] = feature[hook(0, tid * nfeatures + i)];
}