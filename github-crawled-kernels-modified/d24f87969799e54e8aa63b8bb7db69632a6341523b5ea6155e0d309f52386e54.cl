//{"CONT_COST":15,"DISCONT_COST":14,"data":20,"datacost":4,"dest":16,"dispRange":12,"dist":13,"gpu_zero":9,"height":11,"m1":17,"m2":18,"m3":19,"m_d":6,"m_l":7,"m_r":8,"m_u":5,"shr_datacost":21,"shr_m_d":28,"shr_m_d[ty]":27,"shr_m_d[ty][tx]":26,"shr_m_l":36,"shr_m_l[ty]":35,"shr_m_l[ty][tx]":34,"shr_m_r":32,"shr_m_r[ty]":31,"shr_m_r[ty][tx]":30,"shr_m_u":24,"shr_m_u[ty]":23,"shr_m_u[ty][tx]":22,"shr_temp":38,"temp_d":29,"temp_l":37,"temp_m_d":1,"temp_m_l":2,"temp_m_r":3,"temp_m_u":0,"temp_r":33,"temp_u":25,"width":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void gpu_comp_msg(global float* m1, global float* m2, global float* m3, global float* data, global float* dest, int MAX_DISP, float DISCONT_COST, float CONT_COST) {
  float acc;
  float prev, cur, tmp;
  float minimum;
  int q;

  dest[hook(16, 0)] = m1[hook(17, 0)] + m2[hook(18, 0)] + m3[hook(19, 0)] + data[hook(20, 0)];
  minimum = dest[hook(16, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(16, q - 1)] + CONT_COST;
    cur = m1[hook(17, q)] + m2[hook(18, q)] + m3[hook(19, q)] + data[hook(20, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(16, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(16, MAX_DISP - 1)] = (minimum < dest[hook(16, MAX_DISP - 1)]) ? minimum : dest[hook(16, MAX_DISP - 1)];
  acc = dest[hook(16, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(16, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(16, q)] = (prev < dest[hook(16, q)]) ? prev : dest[hook(16, q)];
    acc += dest[hook(16, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(16, q)] -= acc;
  }
}

void gpu_comp_msg_local(local float* m1, local float* m2, local float* m3, float* data, float* dest, int MAX_DISP, float DISCONT_COST, float CONT_COST) {
  float acc;
  float prev, cur, tmp;
  float minimum;
  int q;

  dest[hook(16, 0)] = m1[hook(17, 0)] + m2[hook(18, 0)] + m3[hook(19, 0)] + data[hook(20, 0)];
  minimum = dest[hook(16, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(16, q - 1)] + CONT_COST;
    cur = m1[hook(17, q)] + m2[hook(18, q)] + m3[hook(19, q)] + data[hook(20, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(16, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(16, MAX_DISP - 1)] = (minimum < dest[hook(16, MAX_DISP - 1)]) ? minimum : dest[hook(16, MAX_DISP - 1)];
  acc = dest[hook(16, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(16, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(16, q)] = (prev < dest[hook(16, q)]) ? prev : dest[hook(16, q)];
    acc += dest[hook(16, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(16, q)] -= acc;
  }
}

kernel void hierBP_local(global float* temp_m_u, global float* temp_m_d, global float* temp_m_l, global float* temp_m_r, global float* datacost, global float* m_u, global float* m_d, global float* m_l, global float* m_r, global float* gpu_zero, int width, int height, int dispRange, int dist, float DISCONT_COST, float CONT_COST) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int tz = get_global_id(2);

  int x = tx + get_group_id(0) * get_local_size(0);
  int y = ty + get_group_id(1) * get_local_size(1);

  global float* temp_u;
  global float* temp_l;
  global float* temp_d;
  global float* temp_r;

  int index;
  float shr_datacost[32];

  local float shr_m_u[8][8][32 + 1];
  local float shr_m_l[8][8][32 + 1];
  local float shr_m_d[8][8][32 + 1];
  local float shr_m_r[8][8][32 + 1];

  float shr_temp[32];

  if ((y % dist) == 0 && y < height && (x % dist) == 0 && x < width) {
    index = (width * (y) + x) * 32;
    for (int d = 0; d < 32; d++) {
      shr_datacost[hook(21, d)] = datacost[hook(4, index + d)];
    }

    switch (tz) {
      case 0:

        temp_u = (y + 1 >= height) ? gpu_zero : &m_u[hook(5, ((width * dist) * (y + 1) * dist + x * dist) * 32)];
        for (int d = 0; d < 32; d++) {
          shr_m_u[hook(24, ty)][hook(23, tx)][hook(22, d)] = temp_u[hook(25, d)];
        }
        break;

      case 1:

        temp_d = (y - 1 < 0) ? gpu_zero : &m_d[hook(6, ((width * dist) * (y - 1) * dist + x * dist) * 32)];
        for (int d = 0; d < 32; d++) {
          shr_m_d[hook(28, ty)][hook(27, tx)][hook(26, d)] = temp_d[hook(29, d)];
        }
        break;

      case 2:

        temp_r = (x - 1 < 0) ? gpu_zero : &m_r[hook(8, ((width * dist) * (y) * dist + (x - 1) * dist) * 32)];
        for (int d = 0; d < 32; d++) {
          shr_m_r[hook(32, ty)][hook(31, tx)][hook(30, d)] = temp_r[hook(33, d)];
        }
        break;

      case 3:

        temp_l = (x + 1 >= width) ? gpu_zero : &m_l[hook(7, ((width * dist) * (y) * dist + (x + 1) * dist) * 32)];
        for (int d = 0; d < 32; d++) {
          shr_m_l[hook(36, ty)][hook(35, tx)][hook(34, d)] = temp_l[hook(37, d)];
        }
        break;
    }

    barrier(0x01);

    index = ((width) * (y) + x) * 32;

    switch (tz) {
      case 0:
        gpu_comp_msg_local(shr_m_u[hook(24, ty)][hook(23, tx)], shr_m_l[hook(36, ty)][hook(35, tx)], shr_m_r[hook(32, ty)][hook(31, tx)], shr_datacost, shr_temp, 32, DISCONT_COST, CONT_COST);
        for (int d = 0; d < 32; d++) {
          temp_m_u[hook(0, index + d)] = shr_temp[hook(38, d)];
        }
        break;

      case 1:
        gpu_comp_msg_local(shr_m_d[hook(28, ty)][hook(27, tx)], shr_m_l[hook(36, ty)][hook(35, tx)], shr_m_r[hook(32, ty)][hook(31, tx)], shr_datacost, shr_temp, 32, DISCONT_COST, CONT_COST);
        for (int d = 0; d < 32; d++) {
          temp_m_d[hook(1, index + d)] = shr_temp[hook(38, d)];
        }
        break;

      case 2:
        gpu_comp_msg_local(shr_m_u[hook(24, ty)][hook(23, tx)], shr_m_d[hook(28, ty)][hook(27, tx)], shr_m_r[hook(32, ty)][hook(31, tx)], shr_datacost, shr_temp, 32, DISCONT_COST, CONT_COST);
        for (int d = 0; d < 32; d++) {
          temp_m_r[hook(3, index + d)] = shr_temp[hook(38, d)];
        }
        break;

      case 3:
        gpu_comp_msg_local(shr_m_u[hook(24, ty)][hook(23, tx)], shr_m_d[hook(28, ty)][hook(27, tx)], shr_m_l[hook(36, ty)][hook(35, tx)], shr_datacost, shr_temp, 32, DISCONT_COST, CONT_COST);
        for (int d = 0; d < 32; d++) {
          temp_m_l[hook(2, index + d)] = shr_temp[hook(38, d)];
        }
        break;
    }
  }
}