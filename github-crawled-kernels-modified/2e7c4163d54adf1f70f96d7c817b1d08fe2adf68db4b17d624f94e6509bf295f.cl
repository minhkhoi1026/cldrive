//{"input":1,"output":0,"stride":3,"summary":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blockPrefixSum(global unsigned int* output, global unsigned int* input, global unsigned int* summary, int stride) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int Index = gidy * stride + gidx;
  output[hook(0, Index)] = 0;

  if (gidx > 0) {
    for (int i = 0; i < gidx; i++)
      output[hook(0, Index)] += input[hook(1, gidy * stride + i)];
  }

  if (gidx == (stride - 1))
    summary[hook(2, gidy)] = output[hook(0, Index)] + input[hook(1, gidy * stride + (stride - 1))];
}