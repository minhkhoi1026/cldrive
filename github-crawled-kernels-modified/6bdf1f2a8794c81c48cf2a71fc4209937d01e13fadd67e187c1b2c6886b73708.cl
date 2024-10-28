//{"in":0,"out":1,"strlength":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_gpu(global const char* in, global char* out, ulong strlength) {
  int num = get_global_id(0);
  if (num < strlength)
    out[hook(1, num)] = in[hook(0, num)] + 1;
}