//{"blocks":4,"buf":5,"cache":3,"consts":2,"global_state":1,"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void core256(const global unsigned int* input, global unsigned int* global_state, const global unsigned int* consts, local unsigned int* cache, unsigned int blocks) {
  unsigned int local_id = get_local_id(0);
  unsigned int parallel_index = get_global_id(0);
  unsigned int parallels = get_global_size(0);
  unsigned int s0, s1, s2, s3, s4, s5, s6, s7;
  unsigned int si0, si1, si2, si3, si4, si5, si6, si7;
 private
  unsigned int buf[64];
  unsigned int cache_copy_size = 64 / get_local_size(0);
  if (cache_copy_size == 0)
    cache_copy_size = 1;

  global_state += parallel_index * 8;

  if (local_id < 64) {
    unsigned int offset = cache_copy_size * local_id;
    for (unsigned int i = 0; i < cache_copy_size; i++)
      cache[hook(3, offset + i)] = consts[hook(2, offset + i)];
  }
  barrier(0x01);
  s0 = global_state[hook(1, 0)];
  s1 = global_state[hook(1, 1)];
  s2 = global_state[hook(1, 2)];
  s3 = global_state[hook(1, 3)];
  s4 = global_state[hook(1, 4)];
  s5 = global_state[hook(1, 5)];
  s6 = global_state[hook(1, 6)];
  s7 = global_state[hook(1, 7)];

  for (unsigned int i = 0; i < blocks; i++) {
    for (unsigned int j = 0; j < 16; j++) {
      unsigned int m = input[hook(0, (parallels * i + parallel_index) * 16 + j)];
      buf[hook(5, j)] = (m >> 24) | ((m >> 8) & 0xff00) | ((m << 8) & 0xff0000) | (m << 24);
    }
    for (unsigned int j = 16; j < 64; j++) {
      unsigned int t1 = buf[hook(5, j - 15)];
      t1 = (((t1 >> 7) | (t1 << 25)) ^ ((t1 >> 18) | (t1 << 14)) ^ (t1 >> 3));
      unsigned int t2 = buf[hook(5, j - 2)];
      t2 = (((t2 >> 17) | (t2 << 15)) ^ ((t2 >> 19) | (t2 << 13)) ^ (t2 >> 10));
      buf[hook(5, j)] = t2 + buf[hook(5, j - 7)] + t1 + buf[hook(5, j - 16)];
    }
    si0 = s0;
    si1 = s1;
    si2 = s2;
    si3 = s3;
    si4 = s4;
    si5 = s5;
    si6 = s6;
    si7 = s7;
    for (unsigned int j = 0; j < 64; j++) {
      unsigned int t1 = si7 + (((si4 >> 6) | (si4 << 26)) ^ ((si4 >> 11) | (si4 << 21)) ^ ((si4 >> 25) | (si4 << 7))) + ((si4 & si5) ^ (~si4 & si6)) + cache[hook(3, j)] + buf[hook(5, j)];
      unsigned int t2 = (((si0 >> 2) | (si0 << 30)) ^ ((si0 >> 13) | (si0 << 19)) ^ ((si0 >> 22) | (si0 << 10)));
      t2 = t2 + ((si0 & si1) ^ (si0 & si2) ^ (si1 & si2));
      si7 = si6;
      si6 = si5;
      si5 = si4;
      si4 = si3 + t1;
      si3 = si2;
      si2 = si1;
      si1 = si0;
      si0 = t1 + t2;
    }
    s0 += si0;
    s1 += si1;
    s2 += si2;
    s3 += si3;
    s4 += si4;
    s5 += si5;
    s6 += si6;
    s7 += si7;
  }

  global_state[hook(1, 0)] = s0;
  global_state[hook(1, 1)] = s1;
  global_state[hook(1, 2)] = s2;
  global_state[hook(1, 3)] = s3;
  global_state[hook(1, 4)] = s4;
  global_state[hook(1, 5)] = s5;
  global_state[hook(1, 6)] = s6;
  global_state[hook(1, 7)] = s7;
}