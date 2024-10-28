//{"dir":3,"in":0,"inc":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelBitonic_A(global const unsigned int* restrict in, global unsigned int* restrict out, int inc, int dir) {
  int i = get_global_id(0);
  int j = i ^ inc;

  unsigned int iData = in[hook(0, i)];
  unsigned int iKey = iData;
  unsigned int jData = in[hook(0, j)];
  unsigned int jKey = jData;

  bool smaller = (jKey < iKey) || (jKey == iKey && j < i);
  bool swap = smaller ^ (j < i) ^ ((dir & i) != 0);

  out[hook(1, i)] = (swap) ? jData : iData;
}