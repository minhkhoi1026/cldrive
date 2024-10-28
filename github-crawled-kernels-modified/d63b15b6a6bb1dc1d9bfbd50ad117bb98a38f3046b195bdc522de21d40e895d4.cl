//{"buffer":3,"data":0,"h":2,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int find_set(global int* data, int loc) {
  while (loc != data[hook(0, loc)] - 2) {
    loc = data[hook(0, loc)] - 2;
  }
  return loc;
}

kernel void solve_locally_nprop(global int* data, int w, int h) {
  int lx = get_local_id(0);
  int ly = get_local_id(1);
  int x = get_global_id(0);
  int y = get_global_id(1);

  char valid = 1;
  local int buffer[8 * 8];
  local char changed;

  if (y >= h || x >= w) {
    valid = 0;
  }
  buffer[hook(3, 8 * ly + lx)] = valid ? data[hook(0, w * y + x)] : 0;
  changed = 1;

  while (changed) {
    barrier(0x01);
    changed = 0;
    barrier(0x01);

    if (valid) {
      int min = 1 << 30;
      int tmp;
      if (lx > 0) {
        tmp = buffer[hook(3, 8 * (ly) + (lx - 1))];
        if (tmp && tmp < min) {
          min = tmp;
        }
      }
      if (lx < 8 - 1) {
        tmp = buffer[hook(3, 8 * (ly) + (lx + 1))];
        if (tmp && tmp < min) {
          min = tmp;
        }
      }
      if (ly > 0) {
        tmp = buffer[hook(3, 8 * (ly - 1) + (lx))];
        if (tmp && tmp < min) {
          min = tmp;
        }
      }
      if (ly < 8 - 1) {
        tmp = buffer[hook(3, 8 * (ly + 1) + (lx))];
        if (tmp && tmp < min) {
          min = tmp;
        }
      }
      if (min < buffer[hook(3, 8 * ly + lx)]) {
        changed = 1;
        buffer[hook(3, 8 * ly + lx)] = min;
      }
    }

    barrier(0x01);
  }

  if (valid) {
    data[hook(0, w * y + x)] = buffer[hook(3, 8 * ly + lx)];
  }
}