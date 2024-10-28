//{"flag":5,"iter":4,"m":2,"n":3,"w":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void butterfly(global float2* x, global float2* w, int m, int n, int iter, unsigned int flag) {
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

  float2 xa, xb, xbxx, xbyy, wab, wayx, wbyx, resa, resb;

  xa = x[hook(0, a)];
  xb = x[hook(0, b)];
  xbxx = xb.xx;
  xbyy = xb.yy;

  wab = __builtin_astype((__builtin_astype((w[hook(1, l)]), uint2) ^ (uint2)(0x0, flag)), float2);
  wayx = __builtin_astype((__builtin_astype((wab.yx), uint2) ^ (uint2)(0x80000000, 0x0)), float2);
  wbyx = __builtin_astype((__builtin_astype((wab.yx), uint2) ^ (uint2)(0x0, 0x80000000)), float2);

  resa = xa + xbxx * wab + xbyy * wayx;
  resb = xa - xbxx * wab + xbyy * wbyx;

  x[hook(0, a)] = resa;
  x[hook(0, b)] = resb;
}