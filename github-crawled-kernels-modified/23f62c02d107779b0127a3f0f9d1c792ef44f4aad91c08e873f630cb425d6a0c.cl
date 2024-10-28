//{"_buf0":2,"data":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_insertion_sort(local ulong* data, unsigned int n, global ulong* _buf0) {
  for (unsigned int i = 0; i < n; i++) {
    data[hook(0, i)] = _buf0[hook(2, i)];
  }
  for (unsigned int i = 1; i < n; i++) {
    const ulong value = data[hook(0, i)];
    unsigned int pos = i;
    while (pos > 0 && ((value) < (data[hook(0, pos - 1)]))) {
      data[hook(0, pos)] = data[hook(0, pos - 1)];
      pos--;
    }
    data[hook(0, pos)] = value;
  }
  for (unsigned int i = 0; i < n; i++) {
    _buf0[hook(2, i)] = data[hook(0, i)];
  }
}