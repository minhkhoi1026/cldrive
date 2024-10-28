//{"a_backBuffer":1,"a_m0":9,"a_mx":10,"a_my":11,"a_mz":12,"a_screenBuffer":0,"a_xbuffer":2,"a_ybuffer":3,"a_zbuffer":4,"frame":7,"octree":13,"ofs_add":8,"res_x":5,"res_y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int get_bitcount(unsigned int b) {
  b = (b & 0x55) + (b >> 1 & 0x55);
  b = (b & 0x33) + (b >> 2 & 0x33);
  b = (b + (b >> 4)) & 0x0f;
  return b;
}

inline unsigned int fetchChildOffset(global unsigned int* octree, unsigned int const a_node, unsigned int const a_node_before, unsigned int* local_root, unsigned int a_child, unsigned int child_test,

                                     unsigned int rekursion) {
  unsigned int n = a_node >> 9;
  unsigned int nadd = a_child;

  if (a_node & 256) {
    if (!(a_node_before & 256)) {
      (*local_root) = n << 6;
      n = n ^ n;
    }
    n += (*local_root);
    nadd = get_bitcount(a_node & ((child_test << 1) - 1));

    if (rekursion == 2) {
      return ((octree[hook(13, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(13, n + nadd)];
}

inline unsigned int fetchColor(global unsigned int* octree, unsigned int const a_node, unsigned int const a_node_before, unsigned int const a_node_before2, unsigned int* local_root, unsigned int rekursion, unsigned int child_test

) {
  unsigned int n = a_node >> 9;
  unsigned int nadd = 8;

  if (rekursion == 1) {
    n = (a_node_before >> 9) & 15;
    unsigned int ofs = (a_node_before2 >> 9) + (*local_root);
    nadd = 0 + get_bitcount(a_node_before2 & 255);
    for (int i = 1; i < n; ++i) {
      nadd += get_bitcount((octree[hook(13, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(13, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
  }

  if (a_node & 256) {
    if (!(a_node_before & 256)) {
      (*local_root) = n << 6;
      n = n ^ n;
    }
    nadd = (*local_root);

    if (rekursion == 2) {
      unsigned int ofs = (a_node_before >> 9) + (*local_root);
      nadd = 1 + get_bitcount(a_node_before & 255);
      for (int i = 1; i < n; ++i) {
        nadd += get_bitcount((octree[hook(13, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(13, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(13, n + nadd)];
}
struct BVHNode {
  unsigned int childs[2];
  float p[12];
};
struct BVHChild {
  float3 min, max;
  float4 m0;
  float4 m1;
  float4 m2;
  float4 m3;
  unsigned int octreeroot;
};

kernel void raycast_proj(global unsigned int* a_screenBuffer, global float* a_backBuffer, global int* a_xbuffer, global int* a_ybuffer, global int* a_zbuffer, int res_x, int res_y, int frame, int ofs_add, float4 a_m0, float4 a_mx, float4 a_my, float4 a_mz

) {
  const int tx = get_local_id(0), ty = get_local_id(1);
  const int bw = get_local_size(0), bh = get_local_size(1);
  const int idx = get_global_id(0), idy = get_global_id(1);
  if (idx >= res_x || idy >= res_y)
    return;

  int tid = ty * bw + tx;

  int ofs = idy * res_x + idx;

  ofs += ofs_add;
  unsigned int srcofs = ofs;
  unsigned int col = a_screenBuffer[hook(0, ofs)];
  if (col == 0xffffff00)
    return;

  if (0)
    if (col > 100 * 256 * 256)
      if (idx > 0)
        if (idy > 0) {
          for (int i = 0; i < 4; ++i) {
            int addx = 0, addy = 0;

            if (i == 0) {
              addx = 1;
            }
            if (i == 1) {
              addy = 1;
            }
            if (i == 2) {
              addx = -1;
            }
            if (i == 3) {
              addy = -1;
            }
            int add = addx + addy * res_x;
            unsigned int col0 = a_screenBuffer[hook(0, ofs + add)];

            if (col0 < 100 * 256 * 256) {
              return;

              {
                a_screenBuffer[hook(0, ofs)] = 0xffffff00;
                return;
              }
            }
          }
        }

  float3 pcache;

  pcache.x = a_backBuffer[hook(1, ofs * 4 + 0)];

  pcache.y = a_backBuffer[hook(1, ofs * 4 + 1)];
  pcache.z = a_backBuffer[hook(1, ofs * 4 + 2)];
  float pcache_z_screen = a_backBuffer[hook(1, ofs * 4 + 3)];
  ofs -= ofs_add;

  float3 p = pcache.xyz - a_m0.xyz;
  float3 phit;
  phit.x = dot(p, a_mx.xyz);
  phit.y = dot(p, a_my.xyz);
  phit.z = dot(p, a_mz.xyz);

  if (phit.z < 0.05) {
    a_screenBuffer[hook(0, srcofs)] = 0xffffff00;
    return;
  }

  float3 scrf;
  scrf.x = (phit.x * convert_float(res_y) + 0.0) / phit.z + convert_float(res_x) / 2 - 0.0;
  scrf.y = (phit.y * convert_float(res_y) + 0.0) / phit.z + convert_float(res_y) / 2 - 0.0;
  scrf.z = phit.z;
  int2 scr;
  scr.x = scrf.x;
  scr.y = scrf.y;

  if (scr.x >= res_x - 1) {
    a_screenBuffer[hook(0, srcofs)] = 0xffffff00;
    return;
  }
  if (scr.x < 0) {
    a_screenBuffer[hook(0, srcofs)] = 0xffffff00;
    return;
  }
  if (scr.y >= res_y - 1) {
    a_screenBuffer[hook(0, srcofs)] = 0xffffff00;
    return;
  }
  if (scr.y < 0) {
    a_screenBuffer[hook(0, srcofs)] = 0xffffff00;
    return;
  }

  ofs = scr.y * res_x + scr.x;
  int sz = phit.z * 1000;
  sz <<= 8;
  int val = sz + (col & 255);

  if ((a_screenBuffer[hook(0, ofs)] & 0xffffff00) <= sz)
    return;
  if (atom_min(&a_screenBuffer[hook(0, ofs)], val) < val)
    return;

  if (a_screenBuffer[hook(0, ofs)] != val)
    return;

  a_backBuffer[hook(1, ofs * 4 + 0)] = pcache.x;
  a_backBuffer[hook(1, ofs * 4 + 1)] = pcache.y;
  a_backBuffer[hook(1, ofs * 4 + 2)] = pcache.z;
  a_backBuffer[hook(1, ofs * 4 + 3)] = phit.z;
}