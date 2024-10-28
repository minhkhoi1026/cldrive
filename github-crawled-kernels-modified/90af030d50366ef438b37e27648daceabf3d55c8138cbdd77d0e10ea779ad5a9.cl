//{"X":6,"alphabet":12,"calculated":9,"chrPtr":8,"dataSize":1,"digest":7,"h":5,"input":0,"length":14,"message":13,"msg":4,"msgLen":16,"outcome":15,"output":2,"outputSize":3,"result":10,"tmp":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void md5(unsigned char* msg, unsigned long msgLen, unsigned char* digest) {
  unsigned int i, tmp;
  unsigned int* X;
  unsigned char* chrPtr;

  unsigned int h[4] = {0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476};

  unsigned int a, b, c, d, t;

  msg[hook(4, msgLen)] = 0x80;

  for (i = msgLen + 1; i < 64 - 8; i++) {
    msg[hook(4, i)] = 0x00;
  }

  tmp = 0;
  for (; i < 64; i++) {
    msg[hook(4, i)] = ((8 * msgLen) >> (8 * tmp)) & 0xFF;
    tmp++;
  }

  a = h[hook(5, 0)];
  b = h[hook(5, 1)];
  c = h[hook(5, 2)];
  d = h[hook(5, 3)];

  X = (unsigned int*)msg;
  t = a + (((b) & (c)) | (~(b) & (d))) + X[hook(6, 0)] + (((unsigned int)~0) ^ 0x28955b87);
  a = (((t) << (7)) | ((t) >> (32 - (7)))) + b;
  t = d + (((a) & (b)) | (~(a) & (c))) + X[hook(6, 1)] + (((unsigned int)~0) ^ 0x173848a9);
  d = (((t) << (12)) | ((t) >> (32 - (12)))) + a;
  t = c + (((d) & (a)) | (~(d) & (b))) + X[hook(6, 2)] + 0x242070db;
  c = (((t) << (17)) | ((t) >> (32 - (17)))) + d;
  t = b + (((c) & (d)) | (~(c) & (a))) + X[hook(6, 3)] + (((unsigned int)~0) ^ 0x3e423111);
  b = (((t) << (22)) | ((t) >> (32 - (22)))) + c;
  t = a + (((b) & (c)) | (~(b) & (d))) + X[hook(6, 4)] + (((unsigned int)~0) ^ 0x0a83f050);
  a = (((t) << (7)) | ((t) >> (32 - (7)))) + b;
  t = d + (((a) & (b)) | (~(a) & (c))) + X[hook(6, 5)] + 0x4787c62a;
  d = (((t) << (12)) | ((t) >> (32 - (12)))) + a;
  t = c + (((d) & (a)) | (~(d) & (b))) + X[hook(6, 6)] + (((unsigned int)~0) ^ 0x57cfb9ec);
  c = (((t) << (17)) | ((t) >> (32 - (17)))) + d;
  t = b + (((c) & (d)) | (~(c) & (a))) + X[hook(6, 7)] + (((unsigned int)~0) ^ 0x02b96afe);
  b = (((t) << (22)) | ((t) >> (32 - (22)))) + c;
  t = a + (((b) & (c)) | (~(b) & (d))) + X[hook(6, 8)] + 0x698098d8;
  a = (((t) << (7)) | ((t) >> (32 - (7)))) + b;
  t = d + (((a) & (b)) | (~(a) & (c))) + X[hook(6, 9)] + (((unsigned int)~0) ^ 0x74bb0850);
  d = (((t) << (12)) | ((t) >> (32 - (12)))) + a;
  t = c + (((d) & (a)) | (~(d) & (b))) + X[hook(6, 10)] + (((unsigned int)~0) ^ 0x0000a44e);
  c = (((t) << (17)) | ((t) >> (32 - (17)))) + d;
  t = b + (((c) & (d)) | (~(c) & (a))) + X[hook(6, 11)] + (((unsigned int)~0) ^ 0x76a32841);
  b = (((t) << (22)) | ((t) >> (32 - (22)))) + c;
  t = a + (((b) & (c)) | (~(b) & (d))) + X[hook(6, 12)] + 0x6b901122;
  a = (((t) << (7)) | ((t) >> (32 - (7)))) + b;
  t = d + (((a) & (b)) | (~(a) & (c))) + X[hook(6, 13)] + (((unsigned int)~0) ^ 0x02678e6c);
  d = (((t) << (12)) | ((t) >> (32 - (12)))) + a;
  t = c + (((d) & (a)) | (~(d) & (b))) + X[hook(6, 14)] + (((unsigned int)~0) ^ 0x5986bc71);
  c = (((t) << (17)) | ((t) >> (32 - (17)))) + d;
  t = b + (((c) & (d)) | (~(c) & (a))) + X[hook(6, 15)] + 0x49b40821;
  b = (((t) << (22)) | ((t) >> (32 - (22)))) + c;
  t = a + (((b) & (d)) | ((c) & ~(d))) + X[hook(6, 1)] + (((unsigned int)~0) ^ 0x09e1da9d);
  a = (((t) << (5)) | ((t) >> (32 - (5)))) + b;
  t = d + (((a) & (c)) | ((b) & ~(c))) + X[hook(6, 6)] + (((unsigned int)~0) ^ 0x3fbf4cbf);
  d = (((t) << (9)) | ((t) >> (32 - (9)))) + a;
  t = c + (((d) & (b)) | ((a) & ~(b))) + X[hook(6, 11)] + 0x265e5a51;
  c = (((t) << (14)) | ((t) >> (32 - (14)))) + d;
  t = b + (((c) & (a)) | ((d) & ~(a))) + X[hook(6, 0)] + (((unsigned int)~0) ^ 0x16493855);
  b = (((t) << (20)) | ((t) >> (32 - (20)))) + c;
  t = a + (((b) & (d)) | ((c) & ~(d))) + X[hook(6, 5)] + (((unsigned int)~0) ^ 0x29d0efa2);
  a = (((t) << (5)) | ((t) >> (32 - (5)))) + b;
  t = d + (((a) & (c)) | ((b) & ~(c))) + X[hook(6, 10)] + 0x02441453;
  d = (((t) << (9)) | ((t) >> (32 - (9)))) + a;
  t = c + (((d) & (b)) | ((a) & ~(b))) + X[hook(6, 15)] + (((unsigned int)~0) ^ 0x275e197e);
  c = (((t) << (14)) | ((t) >> (32 - (14)))) + d;
  t = b + (((c) & (a)) | ((d) & ~(a))) + X[hook(6, 4)] + (((unsigned int)~0) ^ 0x182c0437);
  b = (((t) << (20)) | ((t) >> (32 - (20)))) + c;
  t = a + (((b) & (d)) | ((c) & ~(d))) + X[hook(6, 9)] + 0x21e1cde6;
  a = (((t) << (5)) | ((t) >> (32 - (5)))) + b;
  t = d + (((a) & (c)) | ((b) & ~(c))) + X[hook(6, 14)] + (((unsigned int)~0) ^ 0x3cc8f829);
  d = (((t) << (9)) | ((t) >> (32 - (9)))) + a;
  t = c + (((d) & (b)) | ((a) & ~(b))) + X[hook(6, 3)] + (((unsigned int)~0) ^ 0x0b2af278);
  c = (((t) << (14)) | ((t) >> (32 - (14)))) + d;
  t = b + (((c) & (a)) | ((d) & ~(a))) + X[hook(6, 8)] + 0x455a14ed;
  b = (((t) << (20)) | ((t) >> (32 - (20)))) + c;
  t = a + (((b) & (d)) | ((c) & ~(d))) + X[hook(6, 13)] + (((unsigned int)~0) ^ 0x561c16fa);
  a = (((t) << (5)) | ((t) >> (32 - (5)))) + b;
  t = d + (((a) & (c)) | ((b) & ~(c))) + X[hook(6, 2)] + (((unsigned int)~0) ^ 0x03105c07);
  d = (((t) << (9)) | ((t) >> (32 - (9)))) + a;
  t = c + (((d) & (b)) | ((a) & ~(b))) + X[hook(6, 7)] + 0x676f02d9;
  c = (((t) << (14)) | ((t) >> (32 - (14)))) + d;
  t = b + (((c) & (a)) | ((d) & ~(a))) + X[hook(6, 12)] + (((unsigned int)~0) ^ 0x72d5b375);
  b = (((t) << (20)) | ((t) >> (32 - (20)))) + c;
  t = a + ((b) ^ (c) ^ (d)) + X[hook(6, 5)] + (((unsigned int)~0) ^ 0x0005c6bd);
  a = (((t) << (4)) | ((t) >> (32 - (4)))) + b;
  t = d + ((a) ^ (b) ^ (c)) + X[hook(6, 8)] + (((unsigned int)~0) ^ 0x788e097e);
  d = (((t) << (11)) | ((t) >> (32 - (11)))) + a;
  t = c + ((d) ^ (a) ^ (b)) + X[hook(6, 11)] + 0x6d9d6122;
  c = (((t) << (16)) | ((t) >> (32 - (16)))) + d;
  t = b + ((c) ^ (d) ^ (a)) + X[hook(6, 14)] + (((unsigned int)~0) ^ 0x021ac7f3);
  b = (((t) << (23)) | ((t) >> (32 - (23)))) + c;
  t = a + ((b) ^ (c) ^ (d)) + X[hook(6, 1)] + (((unsigned int)~0) ^ 0x5b4115bb);
  a = (((t) << (4)) | ((t) >> (32 - (4)))) + b;
  t = d + ((a) ^ (b) ^ (c)) + X[hook(6, 4)] + 0x4bdecfa9;
  d = (((t) << (11)) | ((t) >> (32 - (11)))) + a;
  t = c + ((d) ^ (a) ^ (b)) + X[hook(6, 7)] + (((unsigned int)~0) ^ 0x0944b49f);
  c = (((t) << (16)) | ((t) >> (32 - (16)))) + d;
  t = b + ((c) ^ (d) ^ (a)) + X[hook(6, 10)] + (((unsigned int)~0) ^ 0x4140438f);
  b = (((t) << (23)) | ((t) >> (32 - (23)))) + c;
  t = a + ((b) ^ (c) ^ (d)) + X[hook(6, 13)] + 0x289b7ec6;
  a = (((t) << (4)) | ((t) >> (32 - (4)))) + b;
  t = d + ((a) ^ (b) ^ (c)) + X[hook(6, 0)] + (((unsigned int)~0) ^ 0x155ed805);
  d = (((t) << (11)) | ((t) >> (32 - (11)))) + a;
  t = c + ((d) ^ (a) ^ (b)) + X[hook(6, 3)] + (((unsigned int)~0) ^ 0x2b10cf7a);
  c = (((t) << (16)) | ((t) >> (32 - (16)))) + d;
  t = b + ((c) ^ (d) ^ (a)) + X[hook(6, 6)] + 0x04881d05;
  b = (((t) << (23)) | ((t) >> (32 - (23)))) + c;
  t = a + ((b) ^ (c) ^ (d)) + X[hook(6, 9)] + (((unsigned int)~0) ^ 0x262b2fc6);
  a = (((t) << (4)) | ((t) >> (32 - (4)))) + b;
  t = d + ((a) ^ (b) ^ (c)) + X[hook(6, 12)] + (((unsigned int)~0) ^ 0x1924661a);
  d = (((t) << (11)) | ((t) >> (32 - (11)))) + a;
  t = c + ((d) ^ (a) ^ (b)) + X[hook(6, 15)] + 0x1fa27cf8;
  c = (((t) << (16)) | ((t) >> (32 - (16)))) + d;
  t = b + ((c) ^ (d) ^ (a)) + X[hook(6, 2)] + (((unsigned int)~0) ^ 0x3b53a99a);
  b = (((t) << (23)) | ((t) >> (32 - (23)))) + c;
  t = a + ((c) ^ ((b) | ~(d))) + X[hook(6, 0)] + (((unsigned int)~0) ^ 0x0bd6ddbb);
  a = (((t) << (6)) | ((t) >> (32 - (6)))) + b;
  t = d + ((b) ^ ((a) | ~(c))) + X[hook(6, 7)] + 0x432aff97;
  d = (((t) << (10)) | ((t) >> (32 - (10)))) + a;
  t = c + ((a) ^ ((d) | ~(b))) + X[hook(6, 14)] + (((unsigned int)~0) ^ 0x546bdc58);
  c = (((t) << (15)) | ((t) >> (32 - (15)))) + d;
  t = b + ((d) ^ ((c) | ~(a))) + X[hook(6, 5)] + (((unsigned int)~0) ^ 0x036c5fc6);
  b = (((t) << (21)) | ((t) >> (32 - (21)))) + c;
  t = a + ((c) ^ ((b) | ~(d))) + X[hook(6, 12)] + 0x655b59c3;
  a = (((t) << (6)) | ((t) >> (32 - (6)))) + b;
  t = d + ((b) ^ ((a) | ~(c))) + X[hook(6, 3)] + (((unsigned int)~0) ^ 0x70f3336d);
  d = (((t) << (10)) | ((t) >> (32 - (10)))) + a;
  t = c + ((a) ^ ((d) | ~(b))) + X[hook(6, 10)] + (((unsigned int)~0) ^ 0x00100b82);
  c = (((t) << (15)) | ((t) >> (32 - (15)))) + d;
  t = b + ((d) ^ ((c) | ~(a))) + X[hook(6, 1)] + (((unsigned int)~0) ^ 0x7a7ba22e);
  b = (((t) << (21)) | ((t) >> (32 - (21)))) + c;
  t = a + ((c) ^ ((b) | ~(d))) + X[hook(6, 8)] + 0x6fa87e4f;
  a = (((t) << (6)) | ((t) >> (32 - (6)))) + b;
  t = d + ((b) ^ ((a) | ~(c))) + X[hook(6, 15)] + (((unsigned int)~0) ^ 0x01d3191f);
  d = (((t) << (10)) | ((t) >> (32 - (10)))) + a;
  t = c + ((a) ^ ((d) | ~(b))) + X[hook(6, 6)] + (((unsigned int)~0) ^ 0x5cfebceb);
  c = (((t) << (15)) | ((t) >> (32 - (15)))) + d;
  t = b + ((d) ^ ((c) | ~(a))) + X[hook(6, 13)] + 0x4e0811a1;
  b = (((t) << (21)) | ((t) >> (32 - (21)))) + c;
  t = a + ((c) ^ ((b) | ~(d))) + X[hook(6, 4)] + (((unsigned int)~0) ^ 0x08ac817d);
  a = (((t) << (6)) | ((t) >> (32 - (6)))) + b;
  t = d + ((b) ^ ((a) | ~(c))) + X[hook(6, 11)] + (((unsigned int)~0) ^ 0x42c50dca);
  d = (((t) << (10)) | ((t) >> (32 - (10)))) + a;
  t = c + ((a) ^ ((d) | ~(b))) + X[hook(6, 2)] + 0x2ad7d2bb;
  c = (((t) << (15)) | ((t) >> (32 - (15)))) + d;
  t = b + ((d) ^ ((c) | ~(a))) + X[hook(6, 9)] + (((unsigned int)~0) ^ 0x14792c6e);
  b = (((t) << (21)) | ((t) >> (32 - (21)))) + c;

  h[hook(5, 0)] += a;
  h[hook(5, 1)] += b;
  h[hook(5, 2)] += c;
  h[hook(5, 3)] += d;

  chrPtr = (unsigned char*)h;
  for (i = 0; i < 16; i++) {
    digest[hook(7, i)] = chrPtr[hook(8, i)];
  }
}
void compareHashes(unsigned char* calculated, unsigned char* digest, local unsigned int* result) {
  unsigned int tmp = 1, i;
  for (i = 0; i < 16; i++) {
    tmp &= (calculated[hook(9, i)] == digest[hook(7, i)]);
  }
  result[hook(10, 0)] = tmp;
}

void initState(long state, unsigned char* message, local unsigned long* length) {
  unsigned char alphabet[26] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
  unsigned char tmp[64];
  int diff, n = 26, chr = 0;
  while (state >= 0) {
    diff = state % n;
    tmp[hook(11, chr)] = alphabet[hook(12, diff)];
    chr++;
    state -= (diff + n);
    state /= n;
  }
  n = chr - 1;
  while (chr >= 0) {
    message[hook(13, n - chr)] = tmp[hook(11, chr)];
    chr--;
  }
  length[hook(14, 0)] = n + 1;
}

kernel void processData(global unsigned char* input, unsigned int dataSize, global unsigned char* output, unsigned int outputSize) {
  unsigned char tmp[sizeof(long)];
  unsigned char msg[64];
  unsigned char digest[16];
  unsigned char calculated[16];
  long from[1] = {0};
  long to[1] = {0};
  long state = 0;

  long step = 0;
  int wiCount = get_global_size(0);
  int wiId = get_global_id(0);

  int i;

  local unsigned int outcome[512];
  local unsigned long msgLen[512];
  local int passLen;
  local int finder;

  outcome[hook(15, wiId)] = 0;
  msgLen[hook(16, wiId)] = 0;
  if (wiId == 0) {
    passLen = 0;
    finder = -1;
  }

  for (i = 0; i < 16; i++) {
    digest[hook(7, i)] = input[hook(0, i)];
  }
  barrier(0x02);

  for (i = 0; i < sizeof(long); i++) {
    tmp[hook(11, i)] = input[hook(0, i + 16)];
  }
  barrier(0x02);
  *from = *((long*)tmp);

  for (i = 0; i < sizeof(long); i++) {
    tmp[hook(11, i)] = input[hook(0, i + 16 + sizeof(long))];
  }
  barrier(0x02);
  *to = *((long*)tmp);

  state = *from;
  barrier(0x01);

  while (passLen == 0 && state <= *to) {
    initState(state, msg, msgLen + wiId);
    md5(msg, msgLen[hook(16, wiId)], calculated);
    compareHashes(calculated, digest, outcome + wiId);
    barrier(0x01);
    if (outcome[hook(15, wiId)] > 0) {
      passLen = msgLen[hook(16, wiId)];
      finder = wiId;
    }
    step++;
    state = *from + (step * wiCount) + wiId;
    barrier(0x01);
  }
  barrier(0x01);

  if (passLen > 0 && wiId == finder) {
    output[hook(2, 0)] = (passLen)&0xFF;
    output[hook(2, 1)] = (passLen >> 8) & 0xFF;
    output[hook(2, 2)] = (passLen >> 16) & 0xFF;
    output[hook(2, 3)] = (passLen >> 24) & 0xFF;
    for (i = 0; i < passLen; i++) {
      output[hook(2, i + 4)] = msg[hook(4, i)];
    }
  } else if (passLen == 0 && wiId == 0) {
    output[hook(2, 0)] = 0;
    output[hook(2, 1)] = 0;
    output[hook(2, 2)] = 0;
    output[hook(2, 3)] = 0;
  }
}