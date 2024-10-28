//{"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_float(global const float* restrict input, global float* restrict output, const int width) {
  const int column = get_global_id(0) * 4;
  const int row = get_global_id(1);

  const int offset = row * width + column;

  float4 accumulator = (float4)0.0f;
  float4 data0 = vload4(0, input + offset);
  float4 data2 = vload4(0, input + offset + 2);
  float4 data1 = (float4)(data0.s12, data2.s12);

  accumulator += data0 * (30.0f * 0.00390625f);
  accumulator += data1 * (5.0f * 0.00390625f);
  accumulator += data2 * (6.0f * 0.00390625f);

  data0 = vload4(0, input + offset + width);
  data2 = vload4(0, input + offset + width + 2);
  data1 = (float4)(data0.s12, data2.s12);

  accumulator += data0 * (19.0f * 0.00390625f);
  accumulator += data1 * (30.0f * 0.00390625f);
  accumulator += data2 * (9.0f * 0.00390625f);

  data0 = vload4(0, input + offset + width * 2);
  data2 = vload4(0, input + offset + width * 2 + 2);
  data1 = (float4)(data0.s12, data2.s12);

  accumulator += data0 * (15.0f * 0.00390625f);
  accumulator += data1 * (5.0f * 0.00390625f);
  accumulator += data2 * (40.0f * 0.00390625f);

  vstore4(accumulator, 0, output + offset);
}