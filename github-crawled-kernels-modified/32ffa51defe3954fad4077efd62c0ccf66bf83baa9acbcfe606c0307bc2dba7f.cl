//{"changed":3,"data":0,"h":2,"stack_x":4,"stack_y":5,"w":1}
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

kernel void recursively_win(global int* data, int w, int h, global char* changed) {
  int x, y;
  int lx = get_local_id(0);
  int ly = get_local_id(1);
  int tmp, thistmp;
  char eligible;

  local int lowest[1];
  local int stack_x[512];
  local int stack_y[512];
  local int stack_ptr[1];
  int own_pointer;

  while (1) {
    x = get_global_id(0);
    y = get_global_id(1);
    eligible = 0;

    if (lx == 0 && ly == 0) {
      *lowest = 1 << 30;
      *stack_ptr = 0;
    }

    barrier(0x01);

    if ((x < w && y < h) && (thistmp = data[hook(0, (w * y + x))])) {
      if ((y > 0) && data[hook(0, (w * (y - 1) + (x)))] > thistmp) {
        eligible = 1;
      }
      if ((x < w - 1) && data[hook(0, (w * (y) + (x + 1)))] > thistmp) {
        eligible = 1;
      }
      if ((y < h - 1) && data[hook(0, (w * (y + 1) + (x)))] > thistmp) {
        eligible = 1;
      }
      if ((x > 0) && data[hook(0, (w * (y) + (x - 1)))] > thistmp) {
        eligible = 1;
      }

      if (eligible) {
        atomic_min(lowest, thistmp);
      }
    }

    barrier(0x01);
    if (*lowest == 1 << 30) {
      return;
    } else if (lx == 0 && ly == 0) {
      *changed = 1;
    }

    if ((x < w && y < h) && thistmp == *lowest) {
      if ((y > 0)) {
        if (data[hook(0, (w * (y - 1) + (x)))] > thistmp) {
          data[hook(0, (w * (y - 1) + (x)))] = thistmp;
          own_pointer = atomic_inc(stack_ptr);
          stack_x[hook(4, own_pointer)] = x;
          stack_y[hook(5, own_pointer)] = y - 1;
        }
      }
      if ((x < w - 1)) {
        if (data[hook(0, (w * (y) + (x + 1)))] > thistmp) {
          data[hook(0, (w * (y) + (x + 1)))] = thistmp;
          own_pointer = atomic_inc(stack_ptr);
          stack_x[hook(4, own_pointer)] = x + 1;
          stack_y[hook(5, own_pointer)] = y;
        }
      }
      if ((y < h - 1)) {
        if (data[hook(0, (w * (y + 1) + (x)))] > thistmp) {
          data[hook(0, (w * (y + 1) + (x)))] = thistmp;
          own_pointer = atomic_inc(stack_ptr);
          stack_x[hook(4, own_pointer)] = x;
          stack_y[hook(5, own_pointer)] = y + 1;
        }
      }
      if ((x > 0)) {
        if (data[hook(0, (w * (y) + (x - 1)))] > thistmp) {
          data[hook(0, (w * (y) + (x - 1)))] = thistmp;
          own_pointer = atomic_inc(stack_ptr);
          stack_x[hook(4, own_pointer)] = x - 1;
          stack_y[hook(5, own_pointer)] = y;
        }
      }
    }

    thistmp = *lowest;

    while (1) {
      barrier(0x01);
      if (*stack_ptr == 0) {
        break;
      }

      barrier(0x01);
      own_pointer = atomic_dec(stack_ptr) - 1;
      if (own_pointer < 0) {
        atomic_inc(stack_ptr);
      } else {
        x = stack_x[hook(4, own_pointer)];
        y = stack_y[hook(5, own_pointer)];
      }

      barrier(0x01);

      if (own_pointer >= 0) {
        if ((y > 0)) {
          if (data[hook(0, (w * (y - 1) + (x)))] > thistmp) {
            data[hook(0, (w * (y - 1) + (x)))] = thistmp;
            own_pointer = atomic_inc(stack_ptr);
            if (own_pointer >= 512) {
              atomic_dec(stack_ptr);
            } else {
              stack_x[hook(4, own_pointer)] = x;
              stack_y[hook(5, own_pointer)] = y - 1;
            }
          }
        }
        if ((x < w - 1)) {
          if (data[hook(0, (w * (y) + (x + 1)))] > thistmp) {
            data[hook(0, (w * (y) + (x + 1)))] = thistmp;
            own_pointer = atomic_inc(stack_ptr);
            if (own_pointer >= 512) {
              atomic_dec(stack_ptr);
            } else {
              stack_x[hook(4, own_pointer)] = x + 1;
              stack_y[hook(5, own_pointer)] = y;
            }
          }
        }
        if ((y < h - 1)) {
          if (data[hook(0, (w * (y + 1) + (x)))] > thistmp) {
            data[hook(0, (w * (y + 1) + (x)))] = thistmp;
            own_pointer = atomic_inc(stack_ptr);
            if (own_pointer >= 512) {
              atomic_dec(stack_ptr);
            } else {
              stack_x[hook(4, own_pointer)] = x;
              stack_y[hook(5, own_pointer)] = y + 1;
            }
          }
        }
        if ((x > 0)) {
          if (data[hook(0, (w * (y) + (x - 1)))] > thistmp) {
            data[hook(0, (w * (y) + (x - 1)))] = thistmp;
            own_pointer = atomic_inc(stack_ptr);
            if (own_pointer >= 512) {
              atomic_dec(stack_ptr);
            } else {
              stack_x[hook(4, own_pointer)] = x - 1;
              stack_y[hook(5, own_pointer)] = y;
            }
          }
        }
      }
    }
  }
}