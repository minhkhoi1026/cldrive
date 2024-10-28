//{"in":1,"lv":3,"lv_size":4,"out":2,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_input(int size, global int* in, global int* out, local int* lv, int lv_size) {
  int2 globalId = (int2)(get_global_id(0), get_global_id(1));
  int2 localId = (int2)(get_local_id(0), get_local_id(1));
  int2 groupId = (int2)(get_group_id(0), get_group_id(1));
  int2 globalSize = (int2)(get_global_size(0), get_global_size(1));
  int2 locallSize = (int2)(get_local_size(0), get_local_size(1));
  if (globalId.x + globalId.y * globalSize.x >= size) {
    return;
  }

  int gIdx = globalId.x + globalId.y * globalSize.x;
  int lIdx = gIdx % lv_size;
  lv[hook(3, lIdx)] = globalId.y + globalId.x * globalSize.y;
  if (lIdx >= 512) {
    lv[hook(3, lIdx)] -= 128;
  }

  out[hook(2, gIdx)] = lv[hook(3, lIdx)] - gIdx;
}