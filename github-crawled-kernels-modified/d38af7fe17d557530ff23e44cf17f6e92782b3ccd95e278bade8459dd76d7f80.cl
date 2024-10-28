//{"size_x":4,"size_y":5,"size_z":6,"value":7,"volume":0,"x":1,"y":2,"z":3}
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

kernel void write_point(global float* volume, int x, int y, int z, int size_x, int size_y, int size_z, float value) {
  int pos = volume_coords((int3)(x, y, z), (int3)(size_x, size_y, size_z));
  volume[hook(0, pos)] = value;
}