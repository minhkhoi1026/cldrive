//{"a_backBuffer":1,"a_cam":9,"a_dx":11,"a_dy":12,"a_m0":13,"a_mx":14,"a_my":15,"a_mz":16,"a_octree":2,"a_origin":10,"a_screenBuffer":0,"add_x":7,"add_y":8,"fovx":17,"fovy":18,"frame":6,"octree":19,"octree_root":3,"res_x":4,"res_y":5,"stack":20}
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
      return ((octree[hook(19, n + (nadd >> 2))] >> ((nadd & 3) << 3)) & 255) + 256 + (nadd << 9);
    }
  }
  return octree[hook(19, n + nadd)];
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
      nadd += get_bitcount((octree[hook(19, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
    }
    nadd += get_bitcount(a_node_before & ((child_test << 1) - 1));

    return octree[hook(19, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
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
        nadd += get_bitcount((octree[hook(19, ofs + (i >> 2))] >> ((i & 3) << 3)) & 255);
      }
      return octree[hook(19, ofs + (nadd >> 2))] >> ((nadd & 3) << 3);
    }
  }
  return octree[hook(19, n + nadd)];
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

kernel void raycast_fine_2(global unsigned int* a_screenBuffer, global float* a_backBuffer, global unsigned int* a_octree, unsigned int octree_root, int res_x, int res_y, int frame, int add_x, int add_y, float4 a_cam, float4 a_origin, float4 a_dx, float4 a_dy,

                           float4 a_m0, float4 a_mx, float4 a_my, float4 a_mz, float fovx, float fovy) {
  const int tx = get_local_id(0), ty = get_local_id(1);
  const int bw = get_local_size(0), bh = get_local_size(1);

  int idx0 = get_global_id(0), idy0 = get_global_id(1);
  int idx = idx0, idy = idy0;

  idx += add_x;
  idy += add_y;

  if (idx >= res_x || idy >= res_y)
    return;

  local unsigned int stack[16000 / 4];
  int thread_num = tx + ty * bw;
  unsigned int stack_add = (thread_num * (11 - 1)) - 1;

  float3 delta1;
  delta1.x = convert_float(idx - res_x / 2 + 0.5) * fovx / convert_float(res_y);
  delta1.y = convert_float(idy - res_y / 2 + 0.5) * fovy / convert_float(res_y);
  delta1.z = 1;

  float3 delta;
  delta.x = dot(delta1, a_mx.xyz);
  delta.y = dot(delta1, a_my.xyz);
  delta.z = dot(delta1, a_mz.xyz);

  float rayLength = 0, distance = 0;

  unsigned int col = 0xff0000f2;
  float3 phit;

  float3 raypos = a_m0.xyz * 16.0f;

  int sign_x, sign_y, sign_z, rekursion;
  float3 grad0, grad1, grad2, len0;
  int3 raypos_int, raypos_before;
  int lod = 1.0, x0r, x0rx, x0ry, x0rz, sign_xyz;
  unsigned int nodeid, nodeid_before, local_root, node_test;
  float lodswitch = res_x * 1 * 2;
  const int CUBESIZE = (1 << (11 + 1));
  sign_x = 0, sign_y = 0, sign_z = 0;
  rekursion = 11;
  float epsilon = pow(2.0f, -20.0f);
  if (fabs(delta.x) < epsilon)
    delta.x = sign(delta.x) * epsilon;
  if (fabs(delta.y) < epsilon)
    delta.y = sign(delta.y) * epsilon;
  if (fabs(delta.z) < epsilon)
    delta.z = sign(delta.z) * epsilon;
  if (delta.x < 0) {
    sign_x = 1;
    raypos.x = (1 << (11 + 1)) - raypos.x;
    delta.x = -delta.x;
  }
  if (delta.y < 0) {
    sign_y = 1;
    raypos.y = (1 << (11 + 1)) - raypos.y;
    delta.y = -delta.y;
  }
  if (delta.z < 0) {
    sign_z = 1;
    raypos.z = (1 << (11 + 1)) - raypos.z;
    delta.z = -delta.z;
  }
  grad0.x = 1;
  grad0.y = delta.y / delta.x;
  grad0.z = delta.z / delta.x;
  grad1.x = delta.x / delta.y;
  grad1.y = 1;
  grad1.z = delta.z / delta.y;
  grad2.x = delta.x / delta.z;
  grad2.y = delta.y / delta.z;
  grad2.z = 1;
  len0.x = length(grad0);
  len0.y = length(grad1);
  len0.z = length(grad2);
  float3 raypos_orig = raypos;
  raypos_int = convert_int3(raypos);
  nodeid = octree_root;
  nodeid_before = octree_root;
  local_root = 0;
  x0r = 0;
  x0ry = 0;
  sign_xyz = sign_x | (sign_y << 1) | (sign_z << 2);
  raypos_before = raypos_int;
  do {
    int3 p0i = raypos_int >> rekursion;
    int3 bit = p0i & 1;
    int node_index = (bit.x | (bit.y << 1) | (bit.z << 2)) ^ sign_xyz;
    node_test = nodeid & (1 << node_index);
    if (node_test) {
      unsigned int tmp = nodeid;
      nodeid = fetchChildOffset(a_octree, nodeid, nodeid_before, &local_root, node_index, node_test, rekursion);
      nodeid_before = tmp;
      if (rekursion <= lod)
        break;
      rekursion--;
      stack[hook(20, stack_add + rekursion)] = nodeid;
      continue;
    }
    float3 mul0 = convert_float3((p0i + 1) << rekursion) - raypos;
    raypos_before = convert_int3(raypos);
    float3 isec_dist = mul0 * len0;
    float3 isec0 = grad0 * mul0.x;
    if (isec_dist.y < isec_dist.x) {
      isec_dist.x = isec_dist.y;
      isec0 = grad1 * mul0.y;
    }
    if (isec_dist.z < isec_dist.x) {
      isec_dist.x = isec_dist.z;
      isec0 = grad2 * mul0.z;
    }
    raypos += isec0;
    raypos_int = convert_int3(raypos);
    distance += isec_dist.x;
    x0rx = raypos_before.x ^ raypos_int.x;
    x0ry = raypos_before.y ^ raypos_int.y;
    x0rz = raypos_before.z ^ raypos_int.z;
    x0r = x0rx ^ x0ry ^ x0rz;
    int rekursion_new = log2(convert_float(x0r & ((1 << 11) - 1)));
    if (distance > 400000)
      break;
    if (rekursion_new < rekursion)
      continue;
    rekursion = rekursion_new + 1;
    nodeid = stack[hook(20, stack_add + rekursion)];
    nodeid_before = stack[hook(20, stack_add + rekursion + 1)];
    if (rekursion == 11)
      nodeid_before = nodeid = octree_root;
    if (distance > lodswitch) {
      lodswitch *= 2;
      ++lod;
    }
  } while (!(x0ry & (2 * ((1 << 11) - 1) + 2)));
  if (sign_x) {
    raypos.x = (1 << (11 + 1)) - raypos.x;
    delta.x = -delta.x;
  };
  if (sign_y) {
    raypos.y = (1 << (11 + 1)) - raypos.y;
    delta.y = -delta.y;
  };
  if (sign_z) {
    raypos.z = (1 << (11 + 1)) - raypos.z;
    delta.z = -delta.z;
  };
  ;

  {
    col = fetchColor(a_octree, nodeid, nodeid_before, stack[hook(20, stack_add + rekursion + 1)], &local_root, rekursion, node_test);

    rayLength = distance;
    phit = raypos / 16.0f;
  }

  int ofs = idy * res_x + idx;

  for (int i = 1; i < 2; ++i) {
    a_screenBuffer[hook(0, ofs)] = 0xff000000 + col;
    a_backBuffer[hook(1, ofs * 4 + 0)] = phit.x;
    a_backBuffer[hook(1, ofs * 4 + 1)] = phit.y;
    a_backBuffer[hook(1, ofs * 4 + 2)] = phit.z;
    ofs += res_x * res_y;
  }
  return;
}