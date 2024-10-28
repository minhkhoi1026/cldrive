//{"count":3,"global_size_dim0":0,"global_size_dim1":1,"input_ptr":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void ArgImageToBuffer(private const int global_size_dim0, private const int global_size_dim1, global float* output, private const int count, read_only image2d_t input_ptr) {
  int image_width_idx = get_global_id(0);
  int image_height_idx = get_global_id(1);

  if (image_width_idx >= global_size_dim0 || image_height_idx >= global_size_dim1) {
    return;
  };

  const int buffer_4_offset = image_width_idx << 2;

  int2 coord = (int2)(image_width_idx, image_height_idx);
  float4 values = read_imagef(input_ptr, SAMPLER, coord);
  const int remain = count - buffer_4_offset;
  if (remain < 4) {
    switch (remain) {
      case 3:
        output[hook(2, buffer_4_offset + 2)] = values.s2;
      case 2:
        output[hook(2, buffer_4_offset + 1)] = values.s1;
      case 1:
        output[hook(2, buffer_4_offset)] = values.s0;
    }
  } else {
    vstore4(values, 0, output + buffer_4_offset);
  }

  if (remain >= 4) {
    vstore4(values, 0, output + buffer_4_offset);
  } else if (remain == 3) {
    int offset = buffer_4_offset;
    output[hook(2, offset)] = values.x;
    offset++;
    output[hook(2, offset)] = values.y;
    offset++;
    output[hook(2, offset)] = values.z;
  } else if (remain == 2) {
    int offset = buffer_4_offset;
    output[hook(2, offset)] = values.x;
    offset++;
    output[hook(2, offset)] = values.y;
  } else if (remain == 1) {
    int offset = buffer_4_offset;
    output[hook(2, offset)] = values.x;
  }
}