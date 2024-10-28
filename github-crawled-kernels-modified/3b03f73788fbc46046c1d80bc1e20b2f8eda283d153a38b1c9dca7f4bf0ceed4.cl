//{"_buf0":1,"_buf1":2,"_buf2":3,"p_count":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void search(unsigned int p_count, global char* _buf0, global char* _buf1, global unsigned int* _buf2) {
  unsigned int i = get_global_id(0);
  const unsigned int i1 = i;
  unsigned int j;
  for (j = 0; j < p_count; j++, i++) {
    if (_buf0[hook(1, j)] != _buf1[hook(2, i)])
      j = p_count + 1;
  }
  if (j == p_count)
    _buf2[hook(3, i1)] = 1;
  else
    _buf2[hook(3, i1)] = 0;
}