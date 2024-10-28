//{"in":0,"out":1,"out_offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loaduv(global uchar8 const* const in, global float8* out, int out_offset) {
  const int gid = get_global_id(0);
  const uchar8 inv = in[hook(0, gid)];
  const float8 outv = convert_float8(inv);
  out[hook(1, gid + out_offset / 8)] = outv;
}