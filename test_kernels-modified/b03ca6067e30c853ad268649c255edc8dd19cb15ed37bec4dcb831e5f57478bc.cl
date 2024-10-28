//{"input":0,"k":2,"length":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CollectEveryKElement(global int* input, global int* output, int k, int length) {
  int globalID = get_global_id(0);
  if (globalID < length)
    output[hook(1, globalID)] = input[hook(0, globalID * k)];
}