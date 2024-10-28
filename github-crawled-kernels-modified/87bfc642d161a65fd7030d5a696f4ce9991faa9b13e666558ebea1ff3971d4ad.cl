//{"convInfo":0,"inptr0":3,"inptr1":4,"inptr2":5,"input_buf":1,"outptr":6,"output_buf":2,"range_limit":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef unsigned char JSAMPLE;
struct ConverterInfo {
  int Cr_r_tab[255 + 1];
  int Cb_b_tab[255 + 1];
  int Cr_g_tab[255 + 1];
  int Cb_g_tab[255 + 1];
  JSAMPLE sample_range_limit[(5 * (255 + 1) + 128)];
};

kernel void convert(global struct ConverterInfo* convInfo, global JSAMPLE* input_buf, global JSAMPLE* output_buf) {
  int y, cb, cr;
  global JSAMPLE* inptr0;
  global JSAMPLE* inptr1;
  global JSAMPLE* inptr2;
  global JSAMPLE* outptr;
  global JSAMPLE* range_limit = convInfo->sample_range_limit + (255 + 1);
  global int* Crrtab = convInfo->Cr_r_tab;
  global int* Cbbtab = convInfo->Cb_b_tab;
  global int* Crgtab = convInfo->Cr_g_tab;
  global int* Cbgtab = convInfo->Cb_g_tab;
  int yoffset = get_global_id(0);
  int col = get_global_id(1);
  int width = get_global_size(1);
  int height = get_global_size(0);
  int component_image_size = width * height;
  float3 outputv1 = (float3)(1.0f, 0.0f, 1.40200f);
  float3 outputv2 = (float3)(1.0f, -0.34414, -0.71414);
  float3 outputv3 = (float3)(1.0f, 1.77200f, 0.0f);
  float3 components;

  inptr0 = input_buf + yoffset * width + col;
  inptr1 = inptr0 + component_image_size;
  inptr2 = inptr1 + component_image_size;

  components.x = convert_float((inptr0[hook(3, 0)]) & 0xff);
  components.y = convert_float(((inptr1[hook(4, 0)]) & 0xff) - 128);
  components.z = convert_float(((inptr2[hook(5, 0)]) & 0xff) - 128);
  outptr = output_buf + (yoffset * width + col) * 3;
  outptr[hook(6, 0)] = range_limit[hook(7, convert_int(dot(components, outputv1)))];
  outptr[hook(6, 1)] = range_limit[hook(7, convert_int(dot(components, outputv2)))];
  outptr[hook(6, 2)] = range_limit[hook(7, convert_int(dot(components, outputv3)))];
}