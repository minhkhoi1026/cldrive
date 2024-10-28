//{"in":0,"out":1,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int __udivsi3(unsigned int a, unsigned int b) {
  unsigned q = 0, r = 0;
  r <<= 1;
  r += (a >> 31) & 1;
  q += r < b ? 0 : 1 << 31;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 30) & 1;
  q += r < b ? 0 : 1 << 30;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 29) & 1;
  q += r < b ? 0 : 1 << 29;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 28) & 1;
  q += r < b ? 0 : 1 << 28;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 27) & 1;
  q += r < b ? 0 : 1 << 27;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 26) & 1;
  q += r < b ? 0 : 1 << 26;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 25) & 1;
  q += r < b ? 0 : 1 << 25;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 24) & 1;
  q += r < b ? 0 : 1 << 24;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 23) & 1;
  q += r < b ? 0 : 1 << 23;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 22) & 1;
  q += r < b ? 0 : 1 << 22;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 21) & 1;
  q += r < b ? 0 : 1 << 21;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 20) & 1;
  q += r < b ? 0 : 1 << 20;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 19) & 1;
  q += r < b ? 0 : 1 << 19;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 18) & 1;
  q += r < b ? 0 : 1 << 18;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 17) & 1;
  q += r < b ? 0 : 1 << 17;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 16) & 1;
  q += r < b ? 0 : 1 << 16;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 15) & 1;
  q += r < b ? 0 : 1 << 15;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 14) & 1;
  q += r < b ? 0 : 1 << 14;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 13) & 1;
  q += r < b ? 0 : 1 << 13;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 12) & 1;
  q += r < b ? 0 : 1 << 12;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 11) & 1;
  q += r < b ? 0 : 1 << 11;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 10) & 1;
  q += r < b ? 0 : 1 << 10;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 9) & 1;
  q += r < b ? 0 : 1 << 9;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 8) & 1;
  q += r < b ? 0 : 1 << 8;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 7) & 1;
  q += r < b ? 0 : 1 << 7;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 6) & 1;
  q += r < b ? 0 : 1 << 6;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 5) & 1;
  q += r < b ? 0 : 1 << 5;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 4) & 1;
  q += r < b ? 0 : 1 << 4;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 3) & 1;
  q += r < b ? 0 : 1 << 3;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 2) & 1;
  q += r < b ? 0 : 1 << 2;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 1) & 1;
  q += r < b ? 0 : 1 << 1;
  r -= r < b ? 0 : b;

  r <<= 1;
  r += (a >> 0) & 1;
  q += r < b ? 0 : 1 << 0;
  r -= r < b ? 0 : b;
  return q;
}
int __divsi3(int a, int b) {
  unsigned int a_pos = a < 0 ? -a : a;
  unsigned int b_pos = b < 0 ? -b : b;
  unsigned int res_sign = ((a < 0) && (b < 0)) || (a >= 0 && b >= 0);
  unsigned res = a_pos / b_pos;
  return res_sign ? res : -res;
}
kernel void div_int(global int* in, global int* out, int val) {
  int x = get_global_id(0);
  out[hook(1, x)] = in[hook(0, x)] / val;
}