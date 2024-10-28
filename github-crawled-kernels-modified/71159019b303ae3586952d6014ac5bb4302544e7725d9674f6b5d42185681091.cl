//{"buffer":0,"height":2,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwt_init_buffer(global float4* buffer, int width, int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const int idx = mad24(y, width, x);

  buffer[hook(0, idx)] = 0.f;
}