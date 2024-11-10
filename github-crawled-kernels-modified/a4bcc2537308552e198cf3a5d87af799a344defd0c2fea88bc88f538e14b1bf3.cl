//{"gInput":0,"outputArr":1,"scalaradd":2,"scalarmul":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addMulScalar(const global float* gInput, global float* outputArr, float scalaradd, float scalarmul) {
  int gx = (int)get_global_id(0);
  int gy = (int)get_global_id(1);
  int gz = (int)get_global_id(2);
  int gid = mad24(gz, (int)get_global_size(0) * (int)get_global_size(1), mad24(gy, (int)get_global_size(0), gx));
  outputArr[hook(1, gid)] = (gInput[hook(0, gid)] + scalaradd) * scalarmul;
}