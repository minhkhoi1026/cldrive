//{"NUM_THREADS":2,"cpy_len":5,"in":0,"m_len":6,"m_off":7,"out":1,"start_inp":4,"startidx":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lzo1x_1_15_decompress(global const unsigned char* in, global unsigned char* out, unsigned short NUM_THREADS, unsigned int startidx, unsigned start_inp, unsigned short cpy_len, unsigned short m_len, unsigned short m_off) {
  int loops = cpy_len / NUM_THREADS;
  int rem = cpy_len % NUM_THREADS;
  int lcid = get_local_id(0);
  int i;
  for (i = 0; i < loops; i++) {
    out[hook(1, startidx + loops * lcid + i)] = in[hook(0, start_inp + loops * lcid + i)];
  }
  startidx += loops * NUM_THREADS;
  start_inp += loops * NUM_THREADS;
  if (lcid < rem) {
    out[hook(1, startidx + lcid)] = in[hook(0, start_inp + lcid)];
  }
  startidx += rem;
  int xtra = NUM_THREADS - m_off;
  if (xtra > 0) {
    NUM_THREADS = m_off;
  }
  loops = m_len / NUM_THREADS;
  rem = m_len % NUM_THREADS;
  if (lcid < NUM_THREADS) {
    for (i = 0; i < loops; i++) {
      out[hook(1, startidx + i * NUM_THREADS + lcid)] = out[hook(1, startidx + i * NUM_THREADS + lcid - m_off)];
    }
    startidx += loops * NUM_THREADS;
    if (lcid < rem) {
      out[hook(1, startidx + lcid)] = out[hook(1, startidx + lcid - m_off)];
    }
  }
}