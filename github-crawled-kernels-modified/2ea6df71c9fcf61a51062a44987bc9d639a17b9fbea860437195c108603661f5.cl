//{"in1":0,"in2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void aggregate(global int* in1, global int* in2, global int* output) {
  int i = get_global_id(0);
  output[hook(2, i)] = in1[hook(0, i)] + in2[hook(1, i)];
}