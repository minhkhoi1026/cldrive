//{"key_in":0,"key_out":2,"val_in":1,"val_out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelSelection(global const unsigned int* restrict key_in, global const unsigned int* restrict val_in, global unsigned int* restrict key_out, global unsigned int* restrict val_out) {
  int i = get_global_id(0);
  int n = get_global_size(0);
  unsigned int iKey = key_in[hook(0, i)];
  unsigned int iVal = val_in[hook(1, i)];

  int pos = 0;
  for (int j = 0; j < n; j++) {
    unsigned int jKey = key_in[hook(0, j)];
    bool smaller = (jKey < iKey) || (jKey == iKey && j < i);
    pos += (smaller) ? 1 : 0;
  }
  key_out[hook(2, pos)] = iKey;
  val_out[hook(3, pos)] = iVal;
}