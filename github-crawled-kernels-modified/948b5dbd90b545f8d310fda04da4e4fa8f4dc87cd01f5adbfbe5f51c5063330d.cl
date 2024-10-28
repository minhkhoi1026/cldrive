//{"dst":2,"orig":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samin = 1 | 2 | 0x20;
float Hue2RGB(float v1, float v2, float vH) {
  if (vH < 0)
    vH += 1;
  if (vH > 1)
    vH -= 1;
  if (6.0 * vH < 1)
    return v1 + (v2 - v1) * 6.0 * vH;
  if (2.0 * vH < 1)
    return v2;
  if (3.0 * vH < 2)
    return v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0;
  return (v1);
}
float3 hsl2rgb(float3 hsl) {
  float H = hsl.x;
  float S = hsl.y;
  float L = hsl.z;
  float R, G, B;
  float var_1, var_2;
  if (S == 0) {
    R = L;
    G = L;
    B = L;
  } else {
    if (L < 0.5)
      var_2 = L * (1 + S);
    else
      var_2 = (L + S) - (S * L);

    var_1 = 2.0 * L - var_2;

    R = Hue2RGB(var_1, var_2, H + (1.0 / 3.0));
    G = Hue2RGB(var_1, var_2, H);
    B = Hue2RGB(var_1, var_2, H - (1.0 / 3.0));
  }
  return (float3)(R, G, B);
}

constant float4 colors[] = {(float4)(1, 0, 0, 1), (float4)(1, 1, 0, 1), (float4)(0, 0, 1, 1), (float4)(1, 1, 0, 1), (float4)(1, 0, 1, 1), (float4)(0, 1, 1, 1), (float4)(1, 1, 1, 1), (float4)(1, 0.5, 0.5, 1), (float4)(0.5, 1, 1, 1)};
constant int color_size = 9;

constant float pi = 3.1415927f;
kernel void filter(read_only image2d_t src, read_only image2d_t orig, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float2 cdsf = (float2)(get_global_id(0), get_global_id(1)) / (float2)(get_global_size(0) - 1, get_global_size(1) - 1);
  float4 a = read_imagef(src, samin, cdsf) * 1000;
  float4 o = read_imagef(orig, samin, cdsf);

  float3 hsl = (float3)(atan2(a.x, a.y) / (2 * pi) + 1, 0.8f, 0.3f);
  float3 rgb = hsl2rgb(hsl);
  float alpha = clamp(length(a.xy) / 10, 0.0f, 0.8f);

  float4 out;
  out = (float4)(rgb * alpha + o.xyz * (1 - alpha), 1);
  write_imagef(dst, cds, out);
}