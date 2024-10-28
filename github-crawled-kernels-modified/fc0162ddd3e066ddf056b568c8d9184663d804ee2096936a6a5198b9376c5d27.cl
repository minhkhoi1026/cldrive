//{"blurkernel":3,"blursize":2,"input_image":0,"output_image":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 blurred_value(int2 coord, read_only image2d_t input_data, global int* blursize) {
  const sampler_t sampler = 0 | 4 | 0x10;

  int blur_size = *blursize;
  int blur_size_squared = (2 * blur_size) * (2 * blur_size);
  float sum_x = 0.0f;
  float sum_y = 0.0f;
  float sum_z = 0.0f;
  float sum_a = 0.0f;

  int2 s = get_image_dim(input_data);

  for (int a = -blur_size; a <= blur_size; a++) {
    for (int b = -blur_size; b <= blur_size; b++) {
      int2 coords = (int2)(coord.x + a, coord.y + b);
      if (coords.x < 0)
        coords.x = 0;
      else if (coords.x >= s.x)
        coords.x = s.x - 1;
      if (coords.y < 0)
        coords.y = 0;
      else if (coords.y >= s.y)
        coords.y = s.y - 1;
      sum_x += read_imagef(input_data, sampler, coords).x;
      sum_y += read_imagef(input_data, sampler, coords).y;
      sum_z += read_imagef(input_data, sampler, coords).z;
      sum_a += read_imagef(input_data, sampler, coords).w;
    }
  }

  float4 out;
  out.x = sum_x / blur_size_squared;
  out.y = sum_y / blur_size_squared;
  out.z = sum_z / blur_size_squared;
  out.w = sum_a / blur_size_squared;

  return out;
}

float4 gaussianBlur(int2 coord, read_only image2d_t input_data, global int* blursize, read_only image2d_t blurkernel) {
  const sampler_t sampler = 0 | 4 | 0x10;

  int blur_size = *blursize;
  float4 float3;
  float multiplier = 0.0f;
  float sum_x = 0.0f;
  float sum_y = 0.0f;
  float sum_z = 0.0f;
  float sum_w = 0.0f;
  int2 s = get_image_dim(input_data);

  for (int i = -blur_size / 2; i <= blur_size / 2; i++) {
    for (int j = -blur_size / 2; j <= blur_size / 2; j++) {
      int2 kernelcoords = (int2)(i + (blur_size / 2), j + (blur_size / 2));
      int2 coords = (int2)(coord.x + i, coord.y + j);

      if (coords.x < 0)
        coords.x = s.x - abs(i);
      else if (coords.x >= s.x)
        coords.x = abs(i);
      if (coords.y < 0)
        coords.y = s.y - abs(j);
      else if (coords.y >= s.y)
        coords.y = abs(j);

      float3 = read_imagef(input_data, sampler, coords);
      multiplier = read_imagef(blurkernel, sampler, kernelcoords).x;
      sum_x += float3.x * multiplier;
      sum_y += float3.y * multiplier;
      sum_z += float3.z * multiplier;
      sum_w += float3.w * multiplier;
    }
  }

  float4 out;
  out.x = sum_x;
  out.y = sum_y;
  out.z = sum_z;
  out.w = sum_w;
  return out;
}

kernel void blur(read_only image2d_t input_image, write_only image2d_t output_image, global int* blursize, read_only image2d_t blurkernel) {
  const sampler_t sampler = 0 | 4 | 0x10;
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);

  float4 outvalue = gaussianBlur(coord, input_image, blursize, blurkernel);

  write_imagef(output_image, coord, outvalue);
}