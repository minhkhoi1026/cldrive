//{"A":3,"B":4,"C":2,"cols":0,"rows":1,"sampler":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add4(int cols, int rows, write_only image2d_t C, read_only image2d_t A, read_only image2d_t B, sampler_t sampler) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  if (x >= cols || y >= rows)
    return;

  float4 tap1 = read_imagef(A, sampler, (int2)(x, y));
  float4 tap2 = read_imagef(B, sampler, (int2)(x, y));

  float4 res = tap1 + tap2;

  write_imagef(C, (int2)(x, y), res);
}