//{"input1":0,"input2":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zero2(global float2* input1, global float2* input2, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    input1[hook(0, i)] = 0;
    input2[hook(1, i)] = 0;
  }
}