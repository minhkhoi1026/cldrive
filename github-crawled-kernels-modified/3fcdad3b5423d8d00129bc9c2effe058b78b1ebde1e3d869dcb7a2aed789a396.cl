//{"h":3,"image":0,"target":1,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant float4 rgb2y = {0.299f, 0.587f, 0.114f, 0.0f};

kernel void extract_luma(read_only image2d_t image, global float* target, int w, int h) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  if (pos.x >= 0 && pos.x < w && pos.y >= 0 && pos.y < h) {
    int idx = pos.y * w + pos.x;
    uint4 pixel_col = read_imageui(image, sampler, pos);
    float4 pixel_col_f = convert_float4(pixel_col);

    target[hook(1, idx)] = dot(pixel_col_f, rgb2y);
  }
}