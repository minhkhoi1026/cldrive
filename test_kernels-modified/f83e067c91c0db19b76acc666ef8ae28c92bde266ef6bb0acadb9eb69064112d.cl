//{"_buf0":0,"_buf1":1,"_buf2":2,"count":3,"triangle_vertices":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float triangle_area(uint4 i, global float4* triangle_vertices) {
  const float4 a = triangle_vertices[hook(4, i.x)];
  const float4 b = triangle_vertices[hook(4, i.y)];
  const float4 c = triangle_vertices[hook(4, i.z)];
  return length(cross(b - a, c - a)) / 2;
}

kernel void copy(global float* _buf0, global uint4* _buf1, global float4* _buf2, const unsigned int count) {
  unsigned int index = get_local_id(0) + (512 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = triangle_area(_buf1[hook(1, index)], _buf2);
      index += 128;
    }
  }
}