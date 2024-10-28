//{"cmp":3,"dest":0,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void select_short_short(global short* dest, global short* src1, global short* src2, global short* cmp) {
  size_t tid = get_global_id(0);
  if (tid < get_global_size(0))
    dest[hook(0, tid)] = select(src1[hook(1, tid)], src2[hook(2, tid)], cmp[hook(3, tid)]);
}