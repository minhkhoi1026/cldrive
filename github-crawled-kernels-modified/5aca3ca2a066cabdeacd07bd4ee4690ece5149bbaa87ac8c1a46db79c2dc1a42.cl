//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy1Dfloat4(global float4* input, global float4* output) {
  int gid = get_global_id(0);
  output[hook(1, gid)] = input[hook(0, gid)];
  return;
}