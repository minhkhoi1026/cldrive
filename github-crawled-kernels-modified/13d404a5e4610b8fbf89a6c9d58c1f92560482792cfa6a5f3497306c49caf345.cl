//{"normal_map":1,"vertex_map":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void generateNormalMap(read_only image2d_t vertex_map, write_only image2d_t normal_map) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  uint4 center = read_imageui(vertex_map, sampler, (int2)(x, y));
  uint4 right = read_imageui(vertex_map, sampler, (int2)(x + 1, y));
  uint4 down = read_imageui(vertex_map, sampler, (int2)(x, y + 1));

  float4 vector_right = (float4)(right.x - center.x, right.y - center.y, right.z - center.z, 0.0f);
  float4 vector_down = (float4)(down.x - center.x, down.y - center.y, down.z - center.z, 0.0f);

  float4 cross_product = cross(vector_right, vector_down);
  float4 normal = normalize(cross_product);

  write_imagef(normal_map, (int2)(x, y), normal);
}