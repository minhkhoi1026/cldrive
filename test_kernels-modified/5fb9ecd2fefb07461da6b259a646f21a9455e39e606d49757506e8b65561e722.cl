//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NoCoal(global float* input, global float* output) {
  int gid = get_global_id(0) - 1;
  if ((get_local_id(0) & 0xf) == 0)
    gid += 16;
  output[hook(1, gid)] = input[hook(0, gid)];
}