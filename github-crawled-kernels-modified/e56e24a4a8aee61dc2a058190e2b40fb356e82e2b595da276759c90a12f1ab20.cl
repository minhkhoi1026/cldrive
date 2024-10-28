//{"input":0,"output":1,"slice":2,"slicePlane":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void orthogonalSlicing(read_only image3d_t input, write_only image2d_t output, private int slice, private int slicePlane) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  int4 pos;
  if (slicePlane == 0) {
    pos = (int4)(slice, x, y, 0);
  } else if (slicePlane == 1) {
    pos = (int4)(x, slice, y, 0);
  } else {
    pos = (int4)(x, y, slice, 0);
  }

  int dataType = get_image_channel_data_type(input);
  if (dataType == 0x10DE) {
    float4 value = read_imagef(input, sampler, pos);
    write_imagef(output, (int2)(x, y), value);
  } else if (dataType == 0x10DA || dataType == 0x10DB) {
    uint4 value = read_imageui(input, sampler, pos);
    write_imageui(output, (int2)(x, y), value);
  } else {
    int4 value = read_imagei(input, sampler, pos);
    write_imagei(output, (int2)(x, y), value);
  }
}