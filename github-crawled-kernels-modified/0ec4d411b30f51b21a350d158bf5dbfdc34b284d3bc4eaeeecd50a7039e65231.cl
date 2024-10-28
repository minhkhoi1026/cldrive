//{"input":0,"output":1,"table":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_gauss(read_only image2d_t input, write_only image2d_t output, global float* table) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float4 in1;
  int i, j;
  int index;
  float4 out1 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 out2 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (i = 0; i < (2 * 5 + 1) + 1; i++)
    for (j = 0; j < (2 * 5 + 1) + 3; j++) {
      in1 = read_imagef(input, sampler, (int2)(4 * x - 5 + j, 2 * y - 5 + i));

      if (i < (2 * 5 + 1)) {
        index = i * (2 * 5 + 1) + j;
        out1.x += (j < (2 * 5 + 1) ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out1.y += ((j < (2 * 5 + 1) + 1) && j > 0 ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out1.z += ((j < (2 * 5 + 1) + 2) && j > 1 ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out1.w += (j > 2 ? table[hook(2, index)] * in1.x : 0.0f);
      }

      if (i > 0) {
        index = (i - 1) * (2 * 5 + 1) + j;
        out2.x += (j < (2 * 5 + 1) ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out2.y += ((j < (2 * 5 + 1) + 1) && j > 0 ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out2.z += ((j < (2 * 5 + 1) + 2) && j > 1 ? table[hook(2, index)] * in1.x : 0.0f);
        index -= 1;
        out2.w += (j > 2 ? table[hook(2, index)] * in1.x : 0.0f);
      }
    }

  write_imagef(output, (int2)(x, 2 * y), out1);
  write_imagef(output, (int2)(x, 2 * y + 1), out2);
}