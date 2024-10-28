//{"cols":2,"data":0,"out":3,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hysteresis(global unsigned char* data, int rows, int cols, global unsigned char* out) {
  float lowThresh = 10;
  float highThresh = 70;

  int row = get_global_id(0);
  int col = get_global_id(1);
  int pos = row * cols + col;

  const unsigned char EDGE = 255;

  unsigned char magnitude = data[hook(0, pos)];

  if (magnitude >= highThresh)
    out[hook(3, pos)] = EDGE;
  else if (magnitude <= lowThresh)
    out[hook(3, pos)] = 0;
  else {
    float med = (highThresh + lowThresh) / 2;

    if (magnitude >= med)
      out[hook(3, pos)] = EDGE;
    else
      out[hook(3, pos)] = 0;
  }
}