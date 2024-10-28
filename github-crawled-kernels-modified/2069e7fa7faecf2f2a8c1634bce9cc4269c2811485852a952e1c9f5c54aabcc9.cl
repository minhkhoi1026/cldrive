//{"flag":5,"iter":4,"m":2,"n":3,"w":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void butterfly(global double2* x, global double2* w, int m, int n, int iter, ulong flag) {
  unsigned int gid = get_global_id(0);
  unsigned int nid = get_global_id(1);

  int butterflySize = 1 << (iter - 1);
  int butterflyGrpDist = 1 << iter;
  int butterflyGrpNum = n >> iter;
  int butterflyGrpBase = (gid >> (iter - 1)) * (butterflyGrpDist);
  int butterflyGrpOffset = gid & (butterflySize - 1);

  int a = nid * n + butterflyGrpBase + butterflyGrpOffset;
  int b = a + butterflySize;

  int l = butterflyGrpNum * butterflyGrpOffset;

  double2 xa, xb, xbxx, xbyy, wab, wayx, wbyx, resa, resb;

  xa = x[hook(0, a)];
  xb = x[hook(0, b)];
  xbxx = xb.xx;
  xbyy = xb.yy;

  wab = __builtin_astype((__builtin_astype((w[hook(1, l)]), ulong2) ^ (ulong2)(0x0UL, flag)), double2);
  wayx = __builtin_astype((__builtin_astype((wab.yx), ulong2) ^ (ulong2)(0x8000000000000000UL, 0x0UL)), double2);
  wbyx = __builtin_astype((__builtin_astype((wab.yx), ulong2) ^ (ulong2)(0x0UL, 0x8000000000000000UL)), double2);

  resa = xa + xbxx * wab + xbyy * wayx;
  resb = xa - xbxx * wab + xbyy * wbyx;

  x[hook(0, a)] = resa;
  x[hook(0, b)] = resb;
}