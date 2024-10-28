//{"H":3,"W":2,"image_matrix":0,"output":1,"prewittX":4,"prewittY":5,"range":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void edge_detection(global float* image_matrix, global float* output, int W, int H, global float* prewittX, global float* prewittY, int range) {
  int row = get_global_id(1);
  int col = get_global_id(0);

  float gx = 0.0f;
  float gy = 0.0f;
  float G = 0.0f;

  for (int i = row - (range); i < row + (range + 1); i++) {
    for (int j = col - (range * 3); j < col + (range + 1) * 3; j += 3) {
      if (!(i < 0) && !(i > H) && !(j < 0) && !(j > W * 3)) {
        gx += image_matrix[hook(0, j + i * W * 3)] * prewittX[hook(4, (row - i + range) * 3 + (col - j) / 3 + range)];

        gy += image_matrix[hook(0, j + i * W * 3)] * prewittY[hook(5, (row - i + range) * 3 + (col - j) / 3 + range)];
      }
    }
  }
  G = sqrt((gx * gx) + (gy * gy));

  output[hook(1, row * W * 3 + col)] = G;
}