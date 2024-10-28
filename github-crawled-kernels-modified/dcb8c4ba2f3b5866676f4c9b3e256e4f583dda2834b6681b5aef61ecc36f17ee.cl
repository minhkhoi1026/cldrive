//{"bitmaps":5,"chbase":3,"dst":0,"found":6,"found_ind":4,"input":1,"singlehash":8,"size":2,"table":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mysql_old(global uint2* dst, uint4 input, unsigned int size, uint16 chbase, global unsigned int* found_ind, global unsigned int* bitmaps, global unsigned int* found, global unsigned int* table, uint4 singlehash) {
  unsigned int l;
  unsigned int i, ib, ic, id, b1, b2, b3;
  unsigned int mOne;
  unsigned int a, b, c, d, tmp, tmp1, tmp2, A, B, chbase1;

  chbase1 = (unsigned int)(chbase.s0);
  i = table[hook(7, get_global_id(0))];
  ib = (unsigned int)i & 255;
  ic = (unsigned int)((i >> 8) & 255);
  id = (unsigned int)((i >> 16) & 255);

  a = input.x;
  b = input.y;
  c = input.z;

  a = a ^ (mad24(((a & 63) + c), chbase1, (a << 8)));
  b += (b << 8) ^ a;
  c += chbase1;
  a = a ^ (mad24(((a & 63) + c), ib, (a << 8)));
  b += (b << 8) ^ a;
  c += ib;
  a = a ^ (mad24(((a & 63) + c), ic, (a << 8)));
  b += (b << 8) ^ a;
  c += ic;
  a = a ^ (mad24(((a & 63) + c), id, (a << 8)));
  b += (b << 8) ^ a;
  c += id;
  A = a & 0x7FFFFFFF;

  {
    l = (A);
    tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
    tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
    (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
  };
  id = 0;
  b1 = A;
  b2 = B;
  b3 = (singlehash.x >> (B & 31)) & 1;
  if (b3)
    if (((bitmaps[hook(5, b1 >> 13)] >> (b1 & 31)) & 1) && ((bitmaps[hook(5, 65535 * 8 + (b2 >> 13))] >> (b2 & 31)) & 1))
      id = 1;
  if (id == 0)
    return;

  if (id == 1) {
    found[hook(6, 0)] = 1;
    found_ind[hook(4, get_global_id(0))] = 1;
  }

  dst[hook(0, (get_global_id(0)))] = (uint2)(A, B);
}