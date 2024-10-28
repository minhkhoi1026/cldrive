//{"in1":1,"in2":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecAdd(global float* const restrict out, global const float* const restrict in1, global const float* const restrict in2) {
  const size_t id = get_global_id(0);
  out[hook(0, id)] = in1[hook(1, id)] + in2[hook(2, id)];
}