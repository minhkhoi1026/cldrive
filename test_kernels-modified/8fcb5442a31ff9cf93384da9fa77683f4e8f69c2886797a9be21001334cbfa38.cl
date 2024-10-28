//{"_buf0":1,"index":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_if(global int* index, global float* _buf0) {
  const unsigned int i = get_global_id(0);
  const float value = _buf0[hook(1, i)];
  if ((isinf(value)) || (isnan(value))) {
    atomic_min(index, i);
  }
}