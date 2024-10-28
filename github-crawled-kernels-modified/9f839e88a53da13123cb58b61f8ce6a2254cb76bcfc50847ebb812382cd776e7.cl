//{"IMAGE_H":5,"IMAGE_W":4,"filter":2,"hlen":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void horizontal_convolution(const global float* input, global float* output, global float* filter __attribute__((max_constant_size(16384))), int hlen, int IMAGE_W, int IMAGE_H) {
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
    int jx1 = c - gidx;
    int jx2 = IMAGE_W - 1 - gidx + c;
    float sum = 0.0f;

    for (int jx = 0; jx <= hR + hL; jx++) {
      int idx_x = gidx - c + jx;
      if (jx < jx1)
        idx_x = jx1 - jx - 1;
      if (jx > jx2)
        idx_x = IMAGE_W - (jx - jx2);

      sum += input[hook(0, gidy * IMAGE_W + idx_x)] * filter[hook(2, hlen - 1 - jx)];
    }
    output[hook(1, gidy * IMAGE_W + gidx)] = sum;
  }
}