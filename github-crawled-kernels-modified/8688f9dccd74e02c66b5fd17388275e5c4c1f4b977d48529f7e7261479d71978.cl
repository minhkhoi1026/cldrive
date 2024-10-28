//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy1DCompletePath(global float* input, global float* output) {
  int gid = get_global_id(0);
  if (gid < 0)
    atom_add((global int*)output, 1);
  output[hook(1, gid)] = input[hook(0, gid)];
  return;
}