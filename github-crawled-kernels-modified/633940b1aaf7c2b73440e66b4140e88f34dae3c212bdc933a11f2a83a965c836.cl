//{"height":2,"lpass":0,"lpass_mult":5,"sc":3,"temp_buffer":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwt_hat_transform_col(global float4* lpass, int width, int height, const int sc, global float4* temp_buffer, const float lpass_mult) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width)
    return;

  const float hat_mult = 2.f;
  const int size = height;

  if (y < sc) {
    temp_buffer[hook(4, mad24(y, width, x))] = (hat_mult * lpass[hook(0, mad24(y, width, x))] + lpass[hook(0, mad24((sc - y), width, x))] + lpass[hook(0, mad24((y + sc), width, x))]) * lpass_mult;
  } else if (y + sc < size) {
    temp_buffer[hook(4, mad24(y, width, x))] = (hat_mult * lpass[hook(0, mad24(y, width, x))] + lpass[hook(0, mad24((y - sc), width, x))] + lpass[hook(0, mad24((y + sc), width, x))]) * lpass_mult;
  } else if (y < size) {
    temp_buffer[hook(4, mad24(y, width, x))] = (hat_mult * lpass[hook(0, mad24(y, width, x))] + lpass[hook(0, mad24((y - sc), width, x))] + lpass[hook(0, mad24((2 * size - 2 - (y + sc)), width, x))]) * lpass_mult;
  }
}