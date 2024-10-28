//{"data":13,"datacost":4,"dest":9,"dispRange":8,"gpu_zero":5,"height":7,"m1":10,"m2":11,"m3":12,"m_d":1,"m_l":2,"m_r":3,"m_u":0,"temp_d":15,"temp_l":16,"temp_r":17,"temp_u":14,"width":6}
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

  dest[hook(9, 0)] = m1[hook(10, 0)] + m2[hook(11, 0)] + m3[hook(12, 0)] + data[hook(13, 0)];
  minimum = dest[hook(9, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(9, q - 1)] + CONT_COST;
    cur = m1[hook(10, q)] + m2[hook(11, q)] + m3[hook(12, q)] + data[hook(13, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(9, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(9, MAX_DISP - 1)] = (minimum < dest[hook(9, MAX_DISP - 1)]) ? minimum : dest[hook(9, MAX_DISP - 1)];
  acc = dest[hook(9, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(9, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(9, q)] = (prev < dest[hook(9, q)]) ? prev : dest[hook(9, q)];
    acc += dest[hook(9, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(9, q)] -= acc;
  }
}

void gpu_comp_msg_local(local float* m1, local float* m2, local float* m3, float* data, float* dest, int MAX_DISP, float DISCONT_COST, float CONT_COST) {
  float acc;
  float prev, cur, tmp;
  float minimum;
  int q;

  dest[hook(9, 0)] = m1[hook(10, 0)] + m2[hook(11, 0)] + m3[hook(12, 0)] + data[hook(13, 0)];
  minimum = dest[hook(9, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(9, q - 1)] + CONT_COST;
    cur = m1[hook(10, q)] + m2[hook(11, q)] + m3[hook(12, q)] + data[hook(13, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(9, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(9, MAX_DISP - 1)] = (minimum < dest[hook(9, MAX_DISP - 1)]) ? minimum : dest[hook(9, MAX_DISP - 1)];
  acc = dest[hook(9, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(9, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(9, q)] = (prev < dest[hook(9, q)]) ? prev : dest[hook(9, q)];
    acc += dest[hook(9, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(9, q)] -= acc;
  }
}

kernel void finalBP(global float* m_u, global float* m_d, global float* m_l, global float* m_r, global float* datacost, global float* gpu_zero, int width, int height, int dispRange) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int x = tx + get_group_id(0) * get_local_size(0);
  int y = ty + get_group_id(1) * get_local_size(1);

  global float* temp_u;
  global float* temp_l;
  global float* temp_d;
  global float* temp_r;

  temp_u = (y != height - 1) ? &m_u[hook(0, ((y + 1) * width + x) * dispRange)] : gpu_zero;
  temp_d = (y != 0) ? &m_d[hook(1, ((y - 1) * width + x) * dispRange)] : gpu_zero;
  temp_l = (x != width - 1) ? &m_l[hook(2, (y * width + x + 1) * dispRange)] : gpu_zero;
  temp_r = (x != 0) ? &m_r[hook(3, (y * width + x - 1) * dispRange)] : gpu_zero;

  float temp;
  for (int k = 0; k < dispRange; k++) {
    temp = temp_u[hook(14, k)] + temp_d[hook(15, k)] + temp_l[hook(16, k)] + temp_r[hook(17, k)] + datacost[hook(4, (y * width + x) * dispRange + k)];

    datacost[hook(4, (y * width + x) * dispRange + k)] = temp;
  }
}