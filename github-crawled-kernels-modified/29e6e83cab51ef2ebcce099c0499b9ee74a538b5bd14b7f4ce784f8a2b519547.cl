//{"image":0,"logLum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void computeLogLum(read_only image2d_t image, global float* logLum) {
  int2 pos;
  uint4 pixel;
  float lum;
  for (pos.y = get_global_id(1); pos.y < 128; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < 16; pos.x += get_global_size(0)) {
      pixel = read_imageui(image, sampler, pos);
      lum = GL_to_CL(pixel.x) * 0.2126 + GL_to_CL(pixel.y) * 0.7152 + GL_to_CL(pixel.z) * 0.0722;
      logLum[hook(1, pos.x + pos.y * 16)] = log(lum + 0.000001);
    }
  }
}