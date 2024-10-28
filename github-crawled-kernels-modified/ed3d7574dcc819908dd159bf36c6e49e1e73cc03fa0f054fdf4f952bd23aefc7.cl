//{"left":0,"leftWidth":3,"right":1,"rightHeight":4,"target":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transExpandMatrixMult(global const float* left, global const float* right, global float* target, const int leftWidth, const int rightHeight) {
  int leftRow = get_global_id(0);

  int rightRow;
  for (rightRow = 0; rightRow < rightHeight; rightRow++) {
    float sum = 0;
    int n;
    for (n = 0; n < leftWidth; n++) {
      sum += left[hook(0, leftRow * leftWidth + n)] * right[hook(1, rightRow * leftWidth + n)];
    }
    target[hook(2, leftRow * rightHeight + rightRow)] = sum;
  }
}