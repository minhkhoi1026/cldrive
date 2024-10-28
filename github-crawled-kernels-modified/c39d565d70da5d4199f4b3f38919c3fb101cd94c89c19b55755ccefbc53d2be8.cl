//{"input":0,"mask":1,"maskSize":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void gaussianSmoothing(read_only image3d_t input, constant float* mask, global float* output, private unsigned char maskSize) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const unsigned char halfSize = (maskSize - 1) / 2;

  float sum = 0.0f;
  int dataType = get_image_channel_data_type(input);
  for (int x = -halfSize; x <= halfSize; x++) {
    for (int y = -halfSize; y <= halfSize; y++) {
      for (int z = -halfSize; z <= halfSize; z++) {
        const int4 offset = {x, y, z, 0};
        const unsigned int maskOffset = x + halfSize + (y + halfSize) * maskSize + (z + halfSize) * maskSize * maskSize;
        if (dataType == 0x10DE) {
          sum += mask[hook(1, maskOffset)] * read_imagef(input, sampler, pos + offset).x;
        } else if (dataType == 0x10DA || dataType == 0x10DB) {
          sum += mask[hook(1, maskOffset)] * read_imageui(input, sampler, pos + offset).x;
        } else {
          sum += mask[hook(1, maskOffset)] * read_imagei(input, sampler, pos + offset).x;
        }
      }
    }
  }

  output[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = sum;
}