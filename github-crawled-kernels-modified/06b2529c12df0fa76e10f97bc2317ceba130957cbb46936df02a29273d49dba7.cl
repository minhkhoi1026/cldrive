//{"array_size":3,"image0":0,"image1":1,"result":2,"tmp_buffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
inline void atom_add_float(volatile global float* source, const float operand) {
  union {
    unsigned int intValue;
    float floatValue;
  } newValue;
  union {
    unsigned int intValue;
    float floatValue;
  } prevValue;
  do {
    prevValue.floatValue = *source;
    newValue.floatValue = prevValue.floatValue + operand;
  } while (atom_cmpxchg((volatile global unsigned int*)source, prevValue.intValue, newValue.intValue) != prevValue.intValue);
}

kernel void ssd(read_only image2d_t image0, read_only image2d_t image1, global float* result, int array_size, local float* tmp_buffer) {
  int global_x = (int)get_global_id(0);
  int local_x = (int)get_local_id(0);
  int local_w = (int)get_local_size(0);

  if (global_x < array_size) {
    float sum = 0;
    int width = get_image_width(image0);
    for (int i = 0; i < width; i++) {
      int2 coords = {i, global_x};
      float value0 = read_imagef(image0, sampler, coords).x;
      float value1 = read_imagef(image1, sampler, coords).x;
      float diff = value0 - value1;
      sum += diff * diff;
    }
    tmp_buffer[hook(4, local_x)] = sum;
  }

  barrier(0x01);

  for (int i = local_w >> 1; i > 0; i >>= 1) {
    if ((local_x < i) && (global_x + i < array_size)) {
      tmp_buffer[hook(4, local_x)] += tmp_buffer[hook(4, local_x + i)];
    }

    barrier(0x01);
  }

  if (local_x == 0) {
    atom_add_float(result, tmp_buffer[hook(4, 0)]);
  }
}