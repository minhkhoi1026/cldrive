//{"vertex_normals":1,"vertex_positions":0}
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

float4 vertex_lerp(float threashold, float4 pos1, float4 int2, float val1, float val2) {
  float mu = (threashold - val1) / (val2 - val1);
  float4 ret = pos1 + mu * (int2 - pos1);
  ret.w = 1;
  return ret;
}

kernel void generate_flat_normals(global float4* vertex_positions, global float4* vertex_normals) {
  int id = get_global_id(0);

  float4 pos1 = vertex_positions[hook(0, id * 3 + 0)];
  float4 int2 = vertex_positions[hook(0, id * 3 + 1)];
  float4 pos3 = vertex_positions[hook(0, id * 3 + 2)];

  float3 pos12 = int2.xyz - pos1.xyz;
  float3 pos13 = pos3.xyz - pos1.xyz;

  float3 normal = cross(pos12, pos13);
  normal = normalize(normal);

  vertex_normals[hook(1, id * 3 + 0)] = (float4)(normal, 0);
  vertex_normals[hook(1, id * 3 + 1)] = (float4)(normal, 0);
  vertex_normals[hook(1, id * 3 + 2)] = (float4)(normal, 0);
}