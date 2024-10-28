//{"in_size":2,"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum(global int* restrict output, global int* restrict input, const unsigned int in_size) {
  output[hook(0, 0)] = 0;
  for (int i = 1; i < 262143; i++)
    output[hook(0, i)] = output[hook(0, i - 1)] + input[hook(1, i - 1)];
}