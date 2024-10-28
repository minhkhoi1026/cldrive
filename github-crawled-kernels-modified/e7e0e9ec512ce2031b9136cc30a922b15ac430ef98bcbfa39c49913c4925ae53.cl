//{"dst":0,"main":1,"overlay":2,"x_position":3,"y_position":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void overlay_no_alpha(write_only image2d_t dst, read_only image2d_t main, read_only image2d_t overlay, int x_position, int y_position) {
  const sampler_t sampler = (0 | 0x10);

  int2 overlay_size = get_image_dim(overlay);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));

  if (loc.x < x_position || loc.y < y_position || loc.x >= overlay_size.x + x_position || loc.y >= overlay_size.y + y_position) {
    float4 val = read_imagef(main, sampler, loc);
    write_imagef(dst, loc, val);
  } else {
    int2 loc_overlay = (int2)(x_position, y_position);
    float4 val = read_imagef(overlay, sampler, loc - loc_overlay);
    write_imagef(dst, loc, val);
  }
}