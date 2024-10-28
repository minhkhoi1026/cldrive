//{"keys":0,"nt_buffer":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nt_crypt(const global unsigned int* keys, global unsigned int* output) {
  unsigned int i = get_global_id(0);

  unsigned int nt_buffer[12];

  unsigned int nt_index = 0;
  unsigned int md4_size = 0;

  unsigned int num_keys = get_global_size(0);
  unsigned int key_chars = keys[hook(0, i)];
  unsigned int cache_key = (((key_chars) >> 0) & 0xFF);

  int jump = 0;
  while (cache_key) {
    md4_size++;
    unsigned int temp = (((key_chars) >> 8) & 0xFF);
    nt_buffer[hook(2, nt_index)] = ((temp ? temp : 0x80) << 16) | cache_key;

    if (!temp) {
      jump = 1;
      break;
    }

    md4_size++;
    nt_index++;
    cache_key = (((key_chars) >> 16) & 0xFF);

    if (!cache_key)
      break;

    md4_size++;
    temp = (((key_chars) >> 24) & 0xFF);
    nt_buffer[hook(2, nt_index)] = ((temp ? temp : 0x80) << 16) | cache_key;

    if (!temp) {
      jump = 1;
      break;
    }

    md4_size++;
    nt_index++;

    key_chars = keys[hook(0, (md4_size >> 2) * num_keys + i)];
    cache_key = (((key_chars) >> 0) & 0xFF);
  }

  if (!jump)
    nt_buffer[hook(2, nt_index)] = 0x80;

  nt_index++;
  for (; nt_index < 12; nt_index++)
    nt_buffer[hook(2, nt_index)] = 0;

  md4_size = md4_size << 4;

  unsigned int a;
  unsigned int b;
  unsigned int c;
  unsigned int d;

  a = 0xFFFFFFFF + nt_buffer[hook(2, 0)];
  a = rotate(a, 3u);
  d = 0x10325476 + (0x98badcfe ^ (a & 0x77777777)) + nt_buffer[hook(2, 1)];
  d = rotate(d, 7u);
  c = 0x98badcfe + (0xefcdab89 ^ (d & (a ^ 0xefcdab89))) + nt_buffer[hook(2, 2)];
  c = rotate(c, 11u);
  b = 0xefcdab89 + (a ^ (c & (d ^ a))) + nt_buffer[hook(2, 3)];
  b = rotate(b, 19u);

  a += (d ^ (b & (c ^ d))) + nt_buffer[hook(2, 4)];
  a = rotate(a, 3u);
  d += (c ^ (a & (b ^ c))) + nt_buffer[hook(2, 5)];
  d = rotate(d, 7u);
  c += (b ^ (d & (a ^ b))) + nt_buffer[hook(2, 6)];
  c = rotate(c, 11u);
  b += (a ^ (c & (d ^ a))) + nt_buffer[hook(2, 7)];
  b = rotate(b, 19u);

  a += (d ^ (b & (c ^ d))) + nt_buffer[hook(2, 8)];
  a = rotate(a, 3u);
  d += (c ^ (a & (b ^ c))) + nt_buffer[hook(2, 9)];
  d = rotate(d, 7u);
  c += (b ^ (d & (a ^ b))) + nt_buffer[hook(2, 10)];
  c = rotate(c, 11u);
  b += (a ^ (c & (d ^ a))) + nt_buffer[hook(2, 11)];
  b = rotate(b, 19u);

  a += (d ^ (b & (c ^ d)));
  a = rotate(a, 3u);
  d += (c ^ (a & (b ^ c)));
  d = rotate(d, 7u);
  c += (b ^ (d & (a ^ b))) + md4_size;
  c = rotate(c, 11u);
  b += (a ^ (c & (d ^ a)));
  b = rotate(b, 19u);

  a += ((b & (c | d)) | (c & d)) + nt_buffer[hook(2, 0)] + 0x5a827999;
  a = rotate(a, 3u);
  d += ((a & (b | c)) | (b & c)) + nt_buffer[hook(2, 4)] + 0x5a827999;
  d = rotate(d, 5u);
  c += ((d & (a | b)) | (a & b)) + nt_buffer[hook(2, 8)] + 0x5a827999;
  c = rotate(c, 9u);
  b += ((c & (d | a)) | (d & a)) + 0x5a827999;
  b = rotate(b, 13u);

  a += ((b & (c | d)) | (c & d)) + nt_buffer[hook(2, 1)] + 0x5a827999;
  a = rotate(a, 3u);
  d += ((a & (b | c)) | (b & c)) + nt_buffer[hook(2, 5)] + 0x5a827999;
  d = rotate(d, 5u);
  c += ((d & (a | b)) | (a & b)) + nt_buffer[hook(2, 9)] + 0x5a827999;
  c = rotate(c, 9u);
  b += ((c & (d | a)) | (d & a)) + 0x5a827999;
  b = rotate(b, 13u);

  a += ((b & (c | d)) | (c & d)) + nt_buffer[hook(2, 2)] + 0x5a827999;
  a = rotate(a, 3u);
  d += ((a & (b | c)) | (b & c)) + nt_buffer[hook(2, 6)] + 0x5a827999;
  d = rotate(d, 5u);
  c += ((d & (a | b)) | (a & b)) + nt_buffer[hook(2, 10)] + 0x5a827999;
  c = rotate(c, 9u);
  b += ((c & (d | a)) | (d & a)) + md4_size + 0x5a827999;
  b = rotate(b, 13u);

  a += ((b & (c | d)) | (c & d)) + nt_buffer[hook(2, 3)] + 0x5a827999;
  a = rotate(a, 3u);
  d += ((a & (b | c)) | (b & c)) + nt_buffer[hook(2, 7)] + 0x5a827999;
  d = rotate(d, 5u);
  c += ((d & (a | b)) | (a & b)) + nt_buffer[hook(2, 11)] + 0x5a827999;
  c = rotate(c, 9u);
  b += ((c & (d | a)) | (d & a)) + 0x5a827999;
  b = rotate(b, 13u);

  a += (d ^ c ^ b) + nt_buffer[hook(2, 0)] + 0x6ed9eba1;
  a = rotate(a, 3u);
  d += (c ^ b ^ a) + nt_buffer[hook(2, 8)] + 0x6ed9eba1;
  d = rotate(d, 9u);
  c += (b ^ a ^ d) + nt_buffer[hook(2, 4)] + 0x6ed9eba1;
  c = rotate(c, 11u);
  b += (a ^ d ^ c) + 0x6ed9eba1;
  b = rotate(b, 15u);

  a += (d ^ c ^ b) + nt_buffer[hook(2, 2)] + 0x6ed9eba1;
  a = rotate(a, 3u);
  d += (c ^ b ^ a) + nt_buffer[hook(2, 10)] + 0x6ed9eba1;
  d = rotate(d, 9u);
  c += (b ^ a ^ d) + nt_buffer[hook(2, 6)] + 0x6ed9eba1;
  c = rotate(c, 11u);
  b += (a ^ d ^ c) + md4_size + 0x6ed9eba1;
  b = rotate(b, 15u);

  a += (d ^ c ^ b) + nt_buffer[hook(2, 1)] + 0x6ed9eba1;
  a = rotate(a, 3u);
  d += (c ^ b ^ a) + nt_buffer[hook(2, 9)] + 0x6ed9eba1;
  d = rotate(d, 9u);
  c += (b ^ a ^ d) + nt_buffer[hook(2, 5)] + 0x6ed9eba1;
  c = rotate(c, 11u);

  b += (a ^ d ^ c);
  output[hook(1, i)] = b;
  b += 0x6ed9eba1;
  b = rotate(b, 15u);

  a += (b ^ c ^ d) + nt_buffer[hook(2, 3)] + 0x6ed9eba1;
  a = rotate(a, 3u);
  d += (a ^ b ^ c) + nt_buffer[hook(2, 11)] + 0x6ed9eba1;
  d = rotate(d, 9u);
  c += (d ^ a ^ b) + nt_buffer[hook(2, 7)] + 0x6ed9eba1;
  c = rotate(c, 11u);

  output[hook(1, 1 * num_keys + i)] = a;
  output[hook(1, 2 * num_keys + i)] = c;
  output[hook(1, 3 * num_keys + i)] = d;
}