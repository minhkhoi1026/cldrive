//{"i":2,"input":0,"output":1,"r":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void horizontalSAT(global uint4* input, global uint4* output, int i, int r, int width) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int pos = x + y * width;

  int c = pow((float)r, (float)i);

  uint4 sum = 0;

  for (int j = 0; j < r; j++) {
    if (x - (j * c) < 0) {
      output[hook(1, pos)] = sum;
      return;
    }
    sum += input[hook(0, pos - (j * c))];
  }

  output[hook(1, pos)] = sum;
}