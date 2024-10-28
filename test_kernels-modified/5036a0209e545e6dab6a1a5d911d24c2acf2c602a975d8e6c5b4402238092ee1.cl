//{"IDS_g":4,"M_g":0,"M_o":6,"NOISE_g":5,"P1_g":1,"P1_o":7,"P2_g":2,"P2_o":8,"PTS_g":3,"X_size":9,"Y_size":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void noise(global const unsigned int* M_g, global const unsigned int* P1_g, global const unsigned int* P2_g, global const ushort2* PTS_g, global const unsigned int* IDS_g, global const unsigned int* NOISE_g, global unsigned int* M_o, global unsigned int* P1_o, global unsigned int* P2_o, int X_size, int Y_size) {
  int gid = get_global_id(0);

  int m = M_g[hook(0, gid)], p1 = P1_g[hook(1, gid)], p2 = P2_g[hook(2, gid)];

  if (p1 == 0 && p2 == 0) {
    int ridx = NOISE_g[hook(5, gid)];
    m = IDS_g[hook(4, ridx)];
    p1 = PTS_g[hook(3, ridx)].x;
    p2 = PTS_g[hook(3, ridx)].y;
  }

  M_o[hook(6, gid)] = m;
  P1_o[hook(7, gid)] = p1;
  P2_o[hook(8, gid)] = p2;
}