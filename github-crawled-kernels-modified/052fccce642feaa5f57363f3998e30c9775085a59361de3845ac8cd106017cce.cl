//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_hard_float(global float* in1, global float* in2, global float* out) {
  int indx = get_global_id(0);
  out[hook(2, indx)] = in1[hook(0, indx)] + in2[hook(1, indx)];
}