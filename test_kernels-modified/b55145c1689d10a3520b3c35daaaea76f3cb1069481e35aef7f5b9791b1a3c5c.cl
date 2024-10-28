//{"((__private float *)&ray->dir)":24,"((__private float *)(&ray->dir))":14,"((__private float *)(&ray->o))":15,"a_out_data":2,"cl_aabb":8,"cs":5,"cut_aabbs":9,"cut_aabbs_count":10,"dxs":6,"dys":7,"h":1,"ids":13,"intersections":22,"modulo":17,"nodes":11,"os":4,"out_dip":3,"prt_dir":16,"prt_o":18,"ptr_A":20,"tr_stack.t":23,"tris":12,"w":0,"wt->A":19,"wt->N":21}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct ct_state {
  float4 o;
  float4 c;
  float4 dx;
  float4 dy;
};

struct aabb {
  float x1, x2, y1, y2, z1, z2;
};

int isInside(struct aabb* box, float4* v) {
  if ((*v).x <= box->x2)
    if ((*v).x >= box->x1)
      if ((*v).y <= box->y2)
        if ((*v).y >= box->y1)
          if ((*v).z <= box->z2)
            if ((*v).z >= box->z1)
              return 1;
  return 0;
}
struct BSPNode {
  union {
    unsigned int tri_start;
    unsigned int offset;
  };
  union {
    unsigned int tri_count;
    float splitCoord;
  };
  unsigned int masked_vars;
};
struct trace_t {
  unsigned int node;
  float tmin;
  float tmax;
};

struct traverse_stack {
  int index;
  struct trace_t t[30];
};
struct wald_tri {
  float N[3];
  float A[3];
  float nu, nv, nd;
  unsigned int k;
  float bnu, bnv, cnu, cnv;
};
struct Ray {
  float4 o;
  float4 dir;
};

struct intersection {
  unsigned int prim_ind;
  float dist;
};
inline unsigned int IntersectRayAABB(struct Ray* ray, global struct aabb* box, float tmin, float tmax) {
  float l1 = (box->x1 - ray->o.x) / ray->dir.x;
  float l2 = (box->x2 - ray->o.x) / ray->dir.x;
  tmin = fmax(fmin(l1, l2), tmin);
  tmax = fmin(fmax(l1, l2), tmax);
  l1 = (box->y1 - ray->o.y) / ray->dir.y;
  l2 = (box->y2 - ray->o.y) / ray->dir.y;
  tmin = fmax(fmin(l1, l2), tmin);
  tmax = fmin(fmax(l1, l2), tmax);
  l1 = (box->z1 - ray->o.z) / ray->dir.z;
  l2 = (box->z2 - ray->o.z) / ray->dir.z;
  tmin = fmax(fmin(l1, l2), tmin);
  tmax = fmin(fmax(l1, l2), tmax);
  return ((tmax >= tmin) & (tmax >= 0.f));
}
inline int GetIntersectionState(struct Ray* ray, const float tmin, const float tmax, const float split, const int splitIndex, float* t) {
  float rd = ((float*)(&ray->dir))[hook(14, splitIndex)];
  float ro = ((float*)(&ray->o))[hook(15, splitIndex)];
  if (!rd)
    rd = 0.0000000001f;
  (*t) = (split - ro) / rd;
  const int sign = (rd >= 0.0f);
  if ((*t) < tmin)
    return (sign ^ 0);
  if ((*t) > tmax)
    return (sign ^ 1);
  return 2;
}
constant unsigned int modulo[] = {0, 1, 2, 0, 1};

inline int IntersectRayWTri(struct Ray* a_Ray, global struct wald_tri* wt, float* a_Dist, float* a_Dip) {
  float* prt_dir = &a_Ray->dir;
  float* prt_o = &a_Ray->o;
  const float dir_wt_k = prt_dir[hook(16, wt->k)];
  const float dir_ku = prt_dir[hook(16, modulo[whook(17, wt->k + 1))];
  const float dir_kv = prt_dir[hook(16, modulo[whook(17, wt->k + 2))];
  const float o_wt_k = prt_o[hook(18, wt->k)];
  const float o_ku = prt_o[hook(18, modulo[whook(17, wt->k + 1))];
  const float o_kv = prt_o[hook(18, modulo[whook(17, wt->k + 2))];
  float4 A = (float4)(wt->A[hook(19, 0)], wt->A[hook(19, 1)], wt->A[hook(19, 2)], 0.0f);
  float* ptr_A = &A;
  const float wt_A_ku = ptr_A[hook(20, modulo[whook(17, wt->k + 1))];
  const float wt_A_kv = ptr_A[hook(20, modulo[whook(17, wt->k + 2))];

  const float lnd = 1.0f / (dir_wt_k + wt->nu * dir_ku + wt->nv * dir_kv);
  const float t = (wt->nd - o_wt_k - wt->nu * o_ku - wt->nv * o_kv) * lnd;
  if (!((*a_Dist) > t && t > 0))
    return 0;
  const float hu = o_ku + t * dir_ku - wt_A_ku;
  const float hv = o_kv + t * dir_kv - wt_A_kv;
  const float beta = hv * wt->bnu + hu * wt->bnv;
  if (beta < 0)
    return 0;
  const float gamma = hu * wt->cnu + hv * wt->cnv;
  if (gamma < 0)
    return 0;
  if ((beta + gamma) > 1)
    return 0;
  (*a_Dist) = t;
  (*a_Dip) = dot(a_Ray->dir, (float4)(wt->N[hook(21, 0)], wt->N[hook(21, 1)], wt->N[hook(21, 2)], 0.0f));
  return ((*a_Dip) > 0) ? -1 : 1;
}

int trace_tree(struct Ray* ray, float* res, float* res_dip,

               global struct aabb* cl_aabb, global struct aabb* cut_aabbs, unsigned int cut_aabbs_count,

               global struct BSPNode* nodes, global struct wald_tri* tris, global unsigned int* ids) {
  float cur_tmin = 0;
  float cur_tmax = 100000.f;

  bool intersects = IntersectRayAABB(ray, cl_aabb, cur_tmin, cur_tmax);
  if (!intersects)
    return 0;

  if (intersects && cut_aabbs_count != 0) {
    intersects = false;
    for (unsigned int i = 0; i < cut_aabbs_count; i++) {
      float a = 0.f, b = 100000.f;
      if (IntersectRayAABB(ray, &cut_aabbs[hook(9, i)], a, b)) {
        intersects = true;
        break;
      }
    }
  }
  if (!intersects)
    return 0;

  struct intersection intersections[24];
  intersections[hook(22, 0)].dist = 0;

  struct traverse_stack tr_stack;
  tr_stack.index = 0;

  unsigned int cur_node_id = 0;
  {
    tr_stack.t[hook(23, tr_stack.index)].node = cur_node_id;
    tr_stack.t[hook(23, tr_stack.index)].tmin = cur_tmin;
    tr_stack.t[hook(23, tr_stack.index)].tmax = cur_tmax;
    tr_stack.index++;
  };

  global struct BSPNode* cur_node;
  global struct wald_tri* cur_tri;
  unsigned int sign = 0;
  unsigned int isec_count = 0;

  while (tr_stack.index > 0) {
    cur_node_id = (&(tr_stack.t[hook(23, tr_stack.index - 1)]))->node;
    cur_tmin = (&(tr_stack.t[hook(23, tr_stack.index - 1)]))->tmin;
    cur_tmax = (&(tr_stack.t[hook(23, tr_stack.index - 1)]))->tmax;
    tr_stack.index--;
    ;
    cur_node = &nodes[hook(11, cur_node_id)];
    if ((bool)((cur_node->masked_vars) & 0x00000080)) {
      for (unsigned int i = 0; i < cur_node->tri_count; i++) {
        float a_Dist = 1000000.0f, a_Dip;
        unsigned int indx = ids[hook(13, i + cur_node->tri_start)];
        cur_tri = &tris[hook(12, indx)];

        if (IntersectRayWTri(ray, cur_tri, &a_Dist, &a_Dip)) {
          bool again = false;
          for (unsigned int i = 0; i < isec_count; i++)
            if (intersections[hook(22, i)].prim_ind == indx)
              again = true;
          if (again)
            continue;

          (*res_dip) += fabs(a_Dip);
          intersections[hook(22, isec_count)].prim_ind = indx;
          intersections[hook(22, isec_count)].dist = a_Dist;
          isec_count++;
          if (isec_count == 24)
            goto MAX_INTERSECTIONS_HIT;
        }
      }
    } else {
      float t;
      const int resisec = GetIntersectionState(ray, cur_tmin, cur_tmax, cur_node->splitCoord, (int)((cur_node->masked_vars) & 0x00000003), &t);
      switch (resisec) {
        case 0:
          if ((bool)((cur_node->masked_vars) & 0x00000040)) {
            tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset;
            tr_stack.t[hook(23, tr_stack.index)].tmin = cur_tmin;
            tr_stack.t[hook(23, tr_stack.index)].tmax = cur_tmax;
            tr_stack.index++;
          };
          break;
        case 1:
          if ((bool)((cur_node->masked_vars) & 0x00000020)) {
            tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset + 1;
            tr_stack.t[hook(23, tr_stack.index)].tmin = cur_tmin;
            tr_stack.t[hook(23, tr_stack.index)].tmax = cur_tmax;
            tr_stack.index++;
          };
          break;
        case 2:
          sign = ((float*)&ray->dir)[hook(24, (int)((cur_node->masked_vars) & 3))] >= 0.0f;
          if (sign) {
            if ((bool)((cur_node->masked_vars) & 0x00000040)) {
              tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset;
              tr_stack.t[hook(23, tr_stack.index)].tmin = cur_tmin;
              tr_stack.t[hook(23, tr_stack.index)].tmax = t;
              tr_stack.index++;
            };
            if ((bool)((cur_node->masked_vars) & 0x00000020)) {
              tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset + 1;
              tr_stack.t[hook(23, tr_stack.index)].tmin = t;
              tr_stack.t[hook(23, tr_stack.index)].tmax = cur_tmax;
              tr_stack.index++;
            };
          } else {
            if ((bool)((cur_node->masked_vars) & 0x00000020)) {
              tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset + 1;
              tr_stack.t[hook(23, tr_stack.index)].tmin = cur_tmin;
              tr_stack.t[hook(23, tr_stack.index)].tmax = t;
              tr_stack.index++;
            };
            if ((bool)((cur_node->masked_vars) & 0x00000040)) {
              tr_stack.t[hook(23, tr_stack.index)].node = cur_node->offset;
              tr_stack.t[hook(23, tr_stack.index)].tmin = t;
              tr_stack.t[hook(23, tr_stack.index)].tmax = cur_tmax;
              tr_stack.index++;
            };
          }
          break;
      }
    }
  }

MAX_INTERSECTIONS_HIT:

  for (unsigned int i = 0; i < isec_count; i++) {
    float tmp;
    unsigned char swapped = 0;
    for (unsigned int j = 0; j < isec_count - 1 - i; j++) {
      if (intersections[hook(22, j)].dist > intersections[hook(22, j + 1)].dist) {
        tmp = intersections[hook(22, j)].dist;
        intersections[hook(22, j)].dist = intersections[hook(22, j + 1)].dist;
        intersections[hook(22, j + 1)].dist = tmp;
        if (swapped == 0)
          swapped = 1;
      }
    }
    if (swapped == 0)
      break;
  }
  unsigned int n = 0;
  if (isec_count % 2 == 0)
    for (unsigned int i = 0; i < isec_count; i++)
      if ((i + n) % 2 == 1)
        (*res) += intersections[hook(22, i)].dist - intersections[hook(22, i - 1)].dist;
  if (isec_count)
    (*res_dip) /= isec_count;

  return 1;
}

kernel void raycast_batch(int w, int h, global float* a_out_data, global float* out_dip,

                          global float* os, global float* cs, global float* dxs, global float* dys, global struct aabb* cl_aabb, global struct aabb* cut_aabbs, unsigned int cut_aabbs_count,

                          global struct BSPNode* nodes, global struct wald_tri* tris, global unsigned int* ids) {
  const int vIdx = get_global_id(0);
  const int batch = vIdx / (h * w);
  const int y = (vIdx - (batch * w * h)) / h;
  const int x = vIdx % w;
  int pos = 3 * batch;
  float4 dir = (float4)(cs[hook(5, pos)], cs[hook(5, pos + 1)], cs[hook(5, pos + 2)], 0.0f) + x * (float4)(dxs[hook(6, pos)], dxs[hook(6, pos + 1)], dxs[hook(6, pos + 2)], 0.0f) + y * (float4)(dys[hook(7, pos)], dys[hook(7, pos + 1)], dys[hook(7, pos + 2)], 0.0f) - (float4)(os[hook(4, pos)], os[hook(4, pos + 1)], os[hook(4, pos + 2)], 0.0f);
  dir = normalize(dir);
  struct Ray r;
  r.o = (float4)(os[hook(4, pos)], os[hook(4, pos + 1)], os[hook(4, pos + 2)], 0.0f);
  r.dir = dir;
  float res = 0.0f, res_dip = 0.0f;

  trace_tree(&r, &res, &res_dip, cl_aabb, cut_aabbs, cut_aabbs_count, nodes, tris, ids);

  a_out_data[hook(2, vIdx)] = res;
  out_dip[hook(3, vIdx)] = res_dip;
}