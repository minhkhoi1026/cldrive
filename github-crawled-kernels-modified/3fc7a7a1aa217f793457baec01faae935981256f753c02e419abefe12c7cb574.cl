//{"color_tab":5,"octree":4,"p_height":3,"p_screenBuffer":0,"p_screenBuffer_tex":1,"p_width":2}
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
      return ((octree[hook(4, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(4, n + nadd)];
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
      nadd += get_bitcount((octree[hook(4, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(4, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
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
        nadd += get_bitcount((octree[hook(4, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(4, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(4, n + nadd)];
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

kernel void raycast_colorize(global unsigned int* p_screenBuffer, global unsigned int* p_screenBuffer_tex, int p_width, int p_height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= p_width)
    return;
  if (y >= p_height)
    return;

  int of = x + y * p_width;
  int a = p_screenBuffer[hook(0, of)];

  float3 color_tab[4] = {{1.0, 1.0, 1.0}, {1.0, 0.7, 0.3}, {1.5, 0.8, 0.1}, {0.2, 0.8, 0.2}};

  int col = a & 3;
  float3 rgb = color_tab[hook(5, col)];
  float i = convert_float((a & (255 - 7)));
  int r = i * rgb.x;
  if (r > 255)
    r = 255;
  int g = i * rgb.y;
  if (g > 255)
    g = 255;
  int b = i * rgb.z;
  if (b > 255)
    b = 255;
  p_screenBuffer_tex[hook(1, of)] = b + g * 256 + r * 65536;
}