//{"rbuff":0,"to":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void heights(global float* rbuff, global float8* to) {
  int i = get_global_id(1);
  int j = get_global_id(0);
  float height = 0.0;

  {
    height += (to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s0 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s1 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s2 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s3 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s4 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s5 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s6 + to[hook(1, (i) * (16 * 4) + (0) * 16 + (j))].s7);
    height += (to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s0 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s1 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s2 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s3 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s4 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s5 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s6 + to[hook(1, (i) * (16 * 4) + (1) * 16 + (j))].s7);
    height += (to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s0 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s1 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s2 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s3 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s4 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s5 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s6 + to[hook(1, (i) * (16 * 4) + (2) * 16 + (j))].s7);
    height += (to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s0 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s1 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s2 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s3 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s4 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s5 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s6 + to[hook(1, (i) * (16 * 4) + (3) * 16 + (j))].s7);
    height += (to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s0 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s1 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s2 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s3 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s4 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s5 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s6 + to[hook(1, (i) * (16 * 4) + (4) * 16 + (j))].s7);
  }

  { rbuff[hook(0, 2 * 3 * (j + i * 16) + 1)] = height; }

  if (i > 0) {
    rbuff[hook(0, 2 * 3 * (j + (i - 1) * 16) + 4)] = height;
  }
}