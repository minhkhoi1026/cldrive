//{"a":0,"alpha":3,"b":1,"height":5,"out":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lerp(global const uchar4* a, global const uchar4* b, global uchar4* out, const float alpha, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int idx = x + width * y;

  if (x >= width || y >= height) {
    return;
  }

  const float4 af = convert_float4(a[hook(0, idx)]);
  const float4 bf = convert_float4(b[hook(1, idx)]);
  uchar4 tmp = convert_uchar4((1 - alpha) * af + alpha * bf);

  tmp.w = 255;

  out[hook(2, idx)] = tmp;
}