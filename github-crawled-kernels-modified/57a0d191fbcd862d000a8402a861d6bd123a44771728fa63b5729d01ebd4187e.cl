//{"(global_palette + global_offsets[4 * get_global_id(2) + 2] / 4)":7,"endpoint_planes":2,"global_offsets":1,"global_out":4,"global_palette":0,"indices":3,"out":8,"palette":6,"planes":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int NumBlocks() {
  return get_global_size(0) * get_global_size(1);
}

unsigned int ThreadIdx() {
  return get_global_id(1) * get_global_size(0) + get_global_id(0);
}

int Get(const global char* planes, unsigned int offset) {
  const unsigned int idx = NumBlocks() * offset + ThreadIdx();
  return (int)(planes[hook(5, idx)]);
}

int GetY(const global char* planes, unsigned int endpoint_idx) {
  return Get(planes, endpoint_idx);
}

int GetCo(const global char* planes, unsigned int endpoint_idx) {
  return Get(planes, 2 + 2 * endpoint_idx);
}

int GetCg(const global char* planes, unsigned int endpoint_idx) {
  return Get(planes, 2 + 2 * endpoint_idx + 1);
}

int4 YCoCgToRGB(int4 in) {
  int4 out;
  int t = in.x - (in.z / 2);
  out.y = in.z + t;
  out.z = (t - in.y) / 2;
  out.x = out.z + in.y;
  return out;
}

ushort GetPixel(const global char* planes, unsigned int endpoint_idx) {
  int y = GetY(planes, endpoint_idx);
  int co = GetCo(planes, endpoint_idx);
  int cg = GetCg(planes, endpoint_idx);

  int4 rgb = YCoCgToRGB((int4)(y, co, cg, 0));

  ushort pixel = 0;
  pixel |= (rgb.x << 11);
  pixel |= (rgb.y << 5);
  pixel |= rgb.z;

  return pixel;
}

kernel void assemble_rgb(const global unsigned int* global_palette, const constant unsigned int* global_offsets, const global char* endpoint_planes, const global int* indices, global uchar* global_out) {
  const unsigned int global_offset = NumBlocks() * 6 * get_global_id(2);

  int4 palette[4];

  palette[hook(6, 0)].x = GetY(endpoint_planes + global_offset, 0);
  palette[hook(6, 0)].y = GetCo(endpoint_planes + global_offset, 0);
  palette[hook(6, 0)].z = GetCg(endpoint_planes + global_offset, 0);
  palette[hook(6, 0)] = YCoCgToRGB(palette[hook(6, 0)]);

  palette[hook(6, 1)].x = GetY(endpoint_planes + global_offset, 1);
  palette[hook(6, 1)].y = GetCo(endpoint_planes + global_offset, 1);
  palette[hook(6, 1)].z = GetCg(endpoint_planes + global_offset, 1);
  palette[hook(6, 1)] = YCoCgToRGB(palette[hook(6, 1)]);

  palette[hook(6, 0)].x = (palette[hook(6, 0)].x << 3) | (palette[hook(6, 0)].x >> 2);
  palette[hook(6, 0)].y = (palette[hook(6, 0)].y << 2) | (palette[hook(6, 0)].y >> 4);
  palette[hook(6, 0)].z = (palette[hook(6, 0)].z << 3) | (palette[hook(6, 0)].z >> 2);

  palette[hook(6, 1)].x = (palette[hook(6, 1)].x << 3) | (palette[hook(6, 1)].x >> 2);
  palette[hook(6, 1)].y = (palette[hook(6, 1)].y << 2) | (palette[hook(6, 1)].y >> 4);
  palette[hook(6, 1)].z = (palette[hook(6, 1)].z << 3) | (palette[hook(6, 1)].z >> 2);

  palette[hook(6, 2)] = (2 * palette[hook(6, 0)] + palette[hook(6, 1)]) / 3;
  palette[hook(6, 3)] = (palette[hook(6, 0)] + 2 * palette[hook(6, 1)]) / 3;

  const unsigned int plt_idx = indices[hook(3, get_global_id(2) * NumBlocks() + ThreadIdx())];
  unsigned int idx = (global_palette + global_offsets[hook(1, 4 * get_global_id(2) + 2)] / 4)[hook(7, plt_idx)];

  global uchar* out = global_out + NumBlocks() * 3 * 16 * get_global_id(2);
  for (int i = 0; i < 16; ++i) {
    int4 rgb = palette[hook(6, idx & 3)];

    unsigned int x = 4 * get_global_id(0) + (i % 4);
    unsigned int y = 4 * get_global_id(1) + (i / 4);

    unsigned int out_offset = 3 * (4 * get_global_size(0) * y + x);
    out[hook(8, out_offset + 0)] = rgb.x;
    out[hook(8, out_offset + 1)] = rgb.y;
    out[hook(8, out_offset + 2)] = rgb.z;

    idx >>= 2;
  }
}