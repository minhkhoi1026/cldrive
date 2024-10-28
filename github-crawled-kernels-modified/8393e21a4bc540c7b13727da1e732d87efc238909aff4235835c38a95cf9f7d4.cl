//{"d_input":1,"d_output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t m_sampler = 0 | 8 | 0x20;
kernel void imgzoom(global uchar4* restrict d_output, read_only image2d_t d_input) {
  const int col = get_global_id(0);
  const int row = get_global_id(1);
  const int2 dim = get_image_dim(d_input);

  if (col < dim.x && row < dim.y) {
    float2 coords00 = (float2)(col + 0.25f, row + 0.25f);
    float2 coords01 = (float2)(col + 0.75f, row + 0.25f);
    float2 coords10 = (float2)(col + 0.25f, row + 0.75f);
    float2 coords11 = (float2)(col + 0.75f, row + 0.75f);

    const float4 px00 = read_imagef(d_input, m_sampler, coords00);
    const float4 px01 = read_imagef(d_input, m_sampler, coords01);
    const float4 px10 = read_imagef(d_input, m_sampler, coords10);
    const float4 px11 = read_imagef(d_input, m_sampler, coords11);

    d_output[hook(0, (2 * row + 0) * 2 * dim.x + (2 * col + 0))] = convert_uchar4(px00 * 255);
    d_output[hook(0, (2 * row + 0) * 2 * dim.x + (2 * col + 1))] = convert_uchar4(px01 * 255);
    d_output[hook(0, (2 * row + 1) * 2 * dim.x + (2 * col + 0))] = convert_uchar4(px10 * 255);
    d_output[hook(0, (2 * row + 1) * 2 * dim.x + (2 * col + 1))] = convert_uchar4(px11 * 255);
  }
}