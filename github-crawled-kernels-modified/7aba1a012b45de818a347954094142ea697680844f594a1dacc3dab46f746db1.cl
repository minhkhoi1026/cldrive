//{"input":0,"output":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blockAdd(global unsigned int* input, global unsigned int* output, unsigned int stride) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int bidx = get_group_id(0);
  int bidy = get_group_id(1);

  int gpos = gidy + (gidx << 8);

  int groupIndex = bidy * stride + bidx;

  unsigned int temp;
  temp = input[hook(0, groupIndex)];

  output[hook(1, gpos)] += temp;
}