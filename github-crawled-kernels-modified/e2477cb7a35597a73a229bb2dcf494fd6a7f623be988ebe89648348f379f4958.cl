//{"gInput":0,"outputArr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void RGB2Gray(const global float* gInput, global float* outputArr) {
  int gx = (int)get_global_id(0);
  int gy = (int)get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int gid = gy * width + gx;

  outputArr[hook(1, gid)] = (gInput[hook(0, gid)] + gInput[hook(0, width * height + gid)] + gInput[hook(0, 2 * width * height + gid)]) / 3;
}