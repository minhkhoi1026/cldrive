//{"height":3,"hpass":1,"lpass":0,"sc":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwt_hat_transform_row(global float4* lpass, global float4* hpass, int width, int height, const int sc) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (y >= height)
    return;

  const float hat_mult = 2.f;
  const int size = width;

  if (x < sc) {
    const int h_idx = mad24(y, width, x);

    lpass[hook(0, h_idx)] = hat_mult * hpass[hook(1, mad24(y, width, x))] + hpass[hook(1, mad24(y, width, (sc - x)))] + hpass[hook(1, mad24(y, width, (x + sc)))];
  } else if (x + sc < size) {
    const int h_idx = mad24(y, width, x);

    lpass[hook(0, h_idx)] = hat_mult * hpass[hook(1, mad24(y, width, x))] + hpass[hook(1, mad24(y, width, (x - sc)))] + hpass[hook(1, mad24(y, width, (x + sc)))];
  } else if (x < size) {
    const int h_idx = mad24(y, width, x);

    lpass[hook(0, h_idx)] = hat_mult * hpass[hook(1, mad24(y, width, x))] + hpass[hook(1, mad24(y, width, (x - sc)))] + hpass[hook(1, mad24(y, width, (2 * size - 2 - (x + sc))))];
  }
}