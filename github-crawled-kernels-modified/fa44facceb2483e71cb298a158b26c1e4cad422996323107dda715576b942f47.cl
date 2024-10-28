//{"cols":3,"dst":1,"dst_offset":7,"dst_step":6,"map":0,"map_offset":5,"map_step":4,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float calc(int x, int y) {
  return (float)abs(x) + abs(y);
}
struct PtrStepSz {
  global int* ptr;
  int step;
  int rows, cols;
};
inline int get(struct PtrStepSz data, int y, int x) {
  return *((global int*)((global char*)data.ptr + data.step * (y + 1) + sizeof(int) * (x + 1)));
}
inline void set(struct PtrStepSz data, int y, int x, int value) {
  *((global int*)((global char*)data.ptr + data.step * (y + 1) + sizeof(int) * (x + 1))) = value;
}
constant int c_dx[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
constant int c_dy[8] = {-1, -1, -1, 0, 0, 1, 1, 1};

kernel void getEdges(global const int* map, global uchar* dst, int rows, int cols, int map_step, int map_offset, int dst_step, int dst_offset) {
  map_step /= sizeof(*map);
  map_offset /= sizeof(*map);

  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  if (gidy < rows && gidx < cols) {
    dst[hook(1, gidx + gidy * dst_step)] = (uchar)(-(map[hook(0, gidx + 1 + (gidy + 1) * map_step + map_offset)] >> 1));
  }
}