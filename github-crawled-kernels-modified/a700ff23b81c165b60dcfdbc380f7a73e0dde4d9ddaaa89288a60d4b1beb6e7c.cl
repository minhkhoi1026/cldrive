//{"X":0,"X[i]":4,"Y":1,"Y[i]":3,"seuil":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SEUIL_GPU_dev(global const float X[2048][2048], global unsigned char Y[2048][2048], float seuil) {
  size_t i, j;
  i = get_global_id(1);
  j = get_global_id(2);
  if (j < 2048 - 4) {
    Y[hook(1, i)][hook(3, j)] = (unsigned char)(X[hook(0, i)][hook(4, j)] > seuil ? 0 : 255);
  }
}