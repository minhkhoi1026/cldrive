//{"input":1,"n":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpuStress(unsigned int n, const global float4* input, global float4* output) {
  size_t gid = get_global_id(0);

  for (unsigned int i = 0; i < 64; i++) {
    float4 tmpValue1, tmpValue2, tmpValue3, tmpValue4;
    float4 tmp2Value1, tmp2Value2, tmp2Value3, tmp2Value4;

    float4 inValue1 = input[hook(1, gid * 4)];
    float4 inValue2 = input[hook(1, gid * 4 + 1)];
    float4 inValue3 = input[hook(1, gid * 4 + 2)];
    float4 inValue4 = input[hook(1, gid * 4 + 3)];

    for (unsigned int j = 0; j < 64; j++) {
      tmpValue1 = mad(inValue1, -inValue2, inValue3);
      tmpValue2 = mad(inValue2, inValue3, inValue4);
      tmpValue3 = mad(inValue3, -inValue4, inValue1);
      tmpValue4 = mad(inValue4, inValue1, inValue2);

      tmp2Value1 = mad(tmpValue1, tmpValue2, tmpValue3);
      tmp2Value2 = mad(tmpValue2, tmpValue3, tmpValue4);
      tmp2Value3 = mad(tmpValue3, tmpValue4, tmpValue1);
      tmp2Value4 = mad(tmpValue4, tmpValue1, tmpValue2);

      tmpValue1 = mad(tmp2Value1, -tmp2Value2, tmp2Value3);
      tmpValue2 = mad(tmp2Value2, tmp2Value3, -tmp2Value4);
      tmpValue3 = mad(tmp2Value3, -tmp2Value4, tmp2Value1);
      tmpValue4 = mad(tmp2Value4, tmp2Value1, -tmp2Value2);

      inValue1 = __builtin_astype(((__builtin_astype((tmpValue1), uint4) & (0xc7ffffffU)) | 0x40000000U), float4);
      inValue2 = __builtin_astype(((__builtin_astype((tmpValue2), uint4) & (0xc7ffffffU)) | 0x40000000U), float4);
      inValue3 = __builtin_astype(((__builtin_astype((tmpValue3), uint4) & (0xc7ffffffU)) | 0x40000000U), float4);
      inValue4 = __builtin_astype(((__builtin_astype((tmpValue4), uint4) & (0xc7ffffffU)) | 0x40000000U), float4);
    }

    output[hook(2, gid * 4)] = inValue1;
    output[hook(2, gid * 4 + 1)] = inValue2;
    output[hook(2, gid * 4 + 2)] = inValue3;
    output[hook(2, gid * 4 + 3)] = inValue4;
    gid += get_global_size(0);
  }
}