//{"bh":1,"bl":0,"height":3,"lpass_mult":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwt_subtract_layer(global float4* bl, global float4* bh, int width, int height, const float lpass_mult) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const int idx = mad24(y, width, x);

  bh[hook(1, idx)] -= bl[hook(0, idx)];
}