//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SobelDetector(global uchar4* input, global uchar4* output) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  unsigned int width = get_global_size(0);
  unsigned int height = get_global_size(1);

  float4 Gx = (float4)(0);
  float4 Gy = (float4)(0);
  if (x >= 1 && x < (width - 1) && y >= 1 && y < height - 1) {
    float4 i00 = convert_float4(input[hook(0, (x - 1) + (y - 1) * width)]);
    float4 i10 = convert_float4(input[hook(0, x + (y - 1) * width)]);
    float4 i20 = convert_float4(input[hook(0, (x + 1) + (y - 1) * width)]);
    float4 i01 = convert_float4(input[hook(0, (x - 1) + y * width)]);
    float4 i11 = convert_float4(input[hook(0, x + y * width)]);
    float4 i21 = convert_float4(input[hook(0, (x + 1) + y * width)]);
    float4 i02 = convert_float4(input[hook(0, (x - 1) + (y + 1) * width)]);
    float4 i12 = convert_float4(input[hook(0, x + (y + 1) * width)]);
    float4 i22 = convert_float4(input[hook(0, (x + 1) + (y + 1) * width)]);

    Gx = i00 + (float4)(2) * i10 + i20 - i02 - (float4)(2) * i12 - i22;

    Gy = i00 - i20 + (float4)(2) * i01 - (float4)(2) * i21 + i02 - i22;

    output[hook(1, x + y * width)] = convert_uchar4(hypot(Gx, Gy) / (float4)(2));
  }
}