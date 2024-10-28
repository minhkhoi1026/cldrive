//{"((__private uchar *)(W))":4,"W":3,"hashes":2,"index":1,"keys":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void md4(global const unsigned int* keys, global const unsigned int* index, global unsigned int* hashes) {
  unsigned int gid = get_global_id(0);
  unsigned int W[16] = {0};
  unsigned int i;
  unsigned int num_keys = get_global_size(0);
  unsigned int base = index[hook(1, gid)];
  unsigned int len = base & 63;
  unsigned int a, b, c, d;

  keys += base >> 6;

  for (i = 0; i < (len + 3) / 4; i++)
    W[hook(3, i)] = *keys++;

  ((uchar*)(W))[hook(4, len)] = (0x80);
  W[hook(3, 14)] = len << 3;

  a = 0x67452301;
  b = 0xefcdab89;
  c = 0x98badcfe;
  d = 0x10325476;

  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + (W[hook(3, 0)]);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + (W[hook(3, 1)]);
  (d) = rotate((d), (unsigned int)(7));
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + (W[hook(3, 2)]);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + (W[hook(3, 3)]);
  (b) = rotate((b), (unsigned int)(19));
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + (W[hook(3, 4)]);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + (W[hook(3, 5)]);
  (d) = rotate((d), (unsigned int)(7));
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + (W[hook(3, 6)]);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + (W[hook(3, 7)]);
  (b) = rotate((b), (unsigned int)(19));
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + (W[hook(3, 8)]);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + (W[hook(3, 9)]);
  (d) = rotate((d), (unsigned int)(7));
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + (W[hook(3, 10)]);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + (W[hook(3, 11)]);
  (b) = rotate((b), (unsigned int)(19));
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + (W[hook(3, 12)]);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + (W[hook(3, 13)]);
  (d) = rotate((d), (unsigned int)(7));
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + (W[hook(3, 14)]);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + (W[hook(3, 15)]);
  (b) = rotate((b), (unsigned int)(19));

  (a) += ((((b)) & (((c)) | ((d)))) | (((c)) & ((d)))) + (W[hook(3, 0)] + 0x5a827999);
  (a) = rotate((a), (unsigned int)(3));
  (d) += ((((a)) & (((b)) | ((c)))) | (((b)) & ((c)))) + (W[hook(3, 4)] + 0x5a827999);
  (d) = rotate((d), (unsigned int)(5));
  (c) += ((((d)) & (((a)) | ((b)))) | (((a)) & ((b)))) + (W[hook(3, 8)] + 0x5a827999);
  (c) = rotate((c), (unsigned int)(9));
  (b) += ((((c)) & (((d)) | ((a)))) | (((d)) & ((a)))) + (W[hook(3, 12)] + 0x5a827999);
  (b) = rotate((b), (unsigned int)(13));
  (a) += ((((b)) & (((c)) | ((d)))) | (((c)) & ((d)))) + (W[hook(3, 1)] + 0x5a827999);
  (a) = rotate((a), (unsigned int)(3));
  (d) += ((((a)) & (((b)) | ((c)))) | (((b)) & ((c)))) + (W[hook(3, 5)] + 0x5a827999);
  (d) = rotate((d), (unsigned int)(5));
  (c) += ((((d)) & (((a)) | ((b)))) | (((a)) & ((b)))) + (W[hook(3, 9)] + 0x5a827999);
  (c) = rotate((c), (unsigned int)(9));
  (b) += ((((c)) & (((d)) | ((a)))) | (((d)) & ((a)))) + (W[hook(3, 13)] + 0x5a827999);
  (b) = rotate((b), (unsigned int)(13));
  (a) += ((((b)) & (((c)) | ((d)))) | (((c)) & ((d)))) + (W[hook(3, 2)] + 0x5a827999);
  (a) = rotate((a), (unsigned int)(3));
  (d) += ((((a)) & (((b)) | ((c)))) | (((b)) & ((c)))) + (W[hook(3, 6)] + 0x5a827999);
  (d) = rotate((d), (unsigned int)(5));
  (c) += ((((d)) & (((a)) | ((b)))) | (((a)) & ((b)))) + (W[hook(3, 10)] + 0x5a827999);
  (c) = rotate((c), (unsigned int)(9));
  (b) += ((((c)) & (((d)) | ((a)))) | (((d)) & ((a)))) + (W[hook(3, 14)] + 0x5a827999);
  (b) = rotate((b), (unsigned int)(13));
  (a) += ((((b)) & (((c)) | ((d)))) | (((c)) & ((d)))) + (W[hook(3, 3)] + 0x5a827999);
  (a) = rotate((a), (unsigned int)(3));
  (d) += ((((a)) & (((b)) | ((c)))) | (((b)) & ((c)))) + (W[hook(3, 7)] + 0x5a827999);
  (d) = rotate((d), (unsigned int)(5));
  (c) += ((((d)) & (((a)) | ((b)))) | (((a)) & ((b)))) + (W[hook(3, 11)] + 0x5a827999);
  (c) = rotate((c), (unsigned int)(9));
  (b) += ((((c)) & (((d)) | ((a)))) | (((d)) & ((a)))) + (W[hook(3, 15)] + 0x5a827999);
  (b) = rotate((b), (unsigned int)(13));

  (a) += (((b)) ^ ((c)) ^ ((d))) + (W[hook(3, 0)] + 0x6ed9eba1);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((a)) ^ ((b)) ^ ((c))) + (W[hook(3, 8)] + 0x6ed9eba1);
  (d) = rotate((d), (unsigned int)(9));
  (c) += (((d)) ^ ((a)) ^ ((b))) + (W[hook(3, 4)] + 0x6ed9eba1);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((c)) ^ ((d)) ^ ((a))) + (W[hook(3, 12)] + 0x6ed9eba1);
  (b) = rotate((b), (unsigned int)(15));
  (a) += (((b)) ^ ((c)) ^ ((d))) + (W[hook(3, 2)] + 0x6ed9eba1);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((a)) ^ ((b)) ^ ((c))) + (W[hook(3, 10)] + 0x6ed9eba1);
  (d) = rotate((d), (unsigned int)(9));
  (c) += (((d)) ^ ((a)) ^ ((b))) + (W[hook(3, 6)] + 0x6ed9eba1);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((c)) ^ ((d)) ^ ((a))) + (W[hook(3, 14)] + 0x6ed9eba1);
  (b) = rotate((b), (unsigned int)(15));
  (a) += (((b)) ^ ((c)) ^ ((d))) + (W[hook(3, 1)] + 0x6ed9eba1);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((a)) ^ ((b)) ^ ((c))) + (W[hook(3, 9)] + 0x6ed9eba1);
  (d) = rotate((d), (unsigned int)(9));
  (c) += (((d)) ^ ((a)) ^ ((b))) + (W[hook(3, 5)] + 0x6ed9eba1);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((c)) ^ ((d)) ^ ((a))) + (W[hook(3, 13)] + 0x6ed9eba1);
  (b) = rotate((b), (unsigned int)(15));
  (a) += (((b)) ^ ((c)) ^ ((d))) + (W[hook(3, 3)] + 0x6ed9eba1);
  (a) = rotate((a), (unsigned int)(3));
  (d) += (((a)) ^ ((b)) ^ ((c))) + (W[hook(3, 11)] + 0x6ed9eba1);
  (d) = rotate((d), (unsigned int)(9));
  (c) += (((d)) ^ ((a)) ^ ((b))) + (W[hook(3, 7)] + 0x6ed9eba1);
  (c) = rotate((c), (unsigned int)(11));
  (b) += (((c)) ^ ((d)) ^ ((a))) + (W[hook(3, 15)] + 0x6ed9eba1);
  (b) = rotate((b), (unsigned int)(15));

  hashes[hook(2, gid)] = a + 0x67452301;
  hashes[hook(2, 1 * num_keys + gid)] = b + 0xefcdab89;
  hashes[hook(2, 2 * num_keys + gid)] = c + 0x98badcfe;
  hashes[hook(2, 3 * num_keys + gid)] = d + 0x10325476;
}