//{"_buf0":3,"_buf1":4,"data":1,"keys":0,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_insertion_sort_by_key_int(local int* keys, local int* data, unsigned int n, global int* _buf0, global int* _buf1) {
  for (unsigned int i = 0; i < n; i++) {
    keys[hook(0, i)] = _buf0[hook(3, i)];
    data[hook(1, i)] = _buf1[hook(4, i)];
  }
  for (unsigned int i = 1; i < n; i++) {
    const int key = keys[hook(0, i)];
    const int value = data[hook(1, i)];
    unsigned int pos = i;
    while (pos > 0 && ((key) < (keys[hook(0, pos - 1)]))) {
      keys[hook(0, pos)] = keys[hook(0, pos - 1)];
      data[hook(1, pos)] = data[hook(1, pos - 1)];
      pos--;
    }
    keys[hook(0, pos)] = key;
    data[hook(1, pos)] = value;
  }
  for (unsigned int i = 0; i < n; i++) {
    _buf0[hook(3, i)] = keys[hook(0, i)];
    _buf1[hook(4, i)] = data[hook(1, i)];
  }
}