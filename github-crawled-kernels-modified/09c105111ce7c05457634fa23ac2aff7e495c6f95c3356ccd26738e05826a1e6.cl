//{"a_backBuffer":1,"a_screenBuffer":0,"a_xbuffer":2,"a_ybuffer":3,"a_zbuffer":4,"frame":7,"octree":8,"res_x":5,"res_y":6}
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
      return ((octree[hook(8, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(8, n + nadd)];
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
      nadd += get_bitcount((octree[hook(8, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(8, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
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
        nadd += get_bitcount((octree[hook(8, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(8, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(8, n + nadd)];
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

kernel void raycast_fillhole(global unsigned int* a_screenBuffer, global float* a_backBuffer, global int* a_xbuffer, global int* a_ybuffer, global float* a_zbuffer, int res_x, int res_y, int frame) {
  const int tx = get_local_id(0), ty = get_local_id(1);
  const int bw = get_local_size(0), bh = get_local_size(1);
  const int idx = get_global_id(0), idy = get_global_id(1);
  if (idx >= res_x - 4 || idy >= res_y - 4 || idx < 3 || idy < 3)
    return;

  unsigned int of = idy * res_x + idx;

  unsigned int c0 = a_screenBuffer[hook(0, of)];
  if (c0 == 0xffffff00)
    return;

  float z0 = a_backBuffer[hook(1, of * 4 + 3)];
  float z1 = z0;
  unsigned int c1 = c0;

  int xi, yj;

  int add_x = 0;
  int add_y = 0;

  for (int i = -1 + add_x; i < 1 + add_x; ++i)
    for (int j = -1 + add_y; j < 1 + add_y; ++j) {
      unsigned int ofs = of + j * res_x + i;
      float z = a_backBuffer[hook(1, ofs * 4 + 3)];
      if (z < z1) {
        xi = i;
        yj = j;
        z1 = z;
      }
    }
  int dx0 = a_xbuffer[hook(2, of)];
  int dy0 = a_ybuffer[hook(3, of)];

  int oij = of + yj * res_x + xi;
  int dx = a_xbuffer[hook(2, oij)];
  int dy = a_ybuffer[hook(3, oij)];

  if (z0 <= z1)
    return;

  if (fabs(z1 - z0) > min(z0, z1) * (0.00625 * 1.0) * 4.0)

    if (abs(dx - dx0) > 0 || abs(dy - dy0) > 0)

    {
      a_screenBuffer[hook(0, of)] = 0xffffff00;
    }
}