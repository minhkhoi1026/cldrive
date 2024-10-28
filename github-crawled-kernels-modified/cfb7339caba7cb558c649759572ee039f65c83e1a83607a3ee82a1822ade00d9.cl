//{"datacost":0,"dispRange":4,"height":3,"hierCost":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initializeHierCost(global float* datacost, global float* hierCost, int width, int height, int dispRange) {
  int j = get_global_id(0);
  int i = get_global_id(1);
  int d = get_global_id(2);

  if ((i * 2 + 1) >= (height * 2 - 1) || (j * 2 + 1) >= (width * 2 - 1)) {
    hierCost[hook(1, (dispRange * (width * i + j) + d))] = 0.0f;
  } else {
    hierCost[hook(1, (dispRange * (width * i + j) + d))] = datacost[hook(0, dispRange * ((width * 2) * (i * 2) + (j * 2)) + d)] + datacost[hook(0, dispRange * ((width * 2) * (i * 2 + 1) + (j * 2)) + d)] + datacost[hook(0, dispRange * ((width * 2) * (i * 2) + (j * 2 + 1)) + d)] + datacost[hook(0, dispRange * ((width * 2) * (i * 2 + 1) + (j * 2 + 1)) + d)];
  }
}