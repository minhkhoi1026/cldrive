//{"bitmaps":5,"chbase":3,"dst":0,"found":6,"found_ind":4,"input":1,"singlehash":8,"size":2,"table":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mysql_old_markov(global uint2* dst, uint4 input, unsigned int size, uint16 chbase, global unsigned int* found_ind, global unsigned int* bitmaps, global unsigned int* found, global unsigned int* table, uint4 singlehash) {
  unsigned int l;
  unsigned int i, ib, ic, id, b1, b2, b3;
  unsigned int mOne, chbase1;
  unsigned int a, b, c, d, tmp, tmp1, tmp2, A, B;

  chbase1 = (unsigned int)(chbase.s0);

  i = table[hook(7, get_global_id(0))];
  ib = (unsigned int)i & 255;
  ic = (unsigned int)((i >> 8) & 255);
  id = (unsigned int)((i >> 16) & 255);

  if (size == 1) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 2) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 3) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 4) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 16) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 5) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 16) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 24) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 6) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 16) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 24) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.z & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }

  if (size == 7) {
    a = (unsigned int)1345345333;
    b = (unsigned int)0x12345671;
    c = (unsigned int)7;
    tmp = ib;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += ib;
    tmp = ic;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = id;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = chbase1;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.y & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 16) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.y >> 24) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = input.z & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    tmp = (input.z >> 8) & 255;
    a = a ^ (mad24(((a & 63) + c), tmp, (a << 8)));
    b += (b << 8) ^ a;
    c += tmp;
    A = a & ((1 << 31) - 1);
    B = b & ((1 << 31) - 1);
    {
      l = (A);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (A) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
    {
      l = (B);
      tmp1 = ((l) << (8)) + ((l) >> (32 - (8)));
      tmp2 = ((l) << (24)) + ((l) >> (32 - (24)));
      (B) = (tmp1 & 0x00FF00FF) | (tmp2 & 0xFF00FF00);
    };
  }
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