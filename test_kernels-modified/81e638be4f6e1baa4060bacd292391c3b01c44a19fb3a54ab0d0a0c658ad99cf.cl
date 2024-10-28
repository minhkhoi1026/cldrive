//{"input":0,"max_items":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inc(global float* input, global float* output, const unsigned int max_items) {
  int i = get_global_id(0);
  if (i < max_items)
    output[hook(1, i)] = input[hook(0, i)] + 1;
}