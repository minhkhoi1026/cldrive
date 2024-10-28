//{"c_dx":9,"c_dy":10,"cols":5,"count":6,"counter":3,"map":0,"map_offset":8,"map_step":7,"rows":4,"s_st":11,"st1":1,"st2":2}
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

kernel void __attribute__((reqd_work_group_size(128, 1, 1))) edgesHysteresisGlobal(global int* map, global ushort2* st1, global ushort2* st2, global int* counter, int rows, int cols, int count, int map_step, int map_offset) {
  map_step /= sizeof(*map);
  map_offset /= sizeof(*map);

  map += map_offset;

  int lidx = get_local_id(0);

  int grp_idx = get_group_id(0);
  int grp_idy = get_group_id(1);

  local unsigned int s_counter;
  local unsigned int s_ind;

  local ushort2 s_st[512];

  if (lidx == 0) {
    s_counter = 0;
  }
  barrier(0x01);

  int ind = mad24(grp_idy, (int)get_local_size(0), grp_idx);

  if (ind < count) {
    ushort2 pos = st1[hook(1, ind)];
    if (lidx < 8) {
      pos.x += c_dx[hook(9, lidx)];
      pos.y += c_dy[hook(10, lidx)];
      if (pos.x > 0 && pos.x <= cols && pos.y > 0 && pos.y <= rows && map[hook(0, pos.x + pos.y * map_step)] == 1) {
        map[hook(0, pos.x + pos.y * map_step)] = 2;

        ind = atomic_inc(&s_counter);

        s_st[hook(11, ind)] = pos;
      }
    }
    barrier(0x01);

    while (s_counter > 0 && s_counter <= 512 - get_local_size(0)) {
      const int subTaskIdx = lidx >> 3;
      const int portion = min(s_counter, (unsigned int)(get_local_size(0) >> 3));

      if (subTaskIdx < portion)
        pos = s_st[hook(11, s_counter - 1 - subTaskIdx)];
      barrier(0x01);

      if (lidx == 0)
        s_counter -= portion;
      barrier(0x01);

      if (subTaskIdx < portion) {
        pos.x += c_dx[hook(9, lidx & 7)];
        pos.y += c_dy[hook(10, lidx & 7)];
        if (pos.x > 0 && pos.x <= cols && pos.y > 0 && pos.y <= rows && map[hook(0, pos.x + pos.y * map_step)] == 1) {
          map[hook(0, pos.x + pos.y * map_step)] = 2;

          ind = atomic_inc(&s_counter);

          s_st[hook(11, ind)] = pos;
        }
      }
      barrier(0x01);
    }

    if (s_counter > 0) {
      if (lidx == 0) {
        ind = atomic_add(counter, s_counter);
        s_ind = ind - s_counter;
      }
      barrier(0x01);

      ind = s_ind;

      for (int i = lidx; i < (int)s_counter; i += get_local_size(0)) {
        st2[hook(2, ind + i)] = s_st[hook(11, i)];
      }
    }
  }
}