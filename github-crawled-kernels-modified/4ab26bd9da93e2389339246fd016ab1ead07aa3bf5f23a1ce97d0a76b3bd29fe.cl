//{"M":0,"MR":1,"SizeX":2,"SizeY":3,"block":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixRotOptimized(global const float* M, global float* MR, unsigned int SizeX, unsigned int SizeY, local float* block) {
  int2 GID;
  int2 LID;
  int2 NGID;

  GID.x = get_global_id(0);
  GID.y = get_global_id(1);

  LID.x = get_local_id(0);
  LID.y = get_local_id(1);

  NGID.x = (GID.x + GID.y * SizeX) % SizeY;
  NGID.y = (GID.x + GID.y * SizeX) / SizeY;

  if (GID.x < SizeX && GID.y < SizeY) {
    block[hook(4, LID.x + LID.y * get_local_size(0))] = M[hook(0, (SizeY - NGID.x - 1) * SizeX + NGID.y)];
    barrier(0x01);

    MR[hook(1, NGID.y * SizeY + NGID.x)] = block[hook(4, LID.y * get_local_size(0) + LID.x)];
  }
}