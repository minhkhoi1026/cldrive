//{"data":0,"idea_constant_schedule":1,"idea_schedule":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IDEAencKernel(global unsigned long* data, constant unsigned long* idea_constant_schedule) {
  local unsigned long idea_schedule[27];
  if (get_local_id(0) < 27)
    idea_schedule[hook(2, get_local_id(0))] = idea_constant_schedule[hook(1, get_local_id(0))];

  local unsigned int* p = (local unsigned int*)&idea_schedule;
 private
  unsigned int x1, x2, x3, x4, t0, t1, ul, l0, l1;
 private
  unsigned long block = data[hook(0, get_global_id(0))];

  x2 = ((block >> 24L) & 0x000000ff) | ((block >> 8L) & 0x0000ff00) | ((block << 8L) & 0x00ff0000) | ((block << 24L) & 0xff000000), x4 = ((block >> 56L) & 0x000000ff) | ((block >> 40L) & 0x0000ff00) | ((block >> 24L) & 0x00ff0000) | ((block >> 8L) & 0xff000000);

  x1 = (x2 >> 16);
  x3 = (x4 >> 16);

  barrier(0x01);

  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;
  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;
  x2 += *(p++);
  x3 += *(p++);
  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;
  p++;
  t0 = (x1 ^ x3) & 0xffff;
  ul = mul24(t0, *p);
  if (ul != 0) {
    t0 = (ul & 0xffff) - (ul >> 16);
    t0 -= ((t0) >> 16);
  } else
    t0 = (-(int)t0 - *p + 1);
  ;
  p++;
  t1 = (t0 + (x2 ^ x4)) & 0xffff;
  ul = mul24(t1, *p);
  if (ul != 0) {
    t1 = (ul & 0xffff) - (ul >> 16);
    t1 -= ((t1) >> 16);
  } else
    t1 = (-(int)t1 - *p + 1);
  ;
  p++;
  t0 += t1;
  x1 ^= t1;
  x4 ^= t0;
  ul = x2 ^ t0;
  x2 = x3 ^ t1;
  x3 = ul;
  ;

  x1 &= 0xffff;
  ul = mul24(x1, *p);
  if (ul != 0) {
    x1 = (ul & 0xffff) - (ul >> 16);
    x1 -= ((x1) >> 16);
  } else
    x1 = (-(int)x1 - *p + 1);
  ;
  p++;

  t0 = x3 + *(p++);
  t1 = x2 + *(p++);

  x4 &= 0xffff;
  ul = mul24(x4, *p);
  if (ul != 0) {
    x4 = (ul & 0xffff) - (ul >> 16);
    x4 -= ((x4) >> 16);
  } else
    x4 = (-(int)x4 - *p + 1);
  ;

  l0 = (t0 & 0xffff) | ((x1 & 0xffff) << 16);
  l1 = (x4 & 0xffff) | ((t1 & 0xffff) << 16);

  block = ((unsigned long)l0) << 32 | l1;
  (block = block << 56 | ((block & 0x000000000000FF00) << 40) | ((block & 0x0000000000FF0000) << 24) | ((block & 0x00000000FF000000) << 8) | ((block & 0x000000FF00000000) >> 8) | ((block & 0x0000FF0000000000) >> 24) | ((block & 0x00FF000000000000) >> 40) | block >> 56);
  data[hook(0, get_global_id(0))] = block;
}