//{"chars":9,"cracked_pw":4,"internal_state":5,"key":6,"maxlen_in":2,"msg":8,"out":7,"pw_hash":3,"starts":0,"stops":1,"this_hash":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void md5_round(unsigned int* internal_state, const unsigned int* key) {
  unsigned int a, b, c, d;
  a = internal_state[hook(5, 0)];
  b = internal_state[hook(5, 1)];
  c = internal_state[hook(5, 2)];
  d = internal_state[hook(5, 3)];

  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + ((key[hook(6, (0))])) + (0xd76aa478);
  (a) = (((a) << (7)) | (((a)&0xffffffff) >> (32 - (7))));
  (a) += (b);
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + ((key[hook(6, (1))])) + (0xe8c7b756);
  (d) = (((d) << (12)) | (((d)&0xffffffff) >> (32 - (12))));
  (d) += (a);
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + ((key[hook(6, (2))])) + (0x242070db);
  (c) = (((c) << (17)) | (((c)&0xffffffff) >> (32 - (17))));
  (c) += (d);
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + ((key[hook(6, (3))])) + (0xc1bdceee);
  (b) = (((b) << (22)) | (((b)&0xffffffff) >> (32 - (22))));
  (b) += (c);
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + ((key[hook(6, (4))])) + (0xf57c0faf);
  (a) = (((a) << (7)) | (((a)&0xffffffff) >> (32 - (7))));
  (a) += (b);
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + ((key[hook(6, (5))])) + (0x4787c62a);
  (d) = (((d) << (12)) | (((d)&0xffffffff) >> (32 - (12))));
  (d) += (a);
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + ((key[hook(6, (6))])) + (0xa8304613);
  (c) = (((c) << (17)) | (((c)&0xffffffff) >> (32 - (17))));
  (c) += (d);
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + ((key[hook(6, (7))])) + (0xfd469501);
  (b) = (((b) << (22)) | (((b)&0xffffffff) >> (32 - (22))));
  (b) += (c);
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + ((key[hook(6, (8))])) + (0x698098d8);
  (a) = (((a) << (7)) | (((a)&0xffffffff) >> (32 - (7))));
  (a) += (b);
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + ((key[hook(6, (9))])) + (0x8b44f7af);
  (d) = (((d) << (12)) | (((d)&0xffffffff) >> (32 - (12))));
  (d) += (a);
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + ((key[hook(6, (10))])) + (0xffff5bb1);
  (c) = (((c) << (17)) | (((c)&0xffffffff) >> (32 - (17))));
  (c) += (d);
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + ((key[hook(6, (11))])) + (0x895cd7be);
  (b) = (((b) << (22)) | (((b)&0xffffffff) >> (32 - (22))));
  (b) += (c);
  (a) += (((d)) ^ (((b)) & (((c)) ^ ((d))))) + ((key[hook(6, (12))])) + (0x6b901122);
  (a) = (((a) << (7)) | (((a)&0xffffffff) >> (32 - (7))));
  (a) += (b);
  (d) += (((c)) ^ (((a)) & (((b)) ^ ((c))))) + ((key[hook(6, (13))])) + (0xfd987193);
  (d) = (((d) << (12)) | (((d)&0xffffffff) >> (32 - (12))));
  (d) += (a);
  (c) += (((b)) ^ (((d)) & (((a)) ^ ((b))))) + ((key[hook(6, (14))])) + (0xa679438e);
  (c) = (((c) << (17)) | (((c)&0xffffffff) >> (32 - (17))));
  (c) += (d);
  (b) += (((a)) ^ (((c)) & (((d)) ^ ((a))))) + ((key[hook(6, (15))])) + (0x49b40821);
  (b) = (((b) << (22)) | (((b)&0xffffffff) >> (32 - (22))));
  (b) += (c);

  (a) += (((c)) ^ (((d)) & (((b)) ^ ((c))))) + ((key[hook(6, (1))])) + (0xf61e2562);
  (a) = (((a) << (5)) | (((a)&0xffffffff) >> (32 - (5))));
  (a) += (b);
  (d) += (((b)) ^ (((c)) & (((a)) ^ ((b))))) + ((key[hook(6, (6))])) + (0xc040b340);
  (d) = (((d) << (9)) | (((d)&0xffffffff) >> (32 - (9))));
  (d) += (a);
  (c) += (((a)) ^ (((b)) & (((d)) ^ ((a))))) + ((key[hook(6, (11))])) + (0x265e5a51);
  (c) = (((c) << (14)) | (((c)&0xffffffff) >> (32 - (14))));
  (c) += (d);
  (b) += (((d)) ^ (((a)) & (((c)) ^ ((d))))) + ((key[hook(6, (0))])) + (0xe9b6c7aa);
  (b) = (((b) << (20)) | (((b)&0xffffffff) >> (32 - (20))));
  (b) += (c);
  (a) += (((c)) ^ (((d)) & (((b)) ^ ((c))))) + ((key[hook(6, (5))])) + (0xd62f105d);
  (a) = (((a) << (5)) | (((a)&0xffffffff) >> (32 - (5))));
  (a) += (b);
  (d) += (((b)) ^ (((c)) & (((a)) ^ ((b))))) + ((key[hook(6, (10))])) + (0x02441453);
  (d) = (((d) << (9)) | (((d)&0xffffffff) >> (32 - (9))));
  (d) += (a);
  (c) += (((a)) ^ (((b)) & (((d)) ^ ((a))))) + ((key[hook(6, (15))])) + (0xd8a1e681);
  (c) = (((c) << (14)) | (((c)&0xffffffff) >> (32 - (14))));
  (c) += (d);
  (b) += (((d)) ^ (((a)) & (((c)) ^ ((d))))) + ((key[hook(6, (4))])) + (0xe7d3fbc8);
  (b) = (((b) << (20)) | (((b)&0xffffffff) >> (32 - (20))));
  (b) += (c);
  (a) += (((c)) ^ (((d)) & (((b)) ^ ((c))))) + ((key[hook(6, (9))])) + (0x21e1cde6);
  (a) = (((a) << (5)) | (((a)&0xffffffff) >> (32 - (5))));
  (a) += (b);
  (d) += (((b)) ^ (((c)) & (((a)) ^ ((b))))) + ((key[hook(6, (14))])) + (0xc33707d6);
  (d) = (((d) << (9)) | (((d)&0xffffffff) >> (32 - (9))));
  (d) += (a);
  (c) += (((a)) ^ (((b)) & (((d)) ^ ((a))))) + ((key[hook(6, (3))])) + (0xf4d50d87);
  (c) = (((c) << (14)) | (((c)&0xffffffff) >> (32 - (14))));
  (c) += (d);
  (b) += (((d)) ^ (((a)) & (((c)) ^ ((d))))) + ((key[hook(6, (8))])) + (0x455a14ed);
  (b) = (((b) << (20)) | (((b)&0xffffffff) >> (32 - (20))));
  (b) += (c);
  (a) += (((c)) ^ (((d)) & (((b)) ^ ((c))))) + ((key[hook(6, (13))])) + (0xa9e3e905);
  (a) = (((a) << (5)) | (((a)&0xffffffff) >> (32 - (5))));
  (a) += (b);
  (d) += (((b)) ^ (((c)) & (((a)) ^ ((b))))) + ((key[hook(6, (2))])) + (0xfcefa3f8);
  (d) = (((d) << (9)) | (((d)&0xffffffff) >> (32 - (9))));
  (d) += (a);
  (c) += (((a)) ^ (((b)) & (((d)) ^ ((a))))) + ((key[hook(6, (7))])) + (0x676f02d9);
  (c) = (((c) << (14)) | (((c)&0xffffffff) >> (32 - (14))));
  (c) += (d);
  (b) += (((d)) ^ (((a)) & (((c)) ^ ((d))))) + ((key[hook(6, (12))])) + (0x8d2a4c8a);
  (b) = (((b) << (20)) | (((b)&0xffffffff) >> (32 - (20))));
  (b) += (c);

  (a) += (((b)) ^ ((c)) ^ ((d))) + ((key[hook(6, (5))])) + (0xfffa3942);
  (a) = (((a) << (4)) | (((a)&0xffffffff) >> (32 - (4))));
  (a) += (b);
  (d) += (((a)) ^ ((b)) ^ ((c))) + ((key[hook(6, (8))])) + (0x8771f681);
  (d) = (((d) << (11)) | (((d)&0xffffffff) >> (32 - (11))));
  (d) += (a);
  (c) += (((d)) ^ ((a)) ^ ((b))) + ((key[hook(6, (11))])) + (0x6d9d6122);
  (c) = (((c) << (16)) | (((c)&0xffffffff) >> (32 - (16))));
  (c) += (d);
  (b) += (((c)) ^ ((d)) ^ ((a))) + ((key[hook(6, (14))])) + (0xfde5380c);
  (b) = (((b) << (23)) | (((b)&0xffffffff) >> (32 - (23))));
  (b) += (c);
  (a) += (((b)) ^ ((c)) ^ ((d))) + ((key[hook(6, (1))])) + (0xa4beea44);
  (a) = (((a) << (4)) | (((a)&0xffffffff) >> (32 - (4))));
  (a) += (b);
  (d) += (((a)) ^ ((b)) ^ ((c))) + ((key[hook(6, (4))])) + (0x4bdecfa9);
  (d) = (((d) << (11)) | (((d)&0xffffffff) >> (32 - (11))));
  (d) += (a);
  (c) += (((d)) ^ ((a)) ^ ((b))) + ((key[hook(6, (7))])) + (0xf6bb4b60);
  (c) = (((c) << (16)) | (((c)&0xffffffff) >> (32 - (16))));
  (c) += (d);
  (b) += (((c)) ^ ((d)) ^ ((a))) + ((key[hook(6, (10))])) + (0xbebfbc70);
  (b) = (((b) << (23)) | (((b)&0xffffffff) >> (32 - (23))));
  (b) += (c);
  (a) += (((b)) ^ ((c)) ^ ((d))) + ((key[hook(6, (13))])) + (0x289b7ec6);
  (a) = (((a) << (4)) | (((a)&0xffffffff) >> (32 - (4))));
  (a) += (b);
  (d) += (((a)) ^ ((b)) ^ ((c))) + ((key[hook(6, (0))])) + (0xeaa127fa);
  (d) = (((d) << (11)) | (((d)&0xffffffff) >> (32 - (11))));
  (d) += (a);
  (c) += (((d)) ^ ((a)) ^ ((b))) + ((key[hook(6, (3))])) + (0xd4ef3085);
  (c) = (((c) << (16)) | (((c)&0xffffffff) >> (32 - (16))));
  (c) += (d);
  (b) += (((c)) ^ ((d)) ^ ((a))) + ((key[hook(6, (6))])) + (0x04881d05);
  (b) = (((b) << (23)) | (((b)&0xffffffff) >> (32 - (23))));
  (b) += (c);
  (a) += (((b)) ^ ((c)) ^ ((d))) + ((key[hook(6, (9))])) + (0xd9d4d039);
  (a) = (((a) << (4)) | (((a)&0xffffffff) >> (32 - (4))));
  (a) += (b);
  (d) += (((a)) ^ ((b)) ^ ((c))) + ((key[hook(6, (12))])) + (0xe6db99e5);
  (d) = (((d) << (11)) | (((d)&0xffffffff) >> (32 - (11))));
  (d) += (a);
  (c) += (((d)) ^ ((a)) ^ ((b))) + ((key[hook(6, (15))])) + (0x1fa27cf8);
  (c) = (((c) << (16)) | (((c)&0xffffffff) >> (32 - (16))));
  (c) += (d);
  (b) += (((c)) ^ ((d)) ^ ((a))) + ((key[hook(6, (2))])) + (0xc4ac5665);
  (b) = (((b) << (23)) | (((b)&0xffffffff) >> (32 - (23))));
  (b) += (c);

  (a) += (((c)) ^ (((b)) | ~((d)))) + ((key[hook(6, (0))])) + (0xf4292244);
  (a) = (((a) << (6)) | (((a)&0xffffffff) >> (32 - (6))));
  (a) += (b);
  (d) += (((b)) ^ (((a)) | ~((c)))) + ((key[hook(6, (7))])) + (0x432aff97);
  (d) = (((d) << (10)) | (((d)&0xffffffff) >> (32 - (10))));
  (d) += (a);
  (c) += (((a)) ^ (((d)) | ~((b)))) + ((key[hook(6, (14))])) + (0xab9423a7);
  (c) = (((c) << (15)) | (((c)&0xffffffff) >> (32 - (15))));
  (c) += (d);
  (b) += (((d)) ^ (((c)) | ~((a)))) + ((key[hook(6, (5))])) + (0xfc93a039);
  (b) = (((b) << (21)) | (((b)&0xffffffff) >> (32 - (21))));
  (b) += (c);
  (a) += (((c)) ^ (((b)) | ~((d)))) + ((key[hook(6, (12))])) + (0x655b59c3);
  (a) = (((a) << (6)) | (((a)&0xffffffff) >> (32 - (6))));
  (a) += (b);
  (d) += (((b)) ^ (((a)) | ~((c)))) + ((key[hook(6, (3))])) + (0x8f0ccc92);
  (d) = (((d) << (10)) | (((d)&0xffffffff) >> (32 - (10))));
  (d) += (a);
  (c) += (((a)) ^ (((d)) | ~((b)))) + ((key[hook(6, (10))])) + (0xffeff47d);
  (c) = (((c) << (15)) | (((c)&0xffffffff) >> (32 - (15))));
  (c) += (d);
  (b) += (((d)) ^ (((c)) | ~((a)))) + ((key[hook(6, (1))])) + (0x85845dd1);
  (b) = (((b) << (21)) | (((b)&0xffffffff) >> (32 - (21))));
  (b) += (c);
  (a) += (((c)) ^ (((b)) | ~((d)))) + ((key[hook(6, (8))])) + (0x6fa87e4f);
  (a) = (((a) << (6)) | (((a)&0xffffffff) >> (32 - (6))));
  (a) += (b);
  (d) += (((b)) ^ (((a)) | ~((c)))) + ((key[hook(6, (15))])) + (0xfe2ce6e0);
  (d) = (((d) << (10)) | (((d)&0xffffffff) >> (32 - (10))));
  (d) += (a);
  (c) += (((a)) ^ (((d)) | ~((b)))) + ((key[hook(6, (6))])) + (0xa3014314);
  (c) = (((c) << (15)) | (((c)&0xffffffff) >> (32 - (15))));
  (c) += (d);
  (b) += (((d)) ^ (((c)) | ~((a)))) + ((key[hook(6, (13))])) + (0x4e0811a1);
  (b) = (((b) << (21)) | (((b)&0xffffffff) >> (32 - (21))));
  (b) += (c);
  (a) += (((c)) ^ (((b)) | ~((d)))) + ((key[hook(6, (4))])) + (0xf7537e82);
  (a) = (((a) << (6)) | (((a)&0xffffffff) >> (32 - (6))));
  (a) += (b);
  (d) += (((b)) ^ (((a)) | ~((c)))) + ((key[hook(6, (11))])) + (0xbd3af235);
  (d) = (((d) << (10)) | (((d)&0xffffffff) >> (32 - (10))));
  (d) += (a);
  (c) += (((a)) ^ (((d)) | ~((b)))) + ((key[hook(6, (2))])) + (0x2ad7d2bb);
  (c) = (((c) << (15)) | (((c)&0xffffffff) >> (32 - (15))));
  (c) += (d);
  (b) += (((d)) ^ (((c)) | ~((a)))) + ((key[hook(6, (9))])) + (0xeb86d391);
  (b) = (((b) << (21)) | (((b)&0xffffffff) >> (32 - (21))));
  (b) += (c);

  internal_state[hook(5, 0)] = a + internal_state[hook(5, 0)];
  internal_state[hook(5, 1)] = b + internal_state[hook(5, 1)];
  internal_state[hook(5, 2)] = c + internal_state[hook(5, 2)];
  internal_state[hook(5, 3)] = d + internal_state[hook(5, 3)];
}

void md5_wrongorder(const char* restrict msg, unsigned int length_bytes, unsigned int* restrict out) {
  unsigned int i;
  unsigned int bytes_left;
  char key[64];

  out[hook(7, 0)] = 0x67452301;
  out[hook(7, 1)] = 0xefcdab89;
  out[hook(7, 2)] = 0x98badcfe;
  out[hook(7, 3)] = 0x10325476;

  for (bytes_left = length_bytes; bytes_left >= 64; bytes_left -= 64, msg = &msg[hook(8, 64)]) {
    md5_round(out, (const unsigned int*)msg);
  }

  for (i = 0; i < bytes_left; i++) {
    key[hook(6, i)] = msg[hook(8, i)];
  }
  key[hook(6, bytes_left++)] = 0x80;

  if (bytes_left <= 56) {
    for (i = bytes_left; i < 56; key[hook(6, i++)] = 0)
      ;
  } else {
    for (i = bytes_left; i < 64; key[hook(6, i++)] = 0)
      ;
    md5_round(out, (unsigned int*)key);
    for (i = 0; i < 56; key[hook(6, i++)] = 0)
      ;
  }

  ulong* len_ptr = (ulong*)&key[hook(6, 56)];
  *len_ptr = length_bytes * 8;
  md5_round(out, (unsigned int*)key);
}

void md5(const char* restrict msg, unsigned int length_bytes, unsigned int* restrict out) {
  md5_wrongorder(msg, length_bytes, out);
  out[hook(7, 0)] = (((out[hook(7, 0)] >> 24) & 0xff) | ((out[hook(7, 0)] << 8) & 0xff0000) | ((out[hook(7, 0)] >> 8) & 0xff00) | ((out[hook(7, 0)] << 24) & 0xff000000));
  out[hook(7, 1)] = (((out[hook(7, 1)] >> 24) & 0xff) | ((out[hook(7, 1)] << 8) & 0xff0000) | ((out[hook(7, 1)] >> 8) & 0xff00) | ((out[hook(7, 1)] << 24) & 0xff000000));
  out[hook(7, 2)] = (((out[hook(7, 2)] >> 24) & 0xff) | ((out[hook(7, 2)] << 8) & 0xff0000) | ((out[hook(7, 2)] >> 8) & 0xff00) | ((out[hook(7, 2)] << 24) & 0xff000000));
  out[hook(7, 3)] = (((out[hook(7, 3)] >> 24) & 0xff) | ((out[hook(7, 3)] << 8) & 0xff0000) | ((out[hook(7, 3)] >> 8) & 0xff00) | ((out[hook(7, 3)] << 24) & 0xff000000));
}

kernel void vector_add(global const int* starts, global const int* stops, global const int* maxlen_in, global unsigned int* pw_hash, global char* cracked_pw) {
 private
  int id = get_global_id(0);
  int start = starts[hook(0, id)];
  int stop = stops[hook(1, id)];
  int maxlen = *maxlen_in;
  char chars[32];

  for (int i = start; i < stop; i++) {
    int actual_length = 0;
    int next = i + 1;
    for (int j = 0; j <= maxlen; j++) {
      char c = (char)(97 + (next - 1) % 26);
      chars[hook(9, j)] = c;
      next = (next - 1) / 26;
      if (next == 0) {
        actual_length = j + 1;
        break;
      }
    }
    unsigned int this_hash[4];
    md5(chars, actual_length, &this_hash);
    if (this_hash[hook(10, 0)] == pw_hash[hook(3, 0)] && this_hash[hook(10, 1)] == pw_hash[hook(3, 1)] && this_hash[hook(10, 2)] == pw_hash[hook(3, 2)] && this_hash[hook(10, 3)] == pw_hash[hook(3, 3)]) {
      for (int i = 0; i < actual_length; i++) {
        cracked_pw[hook(4, i)] = chars[hook(9, i)];
        cracked_pw[hook(4, i + 1)] = 0x00;
      }
    }
  }
}