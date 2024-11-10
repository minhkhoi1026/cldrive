//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelSelection_float(global float* in, global float* out) {
  int i = get_global_id(0);
  int n = get_global_size(0);
  float ith = in[hook(0, i)];

  int pos = 0, j = 0;
  do {
    float jth = in[hook(0, j)];
    bool smaller = (jth < ith);
    bool equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
  } while (j != n);
  out[hook(1, pos)] = ith;
}