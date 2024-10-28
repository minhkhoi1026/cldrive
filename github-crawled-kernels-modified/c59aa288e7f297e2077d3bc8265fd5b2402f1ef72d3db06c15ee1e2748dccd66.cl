//{"image":1,"kernelSize":0,"maxCoord":4,"params":3,"weightMap":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
int2 borderCoord(int2 coord, const int2 maxCoord) {
  coord = convert_int2(abs(coord));
  const int2 minValue = maxCoord * (int2)(2, 2) - coord;
  return minValue + (coord - minValue) * max(min(maxCoord - coord, (int2)(1, 1)), (int2)(0, 0));
}

kernel void krn_weight(const int2 kernelSize, read_only image2d_t image, write_only image2d_t weightMap, const float3 params, const int2 maxCoord)

{
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  if (any(coord >= kernelSize))
    return;
  const float4 srcColor = read_imagef(image, sampler, coord);
  float3 measures = (float3)(1.0f);

  measures.x = fabs(dot(srcColor, (float4)(0.299f, 0.587f, 0.114f, 0.0f)) * -4.0f + dot(read_imagef(image, sampler, borderCoord(coord + (int2)(0, -1), maxCoord)), (float4)(0.299f, 0.587f, 0.114f, 0.0f)) + dot(read_imagef(image, sampler, borderCoord(coord + (int2)(-1, 0), maxCoord)), (float4)(0.299f, 0.587f, 0.114f, 0.0f)) + dot(read_imagef(image, sampler, borderCoord(coord + (int2)(1, 0), maxCoord)), (float4)(0.299f, 0.587f, 0.114f, 0.0f)) + dot(read_imagef(image, sampler, borderCoord(coord + (int2)(0, 1), maxCoord)), (float4)(0.299f, 0.587f, 0.114f, 0.0f)));

  measures.y = fast_length(srcColor.xyz - (float3)(dot(srcColor.xyz, (float3)(0.3333333333f))));

  float8 tmp;
  tmp.s012 = srcColor.xyz - (float3)(0.5f);
  tmp.s456 = -(tmp.s012 * tmp.s012) * (float3)(12.5f);
  measures.z = tmp.s4 * tmp.s5 * tmp.s6;

  measures = pow(measures, params);

  write_imagef(weightMap, coord, (float4)(measures.x * measures.y * measures.z));
}