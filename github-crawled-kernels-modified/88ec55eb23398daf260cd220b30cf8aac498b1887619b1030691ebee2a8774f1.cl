//{"arg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void caffe_gpu_null_kernel(float arg) {
  float out = arg;
}