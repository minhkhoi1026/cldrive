//{"((__global unsigned int *)Camellia_global_SBOX)":5,"((__local unsigned int *)Camellia_SBOX[0])":3,"((__local unsigned int *)Camellia_SBOX[1])":6,"((__local unsigned int *)Camellia_SBOX[2])":7,"((__local unsigned int *)Camellia_SBOX[3])":8,"(k + 0)":18,"(k + 10)":9,"(k + 2)":17,"(k + 4)":16,"(k + 6)":15,"(k + 8)":14,"Camellia_SBOX":4,"Camellia_SBOX[0]":12,"Camellia_SBOX[1]":10,"Camellia_SBOX[2]":13,"Camellia_SBOX[3]":11,"Camellia_global_SBOX":2,"data":0,"k":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CMLLdecKernel(global unsigned long* data, constant unsigned int* k, global unsigned int* Camellia_global_SBOX) {
  local unsigned int Camellia_SBOX[4][256];

  ((local unsigned int*)Camellia_SBOX[hook(4, 0)])[hook(3, get_local_id(0))] = ((global unsigned int*)Camellia_global_SBOX)[hook(5, get_local_id(0))];
  ((local unsigned int*)Camellia_SBOX[hook(4, 1)])[hook(6, get_local_id(0))] = ((global unsigned int*)Camellia_global_SBOX)[hook(5, get_local_id(0) + 256)];
  ((local unsigned int*)Camellia_SBOX[hook(4, 2)])[hook(7, get_local_id(0))] = ((global unsigned int*)Camellia_global_SBOX)[hook(5, get_local_id(0) + 512)];
  ((local unsigned int*)Camellia_SBOX[hook(4, 3)])[hook(8, get_local_id(0))] = ((global unsigned int*)Camellia_global_SBOX)[hook(5, get_local_id(0) + 768)];

  barrier(0x01);

 private
  unsigned int s0, s1, s2, s3;
  k += 48;

 private
  unsigned long block = data[hook(0, get_global_id(0) * 2)];
  s0 = ((block >> 24L) & 0x000000ff) | ((block >> 8L) & 0x0000ff00) | ((block << 8L) & 0x00ff0000) | ((block << 24L) & 0xff000000), s1 = ((block >> 56L) & 0x000000ff) | ((block >> 40L) & 0x0000ff00) | ((block >> 24L) & 0x00ff0000) | ((block >> 8L) & 0xff000000);
  s1 ^= k[hook(1, 0)];
  s0 ^= k[hook(1, 1)];

  block = data[hook(0, (get_global_id(0) * 2) + 1)];
  s2 = ((block >> 24L) & 0x000000ff) | ((block >> 8L) & 0x0000ff00) | ((block << 8L) & 0x00ff0000) | ((block << 24L) & 0xff000000), s3 = ((block >> 56L) & 0x000000ff) | ((block >> 40L) & 0x0000ff00) | ((block >> 24L) & 0x00ff0000) | ((block >> 8L) & 0xff000000);
  s3 ^= k[hook(1, 2)];
  s2 ^= k[hook(1, 3)];

  k -= 12;
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 10)[hook(9, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 10)[hook(9, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 8)[hook(14, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 8)[hook(14, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 6)[hook(15, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 6)[hook(15, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 4)[hook(16, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 4)[hook(16, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 2)[hook(17, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 2)[hook(17, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 0)[hook(18, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 0)[hook(18, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);

  k -= 4;
  s1 ^= (((s0 & k[hook(1, 3)]) << (1)) + ((s0 & k[hook(1, 3)]) >> (32 - 1)));
  s2 ^= s3 | k[hook(1, 0)];
  s0 ^= s1 | k[hook(1, 2)];
  s3 ^= (((s2 & k[hook(1, 1)]) << (1)) + ((s2 & k[hook(1, 1)]) >> (32 - 1)));

  k -= 12;
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 10)[hook(9, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 10)[hook(9, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 8)[hook(14, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 8)[hook(14, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 6)[hook(15, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 6)[hook(15, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 4)[hook(16, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 4)[hook(16, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 2)[hook(17, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 2)[hook(17, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 0)[hook(18, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 0)[hook(18, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);

  k -= 4;
  s1 ^= (((s0 & k[hook(1, 3)]) << (1)) + ((s0 & k[hook(1, 3)]) >> (32 - 1)));
  s2 ^= s3 | k[hook(1, 0)];
  s0 ^= s1 | k[hook(1, 2)];
  s3 ^= (((s2 & k[hook(1, 1)]) << (1)) + ((s2 & k[hook(1, 1)]) >> (32 - 1)));

  k -= 12;
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 10)[hook(9, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 10)[hook(9, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 8)[hook(14, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 8)[hook(14, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 6)[hook(15, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 6)[hook(15, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 4)[hook(16, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 4)[hook(16, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s0 ^ (k + 2)[hook(17, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s1 ^ (k + 2)[hook(17, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s3 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s2 ^= _t2;
    s3 ^= _t2;
  } while (0);
  do {
    unsigned int _t0, _t1, _t2, _t3;
    _t0 = s2 ^ (k + 0)[hook(18, 1)];
    _t3 = Camellia_SBOX[hook(4, 1)][hook(10, _t0 & 255)];
    _t1 = s3 ^ (k + 0)[hook(18, 0)];
    _t3 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t0 >> 8) & 255)];
    _t2 = Camellia_SBOX[hook(4, 0)][hook(12, _t1 & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t0 >> 16) & 255)];
    _t2 ^= Camellia_SBOX[hook(4, 1)][hook(10, (_t1 >> 8) & 255)];
    _t3 ^= Camellia_SBOX[hook(4, 0)][hook(12, (_t0 >> 24))];
    _t2 ^= _t3;
    _t3 = (((_t3) >> (8)) + ((_t3) << (32 - 8)));
    _t2 ^= Camellia_SBOX[hook(4, 3)][hook(11, (_t1 >> 16) & 255)];
    s1 ^= _t3;
    _t2 ^= Camellia_SBOX[hook(4, 2)][hook(13, (_t1 >> 24))];
    s0 ^= _t2;
    s1 ^= _t2;
  } while (0);

  k -= 4;
  s2 ^= k[hook(1, 1)], s3 ^= k[hook(1, 0)], s0 ^= k[hook(1, 3)], s1 ^= k[hook(1, 2)];

  block = ((unsigned long)s2) << 32 | s3;
  (block = block << 56 | ((block & 0x000000000000FF00) << 40) | ((block & 0x0000000000FF0000) << 24) | ((block & 0x00000000FF000000) << 8) | ((block & 0x000000FF00000000) >> 8) | ((block & 0x0000FF0000000000) >> 24) | ((block & 0x00FF000000000000) >> 40) | block >> 56);
  data[hook(0, get_global_id(0) * 2)] = block;

  block = ((unsigned long)s0) << 32 | s1;
  (block = block << 56 | ((block & 0x000000000000FF00) << 40) | ((block & 0x0000000000FF0000) << 24) | ((block & 0x00000000FF000000) << 8) | ((block & 0x000000FF00000000) >> 8) | ((block & 0x0000FF0000000000) >> 24) | ((block & 0x00FF000000000000) >> 40) | block >> 56);
  data[hook(0, (get_global_id(0) * 2) + 1)] = block;
}