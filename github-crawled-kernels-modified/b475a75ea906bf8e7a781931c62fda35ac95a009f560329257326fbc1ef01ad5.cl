//{"G":3,"amplitude":1,"angle":2,"in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compass_edge_detection(global unsigned* in, global unsigned* amplitude, global unsigned* angle) {
  unsigned x = get_global_id(1);
  unsigned y = get_global_id(0);
  unsigned rowLen = get_global_size(0);

  bool border = x < 1 | y < 1 | (x > rowLen - 2) | (y > rowLen - 2);
  if (border)
    return;

  unsigned p[3][3];
  unsigned p00 = in[hook(0, (x - 1) * rowLen + y - 1)];
  unsigned p01 = in[hook(0, (x - 1) * rowLen + y)];
  unsigned p02 = in[hook(0, (x - 1) * rowLen + y + 1)];
  unsigned p10 = in[hook(0, x * rowLen + y - 1)];
  unsigned p11 = in[hook(0, x * rowLen + y)];
  unsigned p12 = in[hook(0, x * rowLen + y + 1)];
  unsigned p20 = in[hook(0, (x + 1) * rowLen + y - 1)];
  unsigned p21 = in[hook(0, (x + 1) * rowLen + y)];
  unsigned p22 = in[hook(0, (x + 1) * rowLen + y + 1)];
  int G[8] = {0};
  G[hook(3, 0)] = -1 * p00 + 0 * p01 + 1 * p02 + -2 * p10 + 0 * p11 + 2 * p12 + -1 * p20 + 0 * p21 + 1 * p22;
  G[hook(3, 1)] = -2 * p00 - 1 * p01 + 0 * p02 + -1 * p10 + 0 * p11 + 1 * p12 + -0 * p20 + 1 * p21 + 2 * p22;
  G[hook(3, 2)] = -1 * p00 - 2 * p01 - 1 * p02 + -0 * p10 + 0 * p11 + 0 * p12 + +1 * p20 + 2 * p21 + 1 * p22;
  G[hook(3, 3)] = -0 * p00 - 1 * p01 - 2 * p02 + +1 * p10 + 0 * p11 - 1 * p12 + +2 * p20 + 1 * p21 + 0 * p22;
  G[hook(3, 4)] = -G[hook(3, 0)];
  G[hook(3, 5)] = -G[hook(3, 1)];
  G[hook(3, 6)] = -G[hook(3, 2)];
  G[hook(3, 7)] = -G[hook(3, 3)];
  int max_index = 0, max_val = G[hook(3, 0)], i;
  for (i = 1; i < 8; i++) {
    max_val = G[hook(3, i)] < max_val ? max_val : G[hook(3, i)];
    max_index = G[hook(3, i)] < max_val ? max_index : i;
  }

  amplitude[hook(1, x * rowLen + y)] = max_val;
  angle[hook(2, x * rowLen + y)] = max_index * 45;
}