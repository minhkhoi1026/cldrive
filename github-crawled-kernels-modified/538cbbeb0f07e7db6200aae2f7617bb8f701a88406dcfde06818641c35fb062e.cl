//{"metaball_positions":2,"num_metaballs":3,"size":1,"volume":0}
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

kernel void write_metaballs(global float* volume, int3 size, global float4* metaball_positions, int num_metaballs) {
  const int METABALL_SIZE = 5;

  int id = get_global_id(0);

  int3 pos = volume_position(id, size);
  int index = volume_coords(pos, size);

  for (int i = 0; i < num_metaballs; i++) {
    float3 metaball_pos = metaball_positions[hook(2, i)].xyz;
    float dist = distance((float3)(pos.x, pos.y, pos.z), metaball_pos) / METABALL_SIZE;
    float amount = 1 - smoothstepmap(clamp(dist, 0.0f, 1.0f));

    volume[hook(0, index)] += amount;
  }
}