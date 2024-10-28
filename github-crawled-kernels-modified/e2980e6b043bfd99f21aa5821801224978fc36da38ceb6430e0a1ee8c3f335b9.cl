//{"img":0,"pro":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_f_mip(global float* img, global float* pro) {
  int i = get_global_id(0);
  pro[hook(1, i)] = img[hook(0, i)] > pro[hook(1, i)] ? img[hook(0, i)] : pro[hook(1, i)];
}