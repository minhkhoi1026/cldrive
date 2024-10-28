//{"metaball_positions":2,"num_metaballs":3,"vertex_normals":1,"vertex_positions":0}
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

kernel void generate_smooth_normals(global float4* vertex_positions, global float4* vertex_normals, global float4* metaball_positions, int num_metaballs) {
  const float METABALL_SIZE = 5;

  int id = get_global_id(0);

  float3 normal = (float3)(0, 0, 0);
  for (int i = 0; i < num_metaballs; i++) {
    float dist = distance(vertex_positions[hook(0, id)].xyz, metaball_positions[hook(2, i)].xyz) / METABALL_SIZE;
    float amount = 1 - smoothstepmap(clamp(dist, 0.0f, 1.0f));

    normal += (vertex_positions[hook(0, id)].xyz - metaball_positions[hook(2, i)].xyz) * amount;
  }

  normal = normalize(normal);
  vertex_normals[hook(1, id)] = (float4)(normal, 0);
}