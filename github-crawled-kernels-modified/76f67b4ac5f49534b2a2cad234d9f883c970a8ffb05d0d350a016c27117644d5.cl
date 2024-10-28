//{"_buf0":0,"index":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_extrema_max(global int* _buf0, global unsigned int* index) {
  const unsigned int gid = get_global_id(0);
  unsigned int old_index = *index;
  int old = _buf0[hook(0, old_index)];
  int new = _buf0[hook(0, gid)];
  bool compare_result;

  while ((compare_result = ((old) < (new))) || (!(compare_result || ((new) < (old))) && gid < old_index)) {
    if (atomic_cmpxchg(index, old_index, gid) == old_index)
      break;
    else
      old_index = *index;
    old = _buf0[hook(0, old_index)];
  }
}