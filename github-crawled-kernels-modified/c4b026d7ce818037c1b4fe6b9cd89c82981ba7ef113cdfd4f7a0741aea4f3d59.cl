//{"volume":0}
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

kernel void write_clear(global float* volume) {
  volume[hook(0, get_global_id(0))] = 0.0f;
}