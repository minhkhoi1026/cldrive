//{"in":0,"in_short":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelSelection_half_improved(global short2* in, global short* out) {
  int i = get_global_id(0);
  int n = get_global_size(0);
  global short* in_short = (global short*)in;
  int ith = in_short[hook(2, i)];
  int pos = 0, j = 0;
  do {
    short2 tmp = in[hook(0, j >> 1)];
    int jth = tmp.x;
    bool smaller = (jth < ith);
    bool equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
    jth = tmp.y;
    smaller = (jth < ith);
    equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
  } while (j != n);
  out[hook(1, pos)] = ith;
}