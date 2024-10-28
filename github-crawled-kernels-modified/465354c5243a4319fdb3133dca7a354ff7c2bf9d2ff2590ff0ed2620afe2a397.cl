//{"IDS_g":1,"M_o":2,"P1_o":3,"P2_o":4,"PTS_g":0,"X_size":6,"Y_size":7,"numbef_of_seeds":5}
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

kernel void Brute(global const ushort2* PTS_g, global const unsigned int* IDS_g, global unsigned int* M_o, global unsigned int* P1_o, global unsigned int* P2_o, int numbef_of_seeds, int X_size, int Y_size) {
  int gid = get_global_id(0);
  int y = gid % Y_size;
  int x = (gid - y) / Y_size;

  int best_0 = IDS_g[hook(1, 0)];
  int best_1a = PTS_g[hook(0, 0)].x;
  int best_1b = PTS_g[hook(0, 0)].y;
  float bestS = metric(best_1a, best_1b, x, y);
  if (best_0 == 0)
    bestS = 4294967296;

  for (int i = 1; i < numbef_of_seeds; i++) {
    float s2 = metric(PTS_g[hook(0, i)].x, PTS_g[hook(0, i)].y, x, y);
    if (bestS >= s2) {
      best_0 = IDS_g[hook(1, i)];
      best_1a = PTS_g[hook(0, i)].x;
      best_1b = PTS_g[hook(0, i)].y;
      bestS = s2;
    }
  }

  M_o[hook(2, ((x) * Y_size + (y)))] = best_0;
  P1_o[hook(3, ((x) * Y_size + (y)))] = best_1a;
  P2_o[hook(4, ((x) * Y_size + (y)))] = best_1b;
}