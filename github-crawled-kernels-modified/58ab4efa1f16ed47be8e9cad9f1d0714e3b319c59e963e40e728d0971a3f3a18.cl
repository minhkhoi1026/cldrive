//{"matx":5,"maty":6,"matz":7,"p_backBuffer":1,"p_data":2,"p_height":4,"p_screenBuffer":0,"p_width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void splatting(global unsigned int* p_screenBuffer, global unsigned int* p_backBuffer, global unsigned int* p_data, int p_width, int p_height, float4 matx, float4 maty, float4 matz) {
  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int bw = get_local_size(0);
  const int bh = get_local_size(1);
  const int idx = get_global_id(0);
  const int idy = get_global_id(1);

  float anim = matx.w / 1000;

  for (int j = -10; j < 10; ++j)
    for (int k = 0; k < 10; ++k) {
      int addx = j * 1024 * 2;
      int addy = (((j ^ k) * 24352) & 1023);
      int addz = k * 1024 * 2;

      float4 p, pt;
      p.x = addx + 512;
      p.y = addy + 512;
      p.z = addz + 512;
      p.w = 1;
      pt.x = dot(p, matx);
      pt.y = dot(p, maty);
      pt.z = dot(p, matz);

      if (pt.z < -600)
        continue;

      int sx = pt.x * p_width / pt.z + p_width / 2;
      if (sx >= p_width * 2)
        continue;
      if (sx < -p_width)
        continue;

      int sy = pt.y * p_width / pt.z + p_height / 2;
      if (sy >= p_height * 2)
        continue;
      if (sy < -p_height)
        continue;

      int level = log2((pt.z / 2) / p_width);

      if (level < 0)
        level = 0;
      if (level >= 9)
        continue;

      int m = p_data[hook(2, level)];
      int num_cubes = p_data[hook(2, m)];
      m++;

      for (int i = 0; i < num_cubes; ++i) {
        int cx = (p_data[hook(2, m)] << level) + addx;
        m++;
        int cy = (p_data[hook(2, m)] << level) + addy;
        m++;
        int cz = (p_data[hook(2, m)] << level) + addz;
        m++;
        int cc = p_data[hook(2, m)];
        m++;
        int cd = m + idx;
        int ce = m + cc;
        m += cc;

        int pack = 0;
        int n = 0;

        while (cd < ce) {
          pack = p_data[hook(2, cd)];

          cd += 8192;

          float4 p;
          p.x = cx + ((pack & 0xff) << level);
          p.y = cy + (((pack >> 8) & 0xff) << level);
          p.z = cz + (((pack >> 16) & 0xff) << level);
          p.w = 1;
          float4 pt;
          pt.z = dot(p, matz);
          if (pt.z < 1)
            continue;
          if (pt.z > 65000)
            continue;

          pt.x = dot(p, matx);
          int sx = pt.x * p_width / pt.z + p_width / 2;
          if (sx >= p_width)
            continue;
          if (sx < 0)
            continue;

          pt.y = dot(p, maty);
          int sy = pt.y * p_width / pt.z + p_height / 2;
          if (sy >= p_height)
            continue;
          if (sy < 0)
            continue;

          int sz = pt.z;
          int ofs = sy * p_width + sx;
          sz <<= 8;

          if ((p_screenBuffer[hook(0, ofs)] & 0xffff00) <= sz)
            continue;

          int ic = ((pack >> 24) & 0xff);

          atom_min(&p_screenBuffer[hook(0, ofs)], sz + ic);
        }
      }
    }
}