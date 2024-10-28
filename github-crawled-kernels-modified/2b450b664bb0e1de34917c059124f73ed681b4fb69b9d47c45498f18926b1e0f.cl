//{"a":0,"alpha":3,"b":1,"height":5,"out":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lerp(global const float4* a, global const float4* b, global float4* out, const float alpha, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int idx = x + width * y;

  if (x >= width || y >= height) {
    return;
  }

  out[hook(2, idx)] = (1 - alpha) * a[hook(0, idx)] + alpha * b[hook(1, idx)];
}