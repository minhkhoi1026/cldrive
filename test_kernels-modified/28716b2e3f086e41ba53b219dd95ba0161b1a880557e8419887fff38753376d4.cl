//{"in1":0,"in2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void xcorr_half_improved(global short2* in1, global short2* in2, global short2* out) {
  int offset = get_global_id(0);
  int len = get_global_size(0);
  int res1 = 0, res2 = 0, i = 0;
  do {
    res1 += in1[hook(0, i)].x * in2[hook(1, i + offset)].x;
    res1 += in1[hook(0, i)].y * in2[hook(1, i + offset)].y;
    res2 += in1[hook(0, i)].x * in2[hook(1, i + offset)].y;
    res2 += in1[hook(0, i)].y * in2[hook(1, i + offset + 1)].x;
    i++;
  } while (i != len);
  out[hook(2, offset)].x = res1;
  out[hook(2, offset)].y = res2;
}