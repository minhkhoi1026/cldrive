//{"border_u":5,"border_v":6,"border_y":4,"coords_num":3,"output_uv":1,"output_y":0,"wire_frames_coords":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_wire_frame(write_only image2d_t output_y, write_only image2d_t output_uv, global uint2* wire_frames_coords, unsigned int coords_num, float border_y, float border_u, float border_v) {
  if (coords_num == 0) {
    return;
  }

  int gid = get_global_id(0);
  if (gid >= coords_num) {
    return;
  }

  uint2 coord = wire_frames_coords[hook(2, gid)];

  write_imagef(output_y, (int2)(coord.x / 2, coord.y), (float4)(border_y));
  if (coord.y % 2 == 0) {
    write_imagef(output_uv, (int2)(coord.x / 2, coord.y / 2), (float4)(border_u, border_v, 0.0f, 0.0f));
  }
}