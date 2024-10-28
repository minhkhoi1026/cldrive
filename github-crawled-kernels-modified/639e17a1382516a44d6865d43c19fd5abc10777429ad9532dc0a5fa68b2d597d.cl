//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void xcorr_float_hard_float(global float* in1, global float* in2, global float* out) {
  int offset = get_global_id(0);
  int len = get_global_size(0);
  int i = 0;
  float res = 0;
  do {
    res += in1[hook(0, i)] * in2[hook(1, i + offset)];
    i++;
  } while (i != len);
  out[hook(2, offset)] = res;
}