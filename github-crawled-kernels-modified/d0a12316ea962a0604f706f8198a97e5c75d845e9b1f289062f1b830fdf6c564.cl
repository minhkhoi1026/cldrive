//{"length":0,"result_inx":2,"result_val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_fit_phase_1(int length, global float* result_val, global int* result_inx) {
  int tid = get_global_id(0);
  if (tid == 0) {
    float maxval = result_val[hook(1, 0)];
    int maxinx = result_inx[hook(2, 0)];

    for (int i = 1; i < length; i++) {
      float x = result_val[hook(1, i)];
      if (x > maxval) {
        maxval = x;
        maxinx = result_inx[hook(2, i)];
      }
    }
    result_inx[hook(2, 0)] = maxinx;
  }
}