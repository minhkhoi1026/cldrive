//{"left":0,"leftHeight":3,"leftWidth":4,"right":1,"rightHeight":5,"target":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transMatrixMult(global const float* left, global const float* right, global float* target, const int leftHeight, const int leftWidth, const int rightHeight) {
  int row = get_global_id(0);
  int col;
  for (col = 0; col < rightHeight; col++) {
    float sum = 0;
    int n;
    for (n = 0; n < leftWidth; n++) {
      sum += left[hook(0, row * leftWidth + n)] * right[hook(1, leftWidth * col + n)];
    }
    target[hook(2, row * rightHeight + col)] = sum;
  }
}