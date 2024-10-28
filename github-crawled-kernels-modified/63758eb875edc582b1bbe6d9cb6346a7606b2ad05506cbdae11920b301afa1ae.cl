//{"a_backBuffer":1,"a_idBuffer":2,"a_screenBuffer":0,"frame":5,"octree":6,"res_x":3,"res_y":4}
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
      return ((octree[hook(6, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(6, n + nadd)];
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
      nadd += get_bitcount((octree[hook(6, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(6, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
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
        nadd += get_bitcount((octree[hook(6, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(6, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(6, n + nadd)];
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

kernel void raycast_counthole(global unsigned int* a_screenBuffer, global float* a_backBuffer, global unsigned int* a_idBuffer, int res_x, int res_y, int frame)

{
  const int idx = get_global_id(0);
  const int idy = get_global_id(1);
  if (idx >= res_x / 16)
    return;
  if (idy >= res_y / 16)
    return;

  int count = 0;

  int x = idx * 16;
  int y = idy * 16;
  int ofs = x + y * res_x;
  int dx = min(res_x - x, 16) / 2;
  int dy = min(res_y - y, 16) / 2;

  for (int j = 0; j < dy; ++j)
    for (int i = 0; i < dx; ++i) {
      int o = ofs + i * 2 + j * 2 * res_x;
      int a = 0;
      if (a_screenBuffer[hook(0, o)] == 0xffffff00)
        a++;
      if (a_screenBuffer[hook(0, o + 1)] == 0xffffff00)
        a++;
      if (a_screenBuffer[hook(0, o + 1 + res_x)] == 0xffffff00)
        a++;
      if (a_screenBuffer[hook(0, o + res_x)] == 0xffffff00)
        a++;
      if (a >= 4)
        count += 4;
    }
  a_idBuffer[hook(2, idx + idy * (res_x / 16))] = count;
}