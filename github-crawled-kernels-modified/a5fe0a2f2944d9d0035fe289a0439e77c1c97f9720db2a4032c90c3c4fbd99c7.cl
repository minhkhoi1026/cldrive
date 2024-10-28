//{"channels":4,"kernel_h":3,"kernel_w":2,"outputs":5,"swizzleFactor":6,"weightIn":0,"weightOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyWeightsSwizzled_float(global float* weightIn, global float* weightOut, const int kernel_w, const int kernel_h, const int channels, const int outputs, const int swizzleFactor) {
  unsigned int sX = get_global_id(0);

  int outputSublayer = channels / swizzleFactor;
  int outputSublayerIndex = channels % swizzleFactor;

  int filter = sX / (kernel_w * kernel_h * channels);
  int kernel_X = sX % kernel_w;
  int kernel_Y = (sX / kernel_w) % kernel_h;
  int kernel_C = (sX / (kernel_w * kernel_h)) % channels;

  int FP = filter / swizzleFactor;
  int F1 = filter % swizzleFactor;

  weightOut[hook(1, FP * (kernel_w * kernel_h * channels * swizzleFactor) + kernel_C * (kernel_w * kernel_h * swizzleFactor) + kernel_Y * (kernel_w * swizzleFactor) + kernel_X * swizzleFactor + F1)] = weightIn[hook(0, filter * (kernel_w * kernel_h * channels) + kernel_C * (kernel_w * kernel_h) + kernel_Y * kernel_w + kernel_X)];
}