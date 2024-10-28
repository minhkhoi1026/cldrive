//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void xcorr_improved(global int* in1, global int* in2, global int* out) {
  int offset = get_global_id(0) << 2;
  int len = get_global_size(0) << 2;
  int i = 0;
  int res1 = 0, res2 = 0, res3 = 0, res4 = 0;
  do {
    res1 += in1[hook(0, i)] * in2[hook(1, i + offset)];
    res2 += in1[hook(0, i)] * in2[hook(1, i + offset + 1)];
    res3 += in1[hook(0, i)] * in2[hook(1, i + offset + 2)];
    res4 += in1[hook(0, i)] * in2[hook(1, i + offset + 3)];
    i++;
  } while (i != len);
  out[hook(2, offset)] = res1;
  out[hook(2, offset + 1)] = res2;
  out[hook(2, offset + 2)] = res3;
  out[hook(2, offset + 3)] = res4;
}