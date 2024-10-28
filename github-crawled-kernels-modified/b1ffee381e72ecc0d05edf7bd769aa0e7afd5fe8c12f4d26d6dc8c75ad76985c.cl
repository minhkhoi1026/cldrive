//{"point_color":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int volume_coords(int3 coords, int3 size) {
  return coords.x + coords.y * size.x + coords.z * size.x * size.y;
}

int3 volume_position(int index, int3 size) {
  return (int3)(index % size.x, (index / (size.x)) % size.y, index / (size.x * size.y));
}

float smoothstepmap(float val) {
  return val * val * (3 - 2 * val);
}

kernel void write_point_color_back(global float* volume, global float4* point_color) {
  float float3 = volume[hook(0, get_global_id(0))];
  point_color[hook(1, get_global_id(0))] = (float4)(float3, 0, 0, 1);
}