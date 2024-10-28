//{"aux":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelSelection_Local(global const unsigned int* in, global unsigned int* out, local unsigned int* aux) {
  int i = get_local_id(0);
  int wg = get_local_size(0);

  int offset = get_group_id(0) * wg;
  in += offset;
  out += offset;

  unsigned int iData = in[hook(0, i)];
  aux[hook(2, i)] = iData;
  barrier(0x01);

  unsigned int iKey = iData;
  int pos = 0;
  for (int j = 0; j < wg; j++) {
    unsigned int jKey = aux[hook(2, j)];
    bool smaller = (jKey < iKey) || (jKey == iKey && j < i);
    pos += (smaller) ? 1 : 0;
  }

  out[hook(1, pos)] = iData;
}