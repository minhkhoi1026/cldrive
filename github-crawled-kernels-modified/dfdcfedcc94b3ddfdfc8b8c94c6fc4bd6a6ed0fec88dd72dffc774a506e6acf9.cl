//{"input":0,"inputWidth":3,"mask":1,"maskWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussianblur(const global float* const input, constant float* const mask, global float* const output, const int inputWidth, const int maskWidth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float sum = 0;
  for (int r = 0; r < maskWidth; r++) {
    const int idxIntmp = (y + r) * inputWidth + x;

    for (int c = 0; c < maskWidth; c++) {
      sum += ((mask[hook(1, (r * maskWidth) + c)]) / 9) * input[hook(0, idxIntmp + c)];
    }
  }

  output[hook(2, y * get_global_size(0) + x)] = sum;
}