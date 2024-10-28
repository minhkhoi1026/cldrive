//{"in1":0,"out":1,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void div_hard_float(global float* in1, global float* out, float val) {
  int x = get_global_id(0);
  out[hook(1, x)] = in1[hook(0, x)] / val;
}