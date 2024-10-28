//{"correspondences":2,"matrix_a":3,"normal_map":1,"vector_b":4,"vertex_map":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void computeMatricesForTransformation(read_only image2d_t vertex_map, read_only image2d_t normal_map, global const float3* correspondences, global float* matrix_a, global float* vector_b) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);
  unsigned int width = get_image_width(vertex_map);
  unsigned int index = y * width + x;
  unsigned int row_index = index * 6;

  float3 source = correspondences[hook(2, index)];
  uint4 dest = read_imageui(vertex_map, sampler, (int2)(x, y));
  uint4 normal = read_imageui(normal_map, sampler, (int2)(x, y));

  matrix_a[hook(3, row_index + 0)] = normal.z * source.y - normal.y * source.z;
  matrix_a[hook(3, row_index + 1)] = normal.x * source.z - normal.z * source.x;
  matrix_a[hook(3, row_index + 2)] = normal.y * source.x - normal.x * source.y;
  matrix_a[hook(3, row_index + 3)] = normal.x;
  matrix_a[hook(3, row_index + 4)] = normal.y;
  matrix_a[hook(3, row_index + 5)] = normal.z;

  vector_b[hook(4, index)] = normal.x * dest.x + normal.y * dest.y + normal.z * dest.z - normal.x * source.x - normal.y * source.y - normal.z * source.z;
}