//{"activation":6,"bH":10,"bW":9,"bias":5,"biases":0,"gFilter":2,"gInputImage":1,"gOutputImage":3,"lFilter":4,"numI":8,"numO":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv2d1x1(const global float* biases, const global float* gInputImage, const global float* gFilter, global float* gOutputImage, local float* lFilter, int bias, int activation, int numO, int numI, int bW, int bH) {
  const int filter_idx = get_global_id(2);
  int inputindex = 0;
  int outputindex = 0;
  int widthXheight = bW * bH;
  float out = 0.0f;
  const int inImageOffset = bW * get_global_id(1) + get_global_id(0);

  barrier(0x01);
  for (int i = get_local_id(1) * get_local_size(0) + get_local_id(0); i < numI; i += get_local_size(0) * get_local_size(1))
    lFilter[hook(4, i)] = gFilter[hook(2, filter_idx * numI + i)];
  barrier(0x01);

  if (get_global_id(0) >= bW || get_global_id(1) >= bH)
    return;

  for (inputindex = 0; inputindex < numI; inputindex++) {
    out += gInputImage[hook(1, inputindex * widthXheight + inImageOffset)] * lFilter[hook(4, inputindex)];
  }

  if (bias) {
    out += biases[hook(0, filter_idx)];
  }

  if (activation) {
    gOutputImage[hook(3, filter_idx * widthXheight + inImageOffset)] = clamp(out, 0.0f, 0x1.fffffep127f);
  } else {
    gOutputImage[hook(3, filter_idx * widthXheight + inImageOffset)] = out;
  }
}