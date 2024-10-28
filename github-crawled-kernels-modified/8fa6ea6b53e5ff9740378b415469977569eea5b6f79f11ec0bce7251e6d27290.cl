//{"coeff":1,"filter_len":3,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_half(global short* in, global short* coeff, global short* out, int filter_len) {
  int index = get_global_id(0);
  int i = 0, acc = 0;
  do {
    acc += in[hook(0, index + i)] * coeff[hook(1, i)];
    i++;
  } while (i != filter_len);
  out[hook(2, index)] = acc;
}