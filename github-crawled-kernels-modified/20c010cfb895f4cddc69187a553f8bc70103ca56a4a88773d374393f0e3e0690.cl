//{"K":5,"centroids":1,"height":4,"input":0,"pixels":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void recomputeCenters(global uchar4* input, global uchar4* centroids, global unsigned int* pixels, unsigned int width, unsigned int height, unsigned int K) {
  unsigned int center = get_global_id(0);

  if (center < K) {
    float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};
    unsigned int num = 0;

    for (unsigned int i = 0; i < width * height; i++) {
      if (pixels[hook(2, i)] == center) {
        sum += convert_float4(input[hook(0, i)]);
        num++;
      }
    }

    uchar4 newCenter = convert_uchar4(sum / convert_float(num));

    centroids[hook(1, center)] = newCenter;
    centroids[hook(1, center)].w = 255;
  }
}