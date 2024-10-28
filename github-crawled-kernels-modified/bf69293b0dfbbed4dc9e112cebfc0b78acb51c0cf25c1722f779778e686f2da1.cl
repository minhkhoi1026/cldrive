//{"dst":1,"ldata":3,"pdata":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_generic_pointer_short(global short* src, global short* dst) {
  size_t gid = get_global_id(0);
  size_t lid = get_local_id(0);
 private
  short pdata[16];
  local short ldata[16];
  short* p1 = &pdata[hook(2, lid)];
  short* p2 = &ldata[hook(3, lid)];
  short* p = (gid & 1) ? p1 : p2;
  *p = src[hook(0, gid)];
  if (gid & 1) {
    ldata[hook(3, lid)] = 20;
  } else {
    for (int i = 0; i < 16; i++) {
      pdata[hook(2, i)] = src[hook(0, lid)];
      ;
    }
  }
  barrier(0x01);
  short* q1 = &pdata[hook(2, lid)];
  short* q2 = &ldata[hook(3, lid)];
  short* q = (gid & 1) ? q1 : q2;
  dst[hook(1, gid)] = *q + pdata[hook(2, lid)];
}