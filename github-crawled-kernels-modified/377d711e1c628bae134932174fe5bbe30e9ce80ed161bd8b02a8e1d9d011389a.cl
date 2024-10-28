//{"in":1,"nseeds":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rng(const unsigned int nseeds, global ulong* in, global ulong* out) {
  size_t gid = get_global_id(0);

  if (gid < nseeds) {
    ulong state = in[hook(1, gid)];

    state ^= (state << 21);
    state ^= (state >> 35);
    state ^= (state << 4);

    out[hook(2, gid)] = state;
  }
}