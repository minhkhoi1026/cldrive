//{"M":0,"MR":1,"SizeX":2,"SizeY":3,"block":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixRotOptimized_x(global const float* M, global float* MR, unsigned int SizeX, unsigned int SizeY, local float* block) {
  int2 GID;
  GID.x = get_global_id(0);
  GID.y = get_global_id(1);

  int2 LID;
  LID.x = get_local_id(0);
  LID.y = get_local_id(1);

  if (GID.x < SizeX && GID.y < SizeY) {
    block[hook(4, LID.y * get_local_size(0) + LID.x)] = M[hook(0, GID.y * SizeX + GID.x)];
  }

  barrier(0x01);

  if (LID.y == 0) {
    for (int i = get_local_size(1) - 1; i >= 0; i--) {
      MR[hook(1, GID.x * SizeY + (SizeY - GID.y - i - 1))] = block[hook(4, i * get_local_size(0) + LID.x)];
    }
  }
}