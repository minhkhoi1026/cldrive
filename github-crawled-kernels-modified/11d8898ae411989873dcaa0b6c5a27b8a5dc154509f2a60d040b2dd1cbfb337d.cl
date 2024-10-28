//{"depth_map":0,"focal_length":1,"principal_point_x":5,"principal_point_y":6,"scale_x":2,"scale_y":3,"skew_coeff":4,"vertex_map":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void generateVertexMap(read_only image2d_t depth_map, const int focal_length, const int scale_x, const int scale_y, const int skew_coeff, const int principal_point_x, const int principal_point_y, write_only image2d_t vertex_map) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  unsigned int depth = read_imageui(depth_map, sampler, coord).x;

  uint4 vertex = (uint4)((unsigned int)(focal_length * scale_x * coord.x) * depth, (unsigned int)(skew_coeff * coord.x + focal_length * scale_y * coord.y) * depth, (unsigned int)(principal_point_x * coord.x + principal_point_y * coord.y + 1) * depth, 0);

  write_imageui(vertex_map, coord, vertex);
}