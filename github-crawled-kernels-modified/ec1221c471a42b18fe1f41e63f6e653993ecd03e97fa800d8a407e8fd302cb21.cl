//{"gInput1":0,"gInput2":1,"outputArr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void elemWiseDiv(const global float* gInput1, const global float* gInput2, global float* outputArr) {
  int gx = (int)get_global_id(0);
  int gy = (int)get_global_id(1);
  int gz = (int)get_global_id(2);
  int gid = mad24(gz, (int)get_global_size(0) * (int)get_global_size(1), mad24(gy, (int)get_global_size(0), gx));
  outputArr[hook(2, gid)] = gInput1[hook(0, gid)] / gInput2[hook(1, gid)];
}