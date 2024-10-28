//{"endpoint_planes":2,"global_offsets":1,"global_out":4,"global_palette":0,"indices":3,"out":6,"palette":7,"planes":5}
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

kernel void assemble_dxt(const global int* global_palette, const constant unsigned int* global_offsets, const global char* endpoint_planes, const global int* indices, global ushort* global_out) {
  const unsigned int global_offset = NumBlocks() * 6 * get_global_id(2);

  ushort ep1 = GetPixel(endpoint_planes + global_offset, 0);
  ushort ep2 = GetPixel(endpoint_planes + global_offset, 1);

  global ushort* out = global_out + get_global_id(2) * NumBlocks() * 4;
  out[hook(6, 4 * ThreadIdx() + 0)] = ep1;
  out[hook(6, 4 * ThreadIdx() + 1)] = ep2;

  const global int* palette = global_palette + global_offsets[hook(1, 4 * get_global_id(2) + 2)] / 4;
  const unsigned int plt_idx = indices[hook(3, get_global_id(2) * NumBlocks() + ThreadIdx())];
  *((global unsigned int*)(out) + 2 * ThreadIdx() + 1) = palette[hook(7, plt_idx)];
}