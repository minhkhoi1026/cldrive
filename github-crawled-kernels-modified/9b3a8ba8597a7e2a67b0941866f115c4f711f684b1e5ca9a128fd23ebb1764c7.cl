//{"dispRange":3,"im1":0,"im2":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inplace_sum_views_ocl(global float* im1, global float* im2, int width, int dispRange) {
  int j = get_global_id(0);
  int i = get_global_id(1);
  int d = get_global_id(2);
  im1[hook(0, dispRange * (width * i + j) + d)] += im2[hook(1, dispRange * (width * i + j) + d)];
}