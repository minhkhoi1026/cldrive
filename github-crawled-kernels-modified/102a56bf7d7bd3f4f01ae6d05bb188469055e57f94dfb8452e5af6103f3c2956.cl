//{"block":4,"padding_d":2,"salt_d":1,"totNumIteration":0,"w_blocks_d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void opencl_bitcracker_wblocks(int totNumIteration, global unsigned char* salt_d, global unsigned char* padding_d, global unsigned int* w_blocks_d) {
  unsigned long loop = get_global_id(0);
  unsigned char block[64];

  int i, j;

  for (i = 0; i < 16; i++)
    block[hook(4, i)] = salt_d[hook(1, i)];

  i += 8;

  for (j = 0; j < 40; i++, j++)
    block[hook(4, i)] = padding_d[hook(2, j)];

  while (loop < 0x100000) {
    block[hook(4, 16)] = (unsigned char)(loop >> (0 * 8));
    block[hook(4, 17)] = (unsigned char)(loop >> (1 * 8));
    block[hook(4, 18)] = (unsigned char)(loop >> (2 * 8));
    block[hook(4, 19)] = (unsigned char)(loop >> (3 * 8));
    block[hook(4, 20)] = (unsigned char)(loop >> (4 * 8));
    block[hook(4, 21)] = (unsigned char)(loop >> (5 * 8));
    block[hook(4, 22)] = (unsigned char)(loop >> (6 * 8));
    block[hook(4, 23)] = (unsigned char)(loop >> (7 * 8));

    w_blocks_d[hook(3, (64 * loop) + 0)] = (unsigned int)block[hook(4, 0 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 0 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 0 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 0 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 1)] = (unsigned int)block[hook(4, 1 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 1 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 1 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 1 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 2)] = (unsigned int)block[hook(4, 2 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 2 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 2 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 2 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 3)] = (unsigned int)block[hook(4, 3 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 3 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 3 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 3 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 4)] = (unsigned int)block[hook(4, 4 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 4 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 4 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 4 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 5)] = (unsigned int)block[hook(4, 5 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 5 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 5 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 5 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 6)] = (unsigned int)block[hook(4, 6 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 6 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 6 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 6 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 7)] = (unsigned int)block[hook(4, 7 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 7 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 7 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 7 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 8)] = (unsigned int)block[hook(4, 8 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 8 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 8 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 8 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 9)] = (unsigned int)block[hook(4, 9 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 9 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 9 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 9 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 10)] = (unsigned int)block[hook(4, 10 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 10 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 10 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 10 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 11)] = (unsigned int)block[hook(4, 11 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 11 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 11 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 11 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 12)] = (unsigned int)block[hook(4, 12 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 12 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 12 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 12 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 13)] = (unsigned int)block[hook(4, 13 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 13 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 13 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 13 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 14)] = (unsigned int)block[hook(4, 14 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 14 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 14 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 14 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 15)] = (unsigned int)block[hook(4, 15 * 4 + 0)] << 24 | (unsigned int)block[hook(4, 15 * 4 + 1)] << 16 | (unsigned int)block[hook(4, 15 * 4 + 2)] << 8 | (unsigned int)block[hook(4, 15 * 4 + 3)];
    w_blocks_d[hook(3, (64 * loop) + 16)] = w_blocks_d[hook(3, (64 * loop) + 16 - 16)] + w_blocks_d[hook(3, (64 * loop) + 16 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 16 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 16 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 16 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 16 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 16 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 16 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 16 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 16 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 16 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 16 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 17)] = w_blocks_d[hook(3, (64 * loop) + 17 - 16)] + w_blocks_d[hook(3, (64 * loop) + 17 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 17 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 17 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 17 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 17 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 17 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 17 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 17 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 17 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 17 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 17 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 18)] = w_blocks_d[hook(3, (64 * loop) + 18 - 16)] + w_blocks_d[hook(3, (64 * loop) + 18 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 18 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 18 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 18 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 18 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 18 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 18 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 18 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 18 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 18 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 18 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 19)] = w_blocks_d[hook(3, (64 * loop) + 19 - 16)] + w_blocks_d[hook(3, (64 * loop) + 19 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 19 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 19 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 19 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 19 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 19 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 19 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 19 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 19 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 19 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 19 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 20)] = w_blocks_d[hook(3, (64 * loop) + 20 - 16)] + w_blocks_d[hook(3, (64 * loop) + 20 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 20 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 20 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 20 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 20 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 20 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 20 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 20 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 20 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 20 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 20 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 21)] = w_blocks_d[hook(3, (64 * loop) + 21 - 16)] + w_blocks_d[hook(3, (64 * loop) + 21 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 21 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 21 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 21 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 21 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 21 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 21 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 21 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 21 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 21 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 21 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 22)] = w_blocks_d[hook(3, (64 * loop) + 22 - 16)] + w_blocks_d[hook(3, (64 * loop) + 22 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 22 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 22 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 22 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 22 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 22 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 22 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 22 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 22 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 22 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 22 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 23)] = w_blocks_d[hook(3, (64 * loop) + 23 - 16)] + w_blocks_d[hook(3, (64 * loop) + 23 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 23 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 23 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 23 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 23 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 23 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 23 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 23 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 23 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 23 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 23 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 24)] = w_blocks_d[hook(3, (64 * loop) + 24 - 16)] + w_blocks_d[hook(3, (64 * loop) + 24 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 24 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 24 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 24 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 24 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 24 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 24 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 24 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 24 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 24 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 24 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 25)] = w_blocks_d[hook(3, (64 * loop) + 25 - 16)] + w_blocks_d[hook(3, (64 * loop) + 25 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 25 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 25 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 25 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 25 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 25 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 25 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 25 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 25 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 25 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 25 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 26)] = w_blocks_d[hook(3, (64 * loop) + 26 - 16)] + w_blocks_d[hook(3, (64 * loop) + 26 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 26 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 26 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 26 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 26 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 26 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 26 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 26 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 26 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 26 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 26 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 27)] = w_blocks_d[hook(3, (64 * loop) + 27 - 16)] + w_blocks_d[hook(3, (64 * loop) + 27 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 27 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 27 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 27 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 27 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 27 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 27 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 27 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 27 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 27 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 27 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 28)] = w_blocks_d[hook(3, (64 * loop) + 28 - 16)] + w_blocks_d[hook(3, (64 * loop) + 28 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 28 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 28 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 28 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 28 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 28 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 28 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 28 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 28 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 28 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 28 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 29)] = w_blocks_d[hook(3, (64 * loop) + 29 - 16)] + w_blocks_d[hook(3, (64 * loop) + 29 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 29 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 29 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 29 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 29 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 29 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 29 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 29 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 29 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 29 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 29 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 30)] = w_blocks_d[hook(3, (64 * loop) + 30 - 16)] + w_blocks_d[hook(3, (64 * loop) + 30 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 30 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 30 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 30 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 30 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 30 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 30 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 30 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 30 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 30 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 30 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 31)] = w_blocks_d[hook(3, (64 * loop) + 31 - 16)] + w_blocks_d[hook(3, (64 * loop) + 31 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 31 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 31 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 31 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 31 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 31 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 31 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 31 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 31 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 31 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 31 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 32)] = w_blocks_d[hook(3, (64 * loop) + 32 - 16)] + w_blocks_d[hook(3, (64 * loop) + 32 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 32 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 32 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 32 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 32 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 32 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 32 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 32 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 32 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 32 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 32 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 33)] = w_blocks_d[hook(3, (64 * loop) + 33 - 16)] + w_blocks_d[hook(3, (64 * loop) + 33 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 33 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 33 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 33 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 33 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 33 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 33 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 33 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 33 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 33 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 33 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 34)] = w_blocks_d[hook(3, (64 * loop) + 34 - 16)] + w_blocks_d[hook(3, (64 * loop) + 34 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 34 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 34 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 34 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 34 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 34 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 34 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 34 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 34 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 34 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 34 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 35)] = w_blocks_d[hook(3, (64 * loop) + 35 - 16)] + w_blocks_d[hook(3, (64 * loop) + 35 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 35 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 35 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 35 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 35 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 35 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 35 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 35 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 35 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 35 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 35 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 36)] = w_blocks_d[hook(3, (64 * loop) + 36 - 16)] + w_blocks_d[hook(3, (64 * loop) + 36 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 36 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 36 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 36 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 36 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 36 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 36 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 36 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 36 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 36 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 36 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 37)] = w_blocks_d[hook(3, (64 * loop) + 37 - 16)] + w_blocks_d[hook(3, (64 * loop) + 37 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 37 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 37 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 37 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 37 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 37 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 37 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 37 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 37 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 37 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 37 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 38)] = w_blocks_d[hook(3, (64 * loop) + 38 - 16)] + w_blocks_d[hook(3, (64 * loop) + 38 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 38 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 38 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 38 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 38 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 38 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 38 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 38 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 38 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 38 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 38 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 39)] = w_blocks_d[hook(3, (64 * loop) + 39 - 16)] + w_blocks_d[hook(3, (64 * loop) + 39 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 39 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 39 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 39 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 39 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 39 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 39 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 39 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 39 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 39 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 39 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 40)] = w_blocks_d[hook(3, (64 * loop) + 40 - 16)] + w_blocks_d[hook(3, (64 * loop) + 40 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 40 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 40 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 40 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 40 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 40 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 40 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 40 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 40 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 40 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 40 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 41)] = w_blocks_d[hook(3, (64 * loop) + 41 - 16)] + w_blocks_d[hook(3, (64 * loop) + 41 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 41 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 41 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 41 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 41 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 41 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 41 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 41 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 41 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 41 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 41 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 42)] = w_blocks_d[hook(3, (64 * loop) + 42 - 16)] + w_blocks_d[hook(3, (64 * loop) + 42 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 42 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 42 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 42 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 42 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 42 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 42 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 42 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 42 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 42 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 42 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 43)] = w_blocks_d[hook(3, (64 * loop) + 43 - 16)] + w_blocks_d[hook(3, (64 * loop) + 43 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 43 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 43 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 43 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 43 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 43 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 43 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 43 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 43 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 43 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 43 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 44)] = w_blocks_d[hook(3, (64 * loop) + 44 - 16)] + w_blocks_d[hook(3, (64 * loop) + 44 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 44 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 44 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 44 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 44 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 44 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 44 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 44 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 44 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 44 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 44 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 45)] = w_blocks_d[hook(3, (64 * loop) + 45 - 16)] + w_blocks_d[hook(3, (64 * loop) + 45 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 45 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 45 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 45 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 45 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 45 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 45 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 45 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 45 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 45 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 45 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 46)] = w_blocks_d[hook(3, (64 * loop) + 46 - 16)] + w_blocks_d[hook(3, (64 * loop) + 46 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 46 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 46 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 46 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 46 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 46 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 46 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 46 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 46 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 46 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 46 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 47)] = w_blocks_d[hook(3, (64 * loop) + 47 - 16)] + w_blocks_d[hook(3, (64 * loop) + 47 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 47 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 47 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 47 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 47 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 47 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 47 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 47 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 47 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 47 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 47 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 48)] = w_blocks_d[hook(3, (64 * loop) + 48 - 16)] + w_blocks_d[hook(3, (64 * loop) + 48 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 48 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 48 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 48 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 48 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 48 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 48 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 48 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 48 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 48 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 48 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 49)] = w_blocks_d[hook(3, (64 * loop) + 49 - 16)] + w_blocks_d[hook(3, (64 * loop) + 49 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 49 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 49 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 49 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 49 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 49 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 49 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 49 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 49 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 49 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 49 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 50)] = w_blocks_d[hook(3, (64 * loop) + 50 - 16)] + w_blocks_d[hook(3, (64 * loop) + 50 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 50 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 50 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 50 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 50 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 50 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 50 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 50 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 50 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 50 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 50 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 51)] = w_blocks_d[hook(3, (64 * loop) + 51 - 16)] + w_blocks_d[hook(3, (64 * loop) + 51 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 51 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 51 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 51 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 51 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 51 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 51 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 51 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 51 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 51 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 51 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 52)] = w_blocks_d[hook(3, (64 * loop) + 52 - 16)] + w_blocks_d[hook(3, (64 * loop) + 52 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 52 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 52 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 52 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 52 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 52 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 52 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 52 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 52 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 52 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 52 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 53)] = w_blocks_d[hook(3, (64 * loop) + 53 - 16)] + w_blocks_d[hook(3, (64 * loop) + 53 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 53 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 53 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 53 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 53 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 53 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 53 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 53 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 53 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 53 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 53 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 54)] = w_blocks_d[hook(3, (64 * loop) + 54 - 16)] + w_blocks_d[hook(3, (64 * loop) + 54 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 54 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 54 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 54 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 54 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 54 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 54 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 54 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 54 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 54 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 54 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 55)] = w_blocks_d[hook(3, (64 * loop) + 55 - 16)] + w_blocks_d[hook(3, (64 * loop) + 55 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 55 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 55 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 55 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 55 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 55 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 55 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 55 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 55 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 55 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 55 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 56)] = w_blocks_d[hook(3, (64 * loop) + 56 - 16)] + w_blocks_d[hook(3, (64 * loop) + 56 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 56 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 56 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 56 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 56 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 56 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 56 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 56 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 56 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 56 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 56 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 57)] = w_blocks_d[hook(3, (64 * loop) + 57 - 16)] + w_blocks_d[hook(3, (64 * loop) + 57 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 57 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 57 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 57 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 57 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 57 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 57 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 57 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 57 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 57 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 57 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 58)] = w_blocks_d[hook(3, (64 * loop) + 58 - 16)] + w_blocks_d[hook(3, (64 * loop) + 58 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 58 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 58 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 58 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 58 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 58 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 58 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 58 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 58 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 58 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 58 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 59)] = w_blocks_d[hook(3, (64 * loop) + 59 - 16)] + w_blocks_d[hook(3, (64 * loop) + 59 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 59 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 59 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 59 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 59 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 59 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 59 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 59 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 59 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 59 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 59 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 60)] = w_blocks_d[hook(3, (64 * loop) + 60 - 16)] + w_blocks_d[hook(3, (64 * loop) + 60 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 60 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 60 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 60 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 60 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 60 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 60 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 60 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 60 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 60 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 60 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 61)] = w_blocks_d[hook(3, (64 * loop) + 61 - 16)] + w_blocks_d[hook(3, (64 * loop) + 61 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 61 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 61 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 61 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 61 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 61 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 61 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 61 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 61 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 61 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 61 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 62)] = w_blocks_d[hook(3, (64 * loop) + 62 - 16)] + w_blocks_d[hook(3, (64 * loop) + 62 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 62 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 62 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 62 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 62 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 62 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 62 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 62 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 62 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 62 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 62 - 2)] >> 10));
    w_blocks_d[hook(3, (64 * loop) + 63)] = w_blocks_d[hook(3, (64 * loop) + 63 - 16)] + w_blocks_d[hook(3, (64 * loop) + 63 - 7)] + ((((w_blocks_d[hook(3, (64 * loop) + 63 - 15)]) << (32 - (7))) | ((w_blocks_d[hook(3, (64 * loop) + 63 - 15)]) >> (7))) ^ (((w_blocks_d[hook(3, (64 * loop) + 63 - 15)]) << (32 - (18))) | ((w_blocks_d[hook(3, (64 * loop) + 63 - 15)]) >> (18))) ^ (w_blocks_d[hook(3, (64 * loop) + 63 - 15)] >> 3)) + ((((w_blocks_d[hook(3, (64 * loop) + 63 - 2)]) << (32 - (17))) | ((w_blocks_d[hook(3, (64 * loop) + 63 - 2)]) >> (17))) ^ (((w_blocks_d[hook(3, (64 * loop) + 63 - 2)]) << (32 - (19))) | ((w_blocks_d[hook(3, (64 * loop) + 63 - 2)]) >> (19))) ^ (w_blocks_d[hook(3, (64 * loop) + 63 - 2)] >> 10));

    loop += get_global_size(0);
  }
}