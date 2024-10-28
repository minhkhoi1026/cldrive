//{"aa":1,"b":2,"c":3,"n":0,"table":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvecmult_special_kern(unsigned int n, global float* aa, global float* b, global float* c, read_only image2d_t table) {
  const sampler_t sampler0 = 0 | 0 | 0x10;

  int i = get_global_id(0);
  int j;
  float tmp = 0.0f;
  for (j = 0; j < n; j++) {
    int ri = i % 24;
    int rj = j % 24;
    float4 coef = read_imagef(table, sampler0, (int2)(ri, rj));
    tmp += coef.x * aa[hook(1, i * n + j)] * b[hook(2, j)];
  }
  c[hook(3, i)] = tmp;
}