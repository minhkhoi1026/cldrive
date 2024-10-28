//{"in":0,"iter":1,"twiddle":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void butterfly_hard_float(global float2* in, int iter, global float2* twiddle) {
  unsigned indx = get_global_id(0);
  unsigned size = get_global_size(0);

  int pairDistance = 1 << iter;
  int blockWidth = 2 * pairDistance;
  int nGroups = size >> iter;
  int butterflyGrpOffset = indx & (pairDistance - 1);

  int leftIndx = (indx >> iter) * (blockWidth) + butterflyGrpOffset;
  int rightIndx = leftIndx + pairDistance;

  int l = nGroups * butterflyGrpOffset;

  float2 a, b, bxx, byy, w, wayx, wbyx, resa, resb;

  a = in[hook(0, leftIndx)];
  b = in[hook(0, rightIndx)];
  bxx = b.xx;
  byy = b.yy;
  w = twiddle[hook(2, l)];

  wayx.x = -w.y;

  wayx.y = w.x;
  wbyx.x = w.y;
  wbyx.y = -w.x;

  resa = a + bxx * w + byy * wayx;
  bxx.x = -bxx.x;
  bxx.y = -bxx.y;

  resb = a + bxx * w + byy * wbyx;

  in[hook(0, leftIndx)] = resa;
  in[hook(0, rightIndx)] = resb;
}