//{"histogram":2,"inputPipe":0,"totalPixels":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 2;
kernel void consumerKernel(global float* inputPipe, int totalPixels, global int* histogram) {
  int pixelCnt;
  float pixel;

  for (pixelCnt = 0; pixelCnt < totalPixels; pixelCnt++) {
    pixel = inputPipe[hook(0, pixelCnt)];

    histogram[hook(2, (int)pixel)]++;
  }
}