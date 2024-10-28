//{"block":0,"dataptr":9,"descaler":6,"descaler_offset":7,"divisor_offset":2,"divisors":1,"indices":5,"lblock":8,"multiplier":3,"sign":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dct_quant(global short* block, global short* divisors, unsigned int divisor_offset, global short* multiplier, global int* sign, global int* indices, global char* descaler, global short* descaler_offset) {
  unsigned int product;
  unsigned short recip, corr;
  short ioffset, moffset, soffset, doffset;
  short t0, t1, t2, t3, res, neg;
  int value;
  local short* dataptr;
  int shift;

  size_t gx = get_global_id(0);
  size_t lx = get_local_id(0);

  short row = lx >> 0x3;
  short row_offset = (row) << 0x3;
  short column = lx & 0x7;

  local short lblock[0x40];
  lblock[hook(8, lx)] = block[hook(0, gx)];
  barrier(0x01);
  dataptr = &lblock[hook(8, row_offset)];

  ioffset = column << 0x3;
  moffset = column << 0x2;
  soffset = column << 0x1;
  doffset = column << 0x1;
  t0 = dataptr[hook(9, indices[ihook(5, ioffset + 0))] + (dataptr[hook(9, indices[ihook(5, ioffset + 1))] * sign[hook(4, soffset + 0)]);
  t1 = dataptr[hook(9, indices[ihook(5, ioffset + 2))] + (dataptr[hook(9, indices[ihook(5, ioffset + 3))] * sign[hook(4, soffset + 0)]);
  t2 = dataptr[hook(9, indices[ihook(5, ioffset + 4))] + (dataptr[hook(9, indices[ihook(5, ioffset + 5))] * sign[hook(4, soffset + 0)]);
  t3 = dataptr[hook(9, indices[ihook(5, ioffset + 6))] + (dataptr[hook(9, indices[ihook(5, ioffset + 7))] * sign[hook(4, soffset + 0)]);
  value = t0 * multiplier[hook(3, moffset + 0)] + (t1 + t0) * multiplier[hook(3, moffset + 1)] + (t2 + t0) * multiplier[hook(3, moffset + 2)] + ((t0 + t1) + ((t2 + t3) * sign[hook(4, soffset + 1)])) * multiplier[hook(3, moffset + 3)];
  res = (short)(((value) + (1 << ((0xB) - 1))) >> (0xB)) * descaler[hook(6, doffset + 0)] + ((int)((unsigned int)(value) << (0x2))) * descaler[hook(6, doffset + 1)];

  barrier(0x01);
  lblock[hook(8, lx)] = res;
  barrier(0x01);

  dataptr = &lblock[hook(8, column)];

  ioffset = row << 0x3;
  moffset = row << 0x2;
  soffset = row << 0x1;
  t0 = dataptr[hook(9, indiceshook(5, ioffset + 0)0] << 3)] + (dataptr[hook(9, indiceshook(5, ioffset + 1)1] << 3)] * sign[hook(4, soffset + 0)]);
  t1 = dataptr[hook(9, indiceshook(5, ioffset + 2)2] << 3)] + (dataptr[hook(9, indiceshook(5, ioffset + 3)3] << 3)] * sign[hook(4, soffset + 0)]);
  t2 = dataptr[hook(9, indiceshook(5, ioffset + 4)4] << 3)] + (dataptr[hook(9, indiceshook(5, ioffset + 5)5] << 3)] * sign[hook(4, soffset + 0)]);
  t3 = dataptr[hook(9, indiceshook(5, ioffset + 6)6] << 3)] + (dataptr[hook(9, indiceshook(5, ioffset + 7)7] << 3)] * sign[hook(4, soffset + 0)]);
  value = t0 * multiplier[hook(3, moffset + 0)] + (t1 + t0) * multiplier[hook(3, moffset + 1)] + (t2 + t0) * multiplier[hook(3, moffset + 2)] + ((t0 + t1) + ((t2 + t3) * sign[hook(4, soffset + 1)])) * multiplier[hook(3, moffset + 3)];
  res = (((value) + (1 << ((0x2 + descaler_offset[hook(7, row)]) - 1))) >> (0x2 + descaler_offset[hook(7, row)]));

  recip = divisors[hook(1, divisor_offset + lx + 64 * 0)];
  corr = divisors[hook(1, divisor_offset + lx + 64 * 1)];
  shift = divisors[hook(1, divisor_offset + lx + 64 * 3)];
  neg = res < 0 ? -1 : 1;
  res *= neg;
  product = (unsigned int)(res + corr) * recip;
  product >>= shift + sizeof(short) * 8;
  res = (short)product;
  res *= neg;
  block[hook(0, gx)] = (short)res;
}