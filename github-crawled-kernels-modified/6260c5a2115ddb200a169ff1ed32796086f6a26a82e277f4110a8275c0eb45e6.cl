//{"FILTER_SIZE":3,"IMAGE_H":5,"IMAGE_W":4,"filter":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void horizontal_convolution(const global float* input, global float* output, constant float* filter __attribute__((max_constant_size(16384))), int FILTER_SIZE, int IMAGE_W, int IMAGE_H) {
  int gid1 = (int)get_global_id(1);
  int gid0 = (int)get_global_id(0);

  int HALF_FILTER_SIZE = (FILTER_SIZE % 2 == 1 ? (FILTER_SIZE) / 2 : (FILTER_SIZE + 1) / 2);

  if (gid1 < IMAGE_H && gid0 < IMAGE_W) {
    int pos = gid1 * IMAGE_W + gid0;
    int fIndex = 0;
    float sum = 0.0f;
    int c = 0;
    int newpos = 0;
    int debug = 0;

    for (c = -HALF_FILTER_SIZE; c < FILTER_SIZE - HALF_FILTER_SIZE; c++) {
      newpos = pos + c;
      if (gid0 + c < 0) {
        newpos = pos - 2 * gid0 - c - 1;
      }

      else if (gid0 + c > IMAGE_W - 1) {
        newpos = (gid1 + 2) * IMAGE_W - gid0 - c - 1;
      }
      sum += input[hook(0, newpos)] * filter[hook(2, fIndex)];

      fIndex += 1;
    }

    output[hook(1, pos)] = sum;
  }
}