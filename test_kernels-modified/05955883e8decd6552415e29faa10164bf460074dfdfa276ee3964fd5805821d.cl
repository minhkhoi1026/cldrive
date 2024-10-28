//{"nb":3,"nf":2,"nx":0,"ny":1,"rnd":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline uint4 cl_random_state(uint4 state) {
  state.s1 = (((state.s1 & 4294967294) << 12)) ^ ((((state.s1 << 13)) ^ state.s1) >> 19);
  state.s2 = (((state.s2 & 4294967288) << 4)) ^ ((((state.s2 << 2)) ^ state.s2) >> 25);
  state.s3 = (((state.s3 & 4294967280) << 17)) ^ ((((state.s3 << 3)) ^ state.s3) >> 11);

  state.s0 = (state.s1 ^ state.s2 ^ state.s3);

  return state;
}

inline float cl_random_prob(uint4 state) {
  return (float)((float)state.s0 / (float)4294967296.0);
}
kernel void cl_rand(const int nx, const int ny, const int nf, const int nb, global uint4* rnd) {
  int l = get_global_id(0);

  uint4 l_rnd = rnd[hook(4, l)];

  l_rnd = cl_random_state(l_rnd);

  rnd[hook(4, l)] = l_rnd;
}