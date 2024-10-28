//{"dst":1,"sharedBlock":3,"smem":4,"src":0,"v":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((always_inline)) float read_imagef_bayer(image2d_t src, sampler_t sampler, int2 coords, int2 size) {
  int maxx = size.x - 1;
  int maxy = size.y - 1;
  coords.x = coords.x < 0 ? 1 : coords.x;
  coords.x = coords.x > maxx ? maxx - 1 : coords.x;
  coords.y = coords.y < 0 ? 1 : coords.y;
  coords.y = coords.y > maxy ? maxy - 1 : coords.y;
  return read_imagef(src, sampler, coords).x;
}

__attribute__((always_inline)) float3 convert_bayer2rgb(read_only image2d_t src, sampler_t sampler, bool x_even, bool y_even) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  int2 size = get_image_dim(src);
 private
  float v[9];

  for (int y = 0; y < 3; ++y) {
    for (int x = 0; x < 3; ++x) {
      int2 coords = gid + (int2)(x - 1, y - 1);
      v[hook(2, mad24(y, 3, x))] = read_imagef_bayer(src, sampler, coords, size);
    }
  }

  float r = v[hook(2, 4)];
  float g = (v[hook(2, 3)] + v[hook(2, 5)] + v[hook(2, 1)] + v[hook(2, 7)]) * 0.25f;
  float b = (v[hook(2, 0)] + v[hook(2, 2)] + v[hook(2, 6)] + v[hook(2, 8)]) * 0.25f;
  float3 out1 = (float3)(r, g, b);

  r = (v[hook(2, 3)] + v[hook(2, 5)]) * 0.5f;
  g = v[hook(2, 4)];
  b = (v[hook(2, 1)] + v[hook(2, 7)]) * 0.5f;
  float3 out2 = (float3)(r, g, b);

  return x_even ? (y_even ? out1.xyz : out2.zyx) : (y_even ? out2.xyz : out1.zyx);
}

__attribute__((always_inline)) void contextToLocalMemory_image2(read_only image2d_t src, sampler_t sampler, int kradx, int krady, local float* sharedBlock, int sharedWidth, int sharedHeight) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  int2 lid = {get_local_id(0), get_local_id(1)};
  int2 lsize = {get_local_size(0), get_local_size(1)};
  int2 size = get_image_dim(src);

  sharedBlock[hook(3, mad24(lid.y + krady, sharedWidth, lid.x + kradx))] = read_imagef(src, sampler, gid).x;

  if (lid.x < kradx) {
    sharedBlock[hook(3, mad24(lid.y + krady, sharedWidth, lid.x))] = read_imagef_bayer(src, sampler, gid + (int2)(-kradx, 0), size);

    sharedBlock[hook(3, mad24(lid.y + krady, sharedWidth, lid.x + lsize.x + kradx))] = read_imagef_bayer(src, sampler, gid + (int2)(lsize.x, 0), size);
  }
  if (lid.y < krady) {
    sharedBlock[hook(3, mad24(lid.y, sharedWidth, lid.x + kradx))] = read_imagef_bayer(src, sampler, gid + (int2)(0, -krady), size);

    sharedBlock[hook(3, mad24(lid.y + lsize.y + krady, sharedWidth, lid.x + kradx))] = read_imagef_bayer(src, sampler, gid + (int2)(0, lsize.y), size);
  }

  if ((lid.x < kradx) && (lid.y < krady)) {
    sharedBlock[hook(3, mad24(lid.y, sharedWidth, lid.x))] = read_imagef_bayer(src, sampler, gid + (int2)(-kradx, -krady), size);

    sharedBlock[hook(3, mad24(lid.y + lsize.y + krady, sharedWidth, lid.x))] = read_imagef_bayer(src, sampler, gid + (int2)(-kradx, lsize.y), size);

    sharedBlock[hook(3, mad24(lid.y, sharedWidth, lid.x + lsize.x + kradx))] = read_imagef_bayer(src, sampler, gid + (int2)(lsize.x, -krady), size);

    sharedBlock[hook(3, mad24(lid.y + lsize.y + krady, sharedWidth, lid.x + lsize.x + kradx))] = read_imagef_bayer(src, sampler, gid + (int2)(lsize.x, lsize.y), size);
  }
}

float3 convert_bayer2rgb_local(local float* smem, int smemWidth, bool x_even, bool y_even) {
  int2 lid = {get_local_id(0), get_local_id(1)};

  float v4 = smem[hook(4, mad24(0 + 1 + lid.y, smemWidth, 0 + 1 + lid.x))];
  float sum0 = smem[hook(4, mad24(0 + 1 + lid.y, smemWidth, -1 + 1 + lid.x))] + smem[hook(4, mad24(0 + 1 + lid.y, smemWidth, 1 + 1 + lid.x))];
  float sum1 = smem[hook(4, mad24(-1 + 1 + lid.y, smemWidth, 0 + 1 + lid.x))] + smem[hook(4, mad24(1 + 1 + lid.y, smemWidth, 0 + 1 + lid.x))];
  float sum2 = smem[hook(4, mad24(-1 + 1 + lid.y, smemWidth, -1 + 1 + lid.x))] + smem[hook(4, mad24(-1 + 1 + lid.y, smemWidth, 1 + 1 + lid.x))];
  float sum3 = smem[hook(4, mad24(1 + 1 + lid.y, smemWidth, -1 + 1 + lid.x))] + smem[hook(4, mad24(1 + 1 + lid.y, smemWidth, 1 + 1 + lid.x))];

  float r = v4;
  float g = (sum0 + sum1) * 0.25f;
  float b = (sum2 + sum3) * 0.25f;
  float3 out1 = (float3)(r, g, b);

  r = (sum0)*0.5f;
  g = v4;
  b = (sum1)*0.5f;
  float3 out2 = (float3)(r, g, b);

  return x_even ? (y_even ? out1.xyz : out2.zyx) : (y_even ? out2.xyz : out1.zyx);
}

constant float3 greyscale = {0.2989f, 0.5870f, 0.1140f};
constant sampler_t sampler = 0 | 0x10 | 4;
__attribute__((always_inline)) bool opTrue(bool o) {
  return o;
}
__attribute__((always_inline)) bool opFalse(bool o) {
  return !o;
}
kernel void convert_bg2rgb(read_only image2d_t src, write_only image2d_t dst) {
  int2 gid = (int2){get_global_id(0), get_global_id(1)};
  int2 size = get_image_dim(src);
  if (any(gid >= size))
    return;
  bool x_odd = gid.x & 0x01;
  bool y_odd = gid.y & 0x01;
  float3 rgb = convert_bayer2rgb(src, sampler, opTrue(x_odd), opTrue(y_odd));
  if (false) {
    float gray = dot(rgb, greyscale);
    write_imagef(dst, gid, (float4)(gray));
  } else {
    write_imagef(dst, gid, (float4)(rgb, 1.0f));
  }
}