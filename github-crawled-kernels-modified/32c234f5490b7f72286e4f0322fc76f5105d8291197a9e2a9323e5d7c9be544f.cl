//{"IMAGE_H":5,"IMAGE_W":4,"filter":2,"hlen":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vertical_convolution(const global float* input, global float* output, global float* filter __attribute__((max_constant_size(16384))), int hlen, int IMAGE_W, int IMAGE_H) {
  int gidy = (int)get_global_id(1);
  int gidx = (int)get_global_id(0);

  if (gidy < IMAGE_H && gidx < IMAGE_W) {
    int c, hL, hR;
    if (hlen & 1) {
      c = hlen / 2;
      hL = c;
      hR = c;
    } else {
      c = hlen / 2 - 1;
      hL = c;
      hR = c + 1;
    }
    int jy1 = c - gidy;
    int jy2 = IMAGE_H - 1 - gidy + c;
    float sum = 0.0f;

    for (int jy = 0; jy <= hR + hL; jy++) {
      int idx_y = gidy - c + jy;
      if (jy < jy1)
        idx_y = jy1 - jy - 1;
      if (jy > jy2)
        idx_y = IMAGE_H - (jy - jy2);

      sum += input[hook(0, idx_y * IMAGE_W + gidx)] * filter[hook(2, hlen - 1 - jy)];
    }
    output[hook(1, gidy * IMAGE_W + gidx)] = sum;
  }
}