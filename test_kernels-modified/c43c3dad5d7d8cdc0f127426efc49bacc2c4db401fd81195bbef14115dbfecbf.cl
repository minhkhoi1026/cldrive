//{"M_g":0,"M_o":3,"P1_g":1,"P1_o":4,"P2_g":2,"P2_o":5,"X_size":6,"Y_size":7,"step":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float metric(int x1, int y1, int x2, int y2) {
  float x = x1 - x2;
  float y = y1 - y2;
  return x * x + y * y;
}

kernel void JFA(global const unsigned int* M_g, global const unsigned int* P1_g, global const unsigned int* P2_g, global unsigned int* M_o, global unsigned int* P1_o, global unsigned int* P2_o, int X_size, int Y_size, int step) {
  int gid = get_global_id(0);
  int y = gid % Y_size;
  int x = (gid - y) / Y_size;

  int best_0 = M_g[hook(0, ((x) * Y_size + (y)))];
  int best_1a = P1_g[hook(1, ((x) * Y_size + (y)))];
  int best_1b = P2_g[hook(2, ((x) * Y_size + (y)))];
  float bestS = metric(best_1a, best_1b, x, y);
  if (best_0 == 0)
    bestS = 4294967296;

  for (int i = 0; i < 12; i++) {
    int A = (step * cos((float)((6.28 / 12) * i)));
    int B = (step * sin((float)((6.28 / 12) * i)));
    int nx = x + A;
    int ny = y + B;
    if (nx < 0 || X_size <= nx || ny < 0 || Y_size <= ny)
      continue;
    int idx = ((nx)*Y_size + (ny));
    if (P1_g[hook(1, idx)] == 0 && P2_g[hook(2, idx)] == 0)
      continue;
    float s2 = metric(P1_g[hook(1, idx)], P2_g[hook(2, idx)], x, y);
    if (bestS >= s2) {
      best_0 = M_g[hook(0, idx)];
      best_1a = P1_g[hook(1, idx)];
      best_1b = P2_g[hook(2, idx)];
      bestS = s2;
    }
  }

  M_o[hook(3, ((x) * Y_size + (y)))] = best_0;
  P1_o[hook(4, ((x) * Y_size + (y)))] = best_1a;
  P2_o[hook(5, ((x) * Y_size + (y)))] = best_1b;
}