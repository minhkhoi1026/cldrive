//{"data":12,"dest":8,"dispRange":6,"dist":7,"height":5,"m1":9,"m2":10,"m3":11,"m_d":1,"m_l":2,"m_r":3,"m_u":0,"width":4}
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

  dest[hook(8, 0)] = m1[hook(9, 0)] + m2[hook(10, 0)] + m3[hook(11, 0)] + data[hook(12, 0)];
  minimum = dest[hook(8, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(8, q - 1)] + CONT_COST;
    cur = m1[hook(9, q)] + m2[hook(10, q)] + m3[hook(11, q)] + data[hook(12, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(8, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(8, MAX_DISP - 1)] = (minimum < dest[hook(8, MAX_DISP - 1)]) ? minimum : dest[hook(8, MAX_DISP - 1)];
  acc = dest[hook(8, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(8, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(8, q)] = (prev < dest[hook(8, q)]) ? prev : dest[hook(8, q)];
    acc += dest[hook(8, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(8, q)] -= acc;
  }
}

void gpu_comp_msg_local(local float* m1, local float* m2, local float* m3, float* data, float* dest, int MAX_DISP, float DISCONT_COST, float CONT_COST) {
  float acc;
  float prev, cur, tmp;
  float minimum;
  int q;

  dest[hook(8, 0)] = m1[hook(9, 0)] + m2[hook(10, 0)] + m3[hook(11, 0)] + data[hook(12, 0)];
  minimum = dest[hook(8, 0)];

  for (q = 1; q < MAX_DISP; q++) {
    prev = dest[hook(8, q - 1)] + CONT_COST;
    cur = m1[hook(9, q)] + m2[hook(10, q)] + m3[hook(11, q)] + data[hook(12, q)];
    tmp = (prev < cur) ? prev : cur;
    dest[hook(8, q)] = tmp;
    minimum = (tmp < minimum) ? tmp : minimum;
  }
  minimum += DISCONT_COST;

  dest[hook(8, MAX_DISP - 1)] = (minimum < dest[hook(8, MAX_DISP - 1)]) ? minimum : dest[hook(8, MAX_DISP - 1)];
  acc = dest[hook(8, MAX_DISP - 1)];

  for (q = MAX_DISP - 2; q >= 0; q--) {
    prev = dest[hook(8, q + 1)] + CONT_COST;
    prev = (minimum < prev) ? minimum : prev;
    dest[hook(8, q)] = (prev < dest[hook(8, q)]) ? prev : dest[hook(8, q)];
    acc += dest[hook(8, q)];
  }

  acc /= (float)MAX_DISP;
  for (q = 0; q < MAX_DISP; q++) {
    dest[hook(8, q)] -= acc;
  }
}

kernel void updateCostLayer(global float* m_u, global float* m_d, global float* m_l, global float* m_r, int width, int height, int dispRange, int dist) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int x = tx + get_group_id(0) * get_local_size(0);
  int y = ty + get_group_id(1) * get_local_size(1);

  for (int oi = 0; oi < dist; oi++) {
    for (int oj = 0; oj < dist; oj++) {
      int k = y * dist + oi;
      int l = x * dist + oj;
      if (k <= height || l <= width) {
        for (int d = 0; d < dispRange; d++) {
          m_u[hook(0, (k * width + l) * dispRange + d)] = m_u[hook(0, (y * dist * width + x * dist) * dispRange + d)];
          m_l[hook(2, (k * width + l) * dispRange + d)] = m_l[hook(2, (y * dist * width + x * dist) * dispRange + d)];
          m_d[hook(1, (k * width + l) * dispRange + d)] = m_d[hook(1, (y * dist * width + x * dist) * dispRange + d)];
          m_r[hook(3, (k * width + l) * dispRange + d)] = m_r[hook(3, (y * dist * width + x * dist) * dispRange + d)];
        }
      }
    }
  }
}