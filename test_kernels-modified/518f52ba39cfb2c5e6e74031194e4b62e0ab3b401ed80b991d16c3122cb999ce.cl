//{"in":0,"out":2,"strlength":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decode_gpu(global const char* in, int strlength, global char* out) {
  int num = get_global_id(0);
  if (num < strlength)
    out[hook(2, num)] = in[hook(0, num)] + 1;
}