//{"m_height":4,"m_offset":5,"m_width":3,"mipmap":0,"prev_offset":2,"prev_width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void channel_mipmap(global float* mipmap, const int prev_width, const int prev_offset, const int m_width, const int m_height, const int m_offset) {
  int2 pos;
  for (pos.y = get_global_id(1); pos.y < m_height; pos.y += get_global_size(1)) {
    for (pos.x = get_global_id(0); pos.x < m_width; pos.x += get_global_size(0)) {
      int _x = 2 * pos.x;
      int _y = 2 * pos.y;
      mipmap[hook(0, pos.x + pos.y * m_width + m_offset)] = (mipmap[hook(0, _x + _y * prev_width + prev_offset)] + mipmap[hook(0, _x + 1 + _y * prev_width + prev_offset)] + mipmap[hook(0, _x + (_y + 1) * prev_width + prev_offset)] + mipmap[hook(0, (_x + 1) + (_y + 1) * prev_width + prev_offset)]) / 4.f;
    }
  }
}