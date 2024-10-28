//{"fac2":1,"options2":2,"s1":0,"s2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void as_gpu(global float* s1, global const float* fac2, unsigned int options2, global const float* s2) {
  float alpha = fac2[hook(1, 0)];
  if ((options2 >> 2) > 1) {
    for (unsigned int i = 1; i < (options2 >> 2); ++i)
      alpha += fac2[hook(1, i)];
  }
  if (options2 & (1 << 0))
    alpha = -alpha;
  if (options2 & (1 << 1))
    alpha = ((float)(1)) / alpha;

  *s1 = *s2 * alpha;
}