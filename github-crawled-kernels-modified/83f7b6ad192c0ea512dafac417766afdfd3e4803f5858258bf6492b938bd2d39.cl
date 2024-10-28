//{"WxH":2,"fitness":5,"num_cities":1,"pop_len":0,"x_coord":3,"y_coord":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fitness(int pop_len, int num_cities, int WxH, global int* x_coord, global int* y_coord, global float* fitness) {
  int tid = get_global_id(0);

  if (tid < pop_len) {
    int distance = 0;

    int baseOffset = tid * num_cities;
    for (int i = 0; i < num_cities - 1; i++) {
      int dx = x_coord[hook(3, baseOffset + i)] - x_coord[hook(3, baseOffset + i + 1)];
      int dy = y_coord[hook(4, baseOffset + i)] - y_coord[hook(4, baseOffset + i + 1)];
      distance += dx * dx + dy * dy;
    }

    fitness[hook(5, tid)] = (float)WxH / (float)distance;
  }
}