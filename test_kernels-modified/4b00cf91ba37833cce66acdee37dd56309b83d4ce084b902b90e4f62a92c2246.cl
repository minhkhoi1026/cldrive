//{"channels":2,"count":0,"dst":6,"height":3,"reorgStride":5,"src":1,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reorg(const int count, global const float* src, const int channels, const int height, const int width, const int reorgStride, global float* dst) {
  for (int index = get_global_id(0); index < count; index += get_global_size(0)) {
    int k = index / (height * width);
    int j = (index - (k * height * width)) / width;
    int i = (index - (k * height * width)) % width;
    int out_c = channels / (reorgStride * reorgStride);
    int c2 = k % out_c;
    int offset = k / out_c;
    int w2 = i * reorgStride + offset % reorgStride;
    int h2 = j * reorgStride + offset / reorgStride;
    int in_index = w2 + width * reorgStride * (h2 + height * reorgStride * c2);
    dst[hook(6, index)] = src[hook(1, in_index)];
  }
}