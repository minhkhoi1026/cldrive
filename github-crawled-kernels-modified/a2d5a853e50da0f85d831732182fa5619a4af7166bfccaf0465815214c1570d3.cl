//{"a_backBuffer":1,"a_screenBuffer":0,"frame":4,"octree":5,"res_x":2,"res_y":3}
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
      return ((octree[hook(5, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(5, n + nadd)];
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
      nadd += get_bitcount((octree[hook(5, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(5, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
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
        nadd += get_bitcount((octree[hook(5, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(5, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(5, n + nadd)];
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

kernel void raycast_fillhole2(global unsigned int* a_screenBuffer, global float* a_backBuffer, int res_x, int res_y, int frame

) {
  const int tx = get_local_id(0), ty = get_local_id(1);
  const int bw = get_local_size(0), bh = get_local_size(1);
  const int idx = get_global_id(0), idy = get_global_id(1);
  if (idx >= res_x - 1 || idy >= res_y - 1 || idx <= 1 || idy <= 1)
    return;

  int ofs = idy * res_x + idx;
  unsigned int col = a_screenBuffer[hook(0, ofs)];
  if (col != 0xffffff00)
    return;

  int col1 = a_screenBuffer[hook(0, ofs + 1)];
  int col2 = a_screenBuffer[hook(0, ofs - 1)];
  int col3 = a_screenBuffer[hook(0, ofs + res_x)];
  int col4 = a_screenBuffer[hook(0, ofs - res_x)];

  if (col1 != 0xffffff00)
    if (col2 != 0xffffff00)
      if (col3 != 0xffffff00)
        if (col4 != 0xffffff00) {
          a_screenBuffer[hook(0, ofs)] = (col1 & 3) + ((((col1 & 0xfc) + (col2 & 0xfc) + (col3 & 0xfc) + (col4 & 0xfc)) >> 2) & 0xfc);
          return;
        }

  if (col1 != 0xffffff00)
    if (col2 != 0xffffff00) {
      a_screenBuffer[hook(0, ofs)] = (col1 & 3) + ((((col1 & 0xfc) + (col2 & 0xfc)) >> 1) & 0xfc);
      return;
    }

  if (col3 != 0xffffff00)
    if (col4 != 0xffffff00) {
      a_screenBuffer[hook(0, ofs)] = (col3 & 3) + ((((col3 & 0xfc) + (col4 & 0xfc)) >> 1) & 0xfc);
      return;
    }

  for (int i = 0; i < 4; ++i) {
    int o = ofs + (i & 1) + ((i >> 1) & 1) * res_x;
    col = a_screenBuffer[hook(0, o)];
    if (col != 0xffffff00)
      break;
  }

  if (col == 0xffffff00)
    for (int i = -2; i < 3; ++i)
      for (int j = -2; j < 3; ++j) {
        int o = ofs + i + j * res_x;
        if (col != 0xffffff00)
          break;
        col = a_screenBuffer[hook(0, o)];
      }

  a_screenBuffer[hook(0, ofs)] = col;
}