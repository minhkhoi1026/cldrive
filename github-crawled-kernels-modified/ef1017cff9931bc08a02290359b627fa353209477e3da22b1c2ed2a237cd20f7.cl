//{"input":0,"output":1,"pixel":6,"removeChannel":4,"removeChannelV":2,"result":5,"reverse":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void channelConvert2D(read_only image2d_t input, write_only image2d_t output, private uchar4 removeChannelV, private char reverse) {
  int offset = 0;
  int sign = 1;
  if (reverse == 1) {
    offset = 3 - (removeChannelV.x + removeChannelV.y + removeChannelV.z + removeChannelV.w);
    sign = -1;
  }
  uchar* removeChannel = (uchar*)&removeChannelV;
  const int2 pos = {get_global_id(0), get_global_id(1)};
  int type = get_image_channel_data_type(input);
  int writePos = 0;
  if (type == 0x10DE) {
    float4 tmp = read_imagef(input, sampler, pos);
    float* pixel = (float*)&tmp;
    float result[4];
    for (int i = 0; i < 4; ++i) {
      if (removeChannel[hook(4, i)] == 0) {
        result[hook(5, writePos * sign + offset)] = pixel[hook(6, i)];
        ++writePos;
      }
    }

    write_imagef(output, pos, (float4)(result[hook(5, 0)], result[hook(5, 1)], result[hook(5, 2)], result[hook(5, 3)]));
  } else if (type == 0x10DA || type == 0x10DB) {
    uint4 tmp = read_imageui(input, sampler, pos);
    unsigned int* pixel = (unsigned int*)&tmp;
    unsigned int result[4];
    for (int i = 0; i < 4; ++i) {
      if (removeChannel[hook(4, i)] == 0) {
        result[hook(5, writePos * sign + offset)] = pixel[hook(6, i)];
        ++writePos;
      }
    }

    write_imageui(output, pos, (uint4)(result[hook(5, 0)], result[hook(5, 1)], result[hook(5, 2)], result[hook(5, 3)]));
  } else {
    int4 tmp = read_imagei(input, sampler, pos);
    int* pixel = (int*)&tmp;
    int result[4];
    for (int i = 0; i < 4; ++i) {
      if (removeChannel[hook(4, i)] == 0) {
        result[hook(5, writePos * sign + offset)] = pixel[hook(6, i)];
        ++writePos;
      }
    }

    write_imagei(output, pos, (int4)(result[hook(5, 0)], result[hook(5, 1)], result[hook(5, 2)], result[hook(5, 3)]));
  }
}