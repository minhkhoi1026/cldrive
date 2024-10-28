//{"cols":4,"counter":2,"map_offset":6,"map_ptr":0,"map_step":5,"rows":3,"smem":8,"smem[0]":9,"smem[blockDim.y + 1]":10,"smem[threadIdx.y + 1]":7,"smem[threadIdx.y + 2]":12,"smem[threadIdx.y]":11,"st":1}
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
kernel void __attribute__((reqd_work_group_size(16, 16, 1))) edgesHysteresisLocal(global int* map_ptr, global ushort2* st, global unsigned int* counter, int rows, int cols, int map_step, int map_offset) {
  struct PtrStepSz map = {((global int*)((global char*)map_ptr + map_offset)), map_step, rows + 1, cols + 1};

  local int smem[18][18];

  int2 blockIdx = (int2)(get_group_id(0), get_group_id(1));
  int2 blockDim = (int2)(get_local_size(0), get_local_size(1));
  int2 threadIdx = (int2)(get_local_id(0), get_local_id(1));

  const int x = blockIdx.x * blockDim.x + threadIdx.x;
  const int y = blockIdx.y * blockDim.y + threadIdx.y;

  smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 1)] = x < map.cols && y < map.rows ? get(map, y, x) : 0;
  if (threadIdx.y == 0)
    smem[hook(8, 0)][hook(9, threadIdx.x + 1)] = x < map.cols ? get(map, y - 1, x) : 0;
  if (threadIdx.y == blockDim.y - 1)
    smem[hook(8, blockDim.y + 1)][hook(10, threadIdx.x + 1)] = y + 1 < map.rows ? get(map, y + 1, x) : 0;
  if (threadIdx.x == 0)
    smem[hook(8, threadIdx.y + 1)][hook(7, 0)] = y < map.rows ? get(map, y, x - 1) : 0;
  if (threadIdx.x == blockDim.x - 1)
    smem[hook(8, threadIdx.y + 1)][hook(7, blockDim.x + 1)] = x + 1 < map.cols && y < map.rows ? get(map, y, x + 1) : 0;
  if (threadIdx.x == 0 && threadIdx.y == 0)
    smem[hook(8, 0)][hook(9, 0)] = y > 0 && x > 0 ? get(map, y - 1, x - 1) : 0;
  if (threadIdx.x == blockDim.x - 1 && threadIdx.y == 0)
    smem[hook(8, 0)][hook(9, blockDim.x + 1)] = y > 0 && x + 1 < map.cols ? get(map, y - 1, x + 1) : 0;
  if (threadIdx.x == 0 && threadIdx.y == blockDim.y - 1)
    smem[hook(8, blockDim.y + 1)][hook(10, 0)] = y + 1 < map.rows && x > 0 ? get(map, y + 1, x - 1) : 0;
  if (threadIdx.x == blockDim.x - 1 && threadIdx.y == blockDim.y - 1)
    smem[hook(8, blockDim.y + 1)][hook(10, blockDim.x + 1)] = y + 1 < map.rows && x + 1 < map.cols ? get(map, y + 1, x + 1) : 0;

  barrier(0x01);

  if (x >= cols || y >= rows)
    return;

  int n;

  for (int k = 0; k < 16; ++k) {
    n = 0;

    if (smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 1)] == 1) {
      n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x)] == 2;
      n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x + 1)] == 2;
      n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x + 2)] == 2;

      n += smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x)] == 2;
      n += smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 2)] == 2;

      n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x)] == 2;
      n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x + 1)] == 2;
      n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x + 2)] == 2;
    }

    if (n > 0)
      smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 1)] = 2;
  }

  const int e = smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 1)];

  set(map, y, x, e);

  n = 0;

  if (e == 2) {
    n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x)] == 1;
    n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x + 1)] == 1;
    n += smem[hook(8, threadIdx.y)][hook(11, threadIdx.x + 2)] == 1;

    n += smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x)] == 1;
    n += smem[hook(8, threadIdx.y + 1)][hook(7, threadIdx.x + 2)] == 1;

    n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x)] == 1;
    n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x + 1)] == 1;
    n += smem[hook(8, threadIdx.y + 2)][hook(12, threadIdx.x + 2)] == 1;
  }

  if (n > 0) {
    const int ind = atomic_inc(counter);
    st[hook(1, ind)] = (ushort2)(x + 1, y + 1);
  }
}