//{"CONT_COST":15,"DISCONT_COST":14,"data":20,"datacost":4,"dest":16,"dispRange":12,"dist":13,"gpu_zero":9,"height":11,"m1":17,"m2":18,"m3":19,"m_d":6,"m_l":7,"m_r":8,"m_u":5,"temp_m_d":1,"temp_m_l":2,"temp_m_r":3,"temp_m_u":0,"width":10}
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

kernel void hierBP(global float* temp_m_u, global float* temp_m_d, global float* temp_m_l, global float* temp_m_r, global float* datacost, global float* m_u, global float* m_d, global float* m_l, global float* m_r, global float* gpu_zero, int width, int height, int dispRange, int dist, float DISCONT_COST, float CONT_COST) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int x = tx + get_group_id(0) * get_local_size(0);
  int y = ty + get_group_id(1) * get_local_size(1);

  global float* temp_u;
  global float* temp_l;
  global float* temp_d;
  global float* temp_r;

  temp_u = (y + 1 >= height) ? gpu_zero : &m_u[hook(5, ((width * dist) * (y + 1) * dist + x * dist) * dispRange)];
  temp_l = (x + 1 >= width) ? gpu_zero : &m_l[hook(7, ((width * dist) * (y) * dist + (x + 1) * dist) * dispRange)];
  temp_r = (x - 1 < 0) ? gpu_zero : &m_r[hook(8, ((width * dist) * (y) * dist + (x - 1) * dist) * dispRange)];
  temp_d = (y - 1 < 0) ? gpu_zero : &m_d[hook(6, ((width * dist) * (y - 1) * dist + x * dist) * dispRange)];

  gpu_comp_msg(temp_u, temp_l, temp_r, &datacost[hook(4, (width * (y) + x) * dispRange)], &temp_m_u[hook(0, ((width * dist) * (y) * dist + x * dist) * dispRange)], dispRange, DISCONT_COST, CONT_COST);
  gpu_comp_msg(temp_d, temp_l, temp_r, &datacost[hook(4, (width * (y) + x) * dispRange)], &temp_m_d[hook(1, ((width * dist) * (y) * dist + x * dist) * dispRange)], dispRange, DISCONT_COST, CONT_COST);
  gpu_comp_msg(temp_u, temp_d, temp_r, &datacost[hook(4, (width * (y) + x) * dispRange)], &temp_m_r[hook(3, ((width * dist) * (y) * dist + x * dist) * dispRange)], dispRange, DISCONT_COST, CONT_COST);
  gpu_comp_msg(temp_u, temp_d, temp_l, &datacost[hook(4, (width * (y) + x) * dispRange)], &temp_m_l[hook(2, ((width * dist) * (y) * dist + x * dist) * dispRange)], dispRange, DISCONT_COST, CONT_COST);
}