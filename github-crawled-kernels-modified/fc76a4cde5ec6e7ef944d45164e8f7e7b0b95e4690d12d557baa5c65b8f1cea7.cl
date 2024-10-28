//{"height":3,"img":0,"layer":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dwt_add_img_to_layer(global float4* img, global float4* layer, int width, int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const int idx = mad24(y, width, x);

  layer[hook(1, idx)] += img[hook(0, idx)];
}