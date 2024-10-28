//{"bottom":1,"size":3,"top":2,"volume":0,"x":4,"y":5,"z":6}
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

kernel void write_metaball(global float* volume, int3 bottom, int3 top, int3 size, float x, float y, float z) {
  const int METABALL_SIZE = 10;

  int id = get_global_id(0);

  int3 box_size = top - bottom;
  int3 pos = bottom + volume_position(id, box_size);

  float dist = distance((float3)(pos.x, pos.y, pos.z), (float3)(x, y, z)) / METABALL_SIZE;
  float amount = 1 - smoothstepmap(clamp(dist, 0.0f, 1.0f));

  int index = volume_coords(pos, size);

  volume[hook(0, index)] += amount;
}