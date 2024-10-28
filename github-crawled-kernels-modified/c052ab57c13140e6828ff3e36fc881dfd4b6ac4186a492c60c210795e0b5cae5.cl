//{"a":0,"b":1,"c":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Mult(read_only image2d_t a, read_only image2d_t b, write_only image2d_t c, unsigned int size) {
  const sampler_t sampler = 0 | 0 | 0x10;

  size_t col = get_global_id(0);
  size_t row = get_global_id(1);

  if (col >= size || row >= size)
    return;

  float sum = 0;
  for (size_t i = 0; i < size; i++) {
    float4 value1 = read_imagef(a, sampler, (int2)(i, row));
    float4 value2 = read_imagef(b, sampler, (int2)(col, i));

    sum += value1.x * value2.x;
  }

  write_imagef(c, (int2)(col, row), sum);
}