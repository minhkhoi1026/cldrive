//{"dim":27,"groups_dim":25,"groups_x":23,"groups_y":24,"iData":18,"ids":30,"init":28,"isFinalPass":29,"istride0":19,"istride1":20,"istride2":21,"istride3":22,"istrides":33,"l_tmp":34,"l_val":35,"lim":26,"oData":0,"odim0":1,"odim1":2,"odim2":3,"odim3":4,"odims":31,"ostride0":5,"ostride1":6,"ostride2":7,"ostride3":8,"ostrides":32,"tData":9,"tdim0":10,"tdim1":11,"tdim2":12,"tdim3":13,"tdims":36,"tstride0":14,"tstride1":15,"tstride2":16,"tstride3":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float bin_ADD_OP(float lhs, float rhs) {
  return lhs + rhs;
}

float transform_ADD_OP(float in) {
  return (float)(in);
}

float bin_MUL_OP(float lhs, float rhs) {
  return lhs * rhs;
}

float transform_MUL_OP(float in) {
  return (float)(in);
}

float bin_SUB_OP(float lhs, float rhs) {
  return lhs - rhs;
}

float transform_SUB_OP(float in) {
  return (float)(in);
}

float bin_DIV_OP(float lhs, float rhs) {
  return lhs / rhs;
}

float transform_DIV_OP(float in) {
  return (float)(in);
}

float bin_MIN_OP(float lhs, float rhs) {
  return lhs < rhs ? lhs : rhs;
}

float transform_MIN_OP(float in) {
  return in;
}

float bin_MAX_OP(float lhs, float rhs) {
  return lhs > rhs ? lhs : rhs;
}

float transform_MAX_OP(float in) {
  return in;
}

float bin_NOTZERO_OP(float lhs, float rhs) {
  return lhs + rhs;
}

float transform_NOTZERO_OP(float in) {
  return (in != 0);
}

float bin_EQ_OP(float lhs, float rhs) {
  return lhs == rhs;
}

float transform_EQ_OP(float in) {
  return (float)(in);
}

float bin_NE_OP(float lhs, float rhs) {
  return lhs != rhs;
}

float transform_NE_OP(float in) {
  return (float)(in);
}

float bin_GT_OP(float lhs, float rhs) {
  return lhs > rhs;
}

float transform_GT_OP(float in) {
  return (float)(in);
}

float bin_GE_OP(float lhs, float rhs) {
  return lhs >= rhs;
}

float transform_GE_OP(float in) {
  return (float)(in);
}

float bin_LT_OP(float lhs, float rhs) {
  return lhs < rhs;
}

float transform_LT_OP(float in) {
  return (float)(in);
}

float bin_LE_OP(float lhs, float rhs) {
  return lhs <= rhs;
}

float transform_LE_OP(float in) {
  return (float)(in);
}
kernel void scan_dim_kernel_ADD_OP(global float* oData, const int odim0, const int odim1, const int odim2, const int odim3, const int ostride0, const int ostride1, const int ostride2, const int ostride3, global float* tData, const int tdim0, const int tdim1, const int tdim2, const int tdim3, const int tstride0, const int tstride1, const int tstride2, const int tstride3, const global float* iData, const int istride0, const int istride1, const int istride2, const int istride3, unsigned int groups_x, unsigned int groups_y, unsigned int groups_dim, unsigned int lim, const int dim, const float init, const int isFinalPass) {
  const int lidx = get_local_id(0);
  const int lidy = get_local_id(1);
  const int lid = lidy * 128 + lidx;
  const int zid = get_group_id(0) / groups_x;
  const int wid = get_group_id(1) / groups_y;
  const int groupId_x = get_group_id(0) - (groups_x)*zid;
  const int groupId_y = get_group_id(1) - (groups_y)*wid;
  const int xid = groupId_x * get_local_size(0) + lidx;
  const int yid = groupId_y;
  int ids[4] = {xid, yid, zid, wid};
  int odims[4] = {odim0, odim1, odim2, odim3};
  int tdims[4] = {tdim0, tdim1, tdim2, tdim3};
  int ostrides[4] = {ostride0, ostride1, ostride2, ostride3};
  int istrides[4] = {istride0, istride1, istride2, istride3};
  tData += ids[hook(30, 3)] * tstride3 + ids[hook(30, 2)] * tstride2 + ids[hook(30, 1)] * tstride1 + ids[hook(30, 0)];
  const int groupId_dim = ids[hook(30, dim)];
  ids[hook(30, dim)] = ids[hook(30, dim)] * 64 * lim + lidy;
  oData += ids[hook(30, 3)] * ostride3 + ids[hook(30, 2)] * ostride2 + ids[hook(30, 1)] * ostride1 + ids[hook(30, 0)];
  iData += ids[hook(30, 3)] * istride3 + ids[hook(30, 2)] * istride2 + ids[hook(30, 1)] * istride1 + ids[hook(30, 0)];
  int id_dim = ids[hook(30, dim)];
  const int out_dim = odims[hook(31, dim)];
  bool is_valid = (ids[hook(30, 0)] < odim0);
  is_valid &= (ids[hook(30, 1)] < odim1);
  is_valid &= (ids[hook(30, 2)] < odim2);
  is_valid &= (ids[hook(30, 3)] < odim3);
  const int ostride_dim = ostrides[hook(32, dim)];
  const int istride_dim = istrides[hook(33, dim)];
  local float l_val0[128 * 64];
  local float l_val1[128 * 64];
  local float* l_val = l_val0;
  local float l_tmp[128];
  bool flip = 0;
  const float init_val = init;
  float val = init_val;
  const bool isLast = (lidy == (64 - 1));
  for (int k = 0; k < lim; k++) {
    if (isLast)
      l_tmp[hook(34, lidx)] = val;
    bool cond = (is_valid);
    cond &= (id_dim < out_dim);
    val = cond ? transform_ADD_OP(*iData) : init_val;
    l_val[hook(35, lid)] = val;
    barrier(0x01);
    int start = 0;
    for (int off = 1; off < 64; off *= 2) {
      if (lidy >= off)
        val = bin_ADD_OP(val, l_val[hook(35, lid - off * 128)]);
      flip = 1 - flip;
      l_val = flip ? l_val1 : l_val0;
      l_val[hook(35, lid)] = val;
      barrier(0x01);
    }
    val = bin_ADD_OP(val, l_tmp[hook(34, lidx)]);
    if (cond)
      *oData = val;
    barrier(0x01);
    id_dim += 64;
    iData += 64 * istride_dim;
    oData += 64 * ostride_dim;
  }
  if (!isFinalPass && is_valid && (groupId_dim < tdims[hook(36, dim)]) && isLast) {
    *tData = val;
  }
}