//{"byteLength":5,"digest":11,"foundDigest":9,"foundIndex":7,"foundKey":8,"key":13,"keyspace":4,"searchDigest0":0,"searchDigest1":1,"searchDigest2":2,"searchDigest3":3,"vals":12,"valsPerByte":6,"words":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void md5_2words(unsigned int* words, unsigned int len, unsigned int* digest) {
  unsigned int h0 = 0x67452301;
  unsigned int h1 = 0xefcdab89;
  unsigned int h2 = 0x98badcfe;
  unsigned int h3 = 0x10325476;

  unsigned int a = h0;
  unsigned int b = h1;
  unsigned int c = h2;
  unsigned int d = h3;

  unsigned int WL = len * 8;
  unsigned int W0 = words[hook(10, 0)];
  unsigned int W1 = words[hook(10, 1)];

  switch (len) {
    case 0:
      W0 |= 0x00000080;
      break;
    case 1:
      W0 |= 0x00008000;
      break;
    case 2:
      W0 |= 0x00800000;
      break;
    case 3:
      W0 |= 0x80000000;
      break;
    case 4:
      W1 |= 0x00000080;
      break;
    case 5:
      W1 |= 0x00008000;
      break;
    case 6:
      W1 |= 0x00800000;
      break;
    case 7:
      W1 |= 0x80000000;
      break;
  }

  {
    a = a + ((b & c) | ((~b) & d)) + 0xd76aa478 + W0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (7)) | ((a) >> (32 - (7))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xe8c7b756 + W1;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (12)) | ((a) >> (32 - (12))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x242070db + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (17)) | ((a) >> (32 - (17))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xc1bdceee + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (22)) | ((a) >> (32 - (22))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xf57c0faf + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (7)) | ((a) >> (32 - (7))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x4787c62a + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (12)) | ((a) >> (32 - (12))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xa8304613 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (17)) | ((a) >> (32 - (17))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xfd469501 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (22)) | ((a) >> (32 - (22))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x698098d8 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (7)) | ((a) >> (32 - (7))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x8b44f7af + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (12)) | ((a) >> (32 - (12))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xffff5bb1 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (17)) | ((a) >> (32 - (17))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x895cd7be + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (22)) | ((a) >> (32 - (22))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x6b901122 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (7)) | ((a) >> (32 - (7))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xfd987193 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (12)) | ((a) >> (32 - (12))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0xa679438e + WL;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (17)) | ((a) >> (32 - (17))));
    a = temp;
  };
  {
    a = a + ((b & c) | ((~b) & d)) + 0x49b40821 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (22)) | ((a) >> (32 - (22))));
    a = temp;
  };

  {
    a = a + ((b & d) | ((~d) & c)) + 0xf61e2562 + W1;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (5)) | ((a) >> (32 - (5))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xc040b340 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (9)) | ((a) >> (32 - (9))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x265e5a51 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (14)) | ((a) >> (32 - (14))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xe9b6c7aa + W0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (20)) | ((a) >> (32 - (20))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xd62f105d + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (5)) | ((a) >> (32 - (5))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x02441453 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (9)) | ((a) >> (32 - (9))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xd8a1e681 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (14)) | ((a) >> (32 - (14))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xe7d3fbc8 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (20)) | ((a) >> (32 - (20))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x21e1cde6 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (5)) | ((a) >> (32 - (5))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xc33707d6 + WL;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (9)) | ((a) >> (32 - (9))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xf4d50d87 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (14)) | ((a) >> (32 - (14))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x455a14ed + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (20)) | ((a) >> (32 - (20))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xa9e3e905 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (5)) | ((a) >> (32 - (5))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0xfcefa3f8 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (9)) | ((a) >> (32 - (9))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x676f02d9 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (14)) | ((a) >> (32 - (14))));
    a = temp;
  };
  {
    a = a + ((b & d) | ((~d) & c)) + 0x8d2a4c8a + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (20)) | ((a) >> (32 - (20))));
    a = temp;
  };

  {
    a = a + (b ^ c ^ d) + 0xfffa3942 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (4)) | ((a) >> (32 - (4))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x8771f681 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (11)) | ((a) >> (32 - (11))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x6d9d6122 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (16)) | ((a) >> (32 - (16))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xfde5380c + WL;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (23)) | ((a) >> (32 - (23))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xa4beea44 + W1;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (4)) | ((a) >> (32 - (4))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x4bdecfa9 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (11)) | ((a) >> (32 - (11))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xf6bb4b60 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (16)) | ((a) >> (32 - (16))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xbebfbc70 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (23)) | ((a) >> (32 - (23))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x289b7ec6 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (4)) | ((a) >> (32 - (4))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xeaa127fa + W0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (11)) | ((a) >> (32 - (11))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xd4ef3085 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (16)) | ((a) >> (32 - (16))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x04881d05 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (23)) | ((a) >> (32 - (23))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xd9d4d039 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (4)) | ((a) >> (32 - (4))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xe6db99e5 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (11)) | ((a) >> (32 - (11))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0x1fa27cf8 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (16)) | ((a) >> (32 - (16))));
    a = temp;
  };
  {
    a = a + (b ^ c ^ d) + 0xc4ac5665 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (23)) | ((a) >> (32 - (23))));
    a = temp;
  };

  {
    a = a + (c ^ (b | (~d))) + 0xf4292244 + W0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (6)) | ((a) >> (32 - (6))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x432aff97 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (10)) | ((a) >> (32 - (10))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xab9423a7 + WL;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (15)) | ((a) >> (32 - (15))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xfc93a039 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (21)) | ((a) >> (32 - (21))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x655b59c3 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (6)) | ((a) >> (32 - (6))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x8f0ccc92 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (10)) | ((a) >> (32 - (10))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xffeff47d + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (15)) | ((a) >> (32 - (15))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x85845dd1 + W1;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (21)) | ((a) >> (32 - (21))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x6fa87e4f + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (6)) | ((a) >> (32 - (6))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xfe2ce6e0 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (10)) | ((a) >> (32 - (10))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xa3014314 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (15)) | ((a) >> (32 - (15))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x4e0811a1 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (21)) | ((a) >> (32 - (21))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xf7537e82 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (6)) | ((a) >> (32 - (6))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xbd3af235 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (10)) | ((a) >> (32 - (10))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0x2ad7d2bb + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (15)) | ((a) >> (32 - (15))));
    a = temp;
  };
  {
    a = a + (c ^ (b | (~d))) + 0xeb86d391 + 0;
    unsigned int temp = d;
    d = c;
    c = b;
    b = b + (((a) << (21)) | ((a) >> (32 - (21))));
    a = temp;
  };

  h0 += a;
  h1 += b;
  h2 += c;
  h3 += d;

  digest[hook(11, 0)] = h0;
  digest[hook(11, 1)] = h1;
  digest[hook(11, 2)] = h2;
  digest[hook(11, 3)] = h3;
}
inline void IndexToKey(unsigned int index, int byteLength, int valsPerByte, unsigned char vals[8]) {
  vals[hook(12, 0)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 1)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 2)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 3)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 4)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 5)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 6)] = index % valsPerByte;
  index /= valsPerByte;

  vals[hook(12, 7)] = index % valsPerByte;
  index /= valsPerByte;
}
kernel void FindKeyWithDigest_Kernel(unsigned int searchDigest0, unsigned int searchDigest1, unsigned int searchDigest2, unsigned int searchDigest3, int keyspace, int byteLength, int valsPerByte, global int* foundIndex, global unsigned char* foundKey, global unsigned int* foundDigest) {
  int threadid = (get_group_id(0) * get_local_size(0)) + get_local_id(0);

  int startindex = threadid * valsPerByte;
  unsigned char key[8] = {0, 0, 0, 0, 0, 0, 0, 0};
  IndexToKey(startindex, byteLength, valsPerByte, key);

  for (int j = 0; j < valsPerByte && startindex + j < keyspace; ++j) {
    unsigned int digest[4];
    md5_2words((unsigned int*)key, byteLength, digest);
    if (digest[hook(11, 0)] == searchDigest0 && digest[hook(11, 1)] == searchDigest1 && digest[hook(11, 2)] == searchDigest2 && digest[hook(11, 3)] == searchDigest3) {
      *foundIndex = startindex + j;
      foundKey[hook(8, 0)] = key[hook(13, 0)];
      foundKey[hook(8, 1)] = key[hook(13, 1)];
      foundKey[hook(8, 2)] = key[hook(13, 2)];
      foundKey[hook(8, 3)] = key[hook(13, 3)];
      foundKey[hook(8, 4)] = key[hook(13, 4)];
      foundKey[hook(8, 5)] = key[hook(13, 5)];
      foundKey[hook(8, 6)] = key[hook(13, 6)];
      foundKey[hook(8, 7)] = key[hook(13, 7)];
      foundDigest[hook(9, 0)] = digest[hook(11, 0)];
      foundDigest[hook(9, 1)] = digest[hook(11, 1)];
      foundDigest[hook(9, 2)] = digest[hook(11, 2)];
      foundDigest[hook(9, 3)] = digest[hook(11, 3)];
    }
    ++key[hook(13, 0)];
  }
}