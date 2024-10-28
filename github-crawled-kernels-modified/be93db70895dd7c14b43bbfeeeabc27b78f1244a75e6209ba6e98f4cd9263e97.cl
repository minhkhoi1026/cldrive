//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Split(global float* input, global float* output) {
  int gid = get_global_id(0);
  if ((gid & 0x1) == 0) {
    gid = (gid & !63) + 62 - get_local_id(0);
  }
  output[hook(1, gid)] = input[hook(0, gid)];
}