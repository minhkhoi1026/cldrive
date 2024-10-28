//{"inputMat":0,"outputMat":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(global uchar* inputMat, global uchar* outputMat) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x > 200 && y > 200)
    outputMat[hook(1, y * get_global_size(0) + x)] = inputMat[hook(0, y * get_global_size(0) + x)];
  else
    outputMat[hook(1, y * get_global_size(0) + x)] = 0;
}