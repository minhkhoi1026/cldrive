//{"M":0,"MR":1,"SizeX":2,"SizeY":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixRotNaive(global const float* M, global float* MR, unsigned int SizeX, unsigned int SizeY) {
  int2 GID;

  GID.x = get_global_id(0);
  GID.y = get_global_id(1);

  if (GID.x < SizeX && GID.y < SizeY) {
    MR[hook(1, GID.x * SizeY + (SizeY - GID.y - 1))] = M[hook(0, GID.y * SizeX + GID.x)];
  }
}