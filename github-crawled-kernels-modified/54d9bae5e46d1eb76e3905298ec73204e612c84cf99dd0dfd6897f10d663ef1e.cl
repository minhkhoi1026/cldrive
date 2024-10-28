//{"dim":18,"groups_dim":16,"groups_x":14,"groups_y":15,"ids":19,"lim":17,"oData":0,"odim0":1,"odim1":2,"odim2":3,"odim3":4,"odims":20,"ostride0":5,"ostride1":6,"ostride2":7,"ostride3":8,"ostrides":22,"tData":9,"tstride0":10,"tstride1":11,"tstride2":12,"tstride3":13,"tstrides":21}
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
kernel void bcast_dim_kernel_ADD_OP(global float* oData, const int odim0, const int odim1, const int odim2, const int odim3, const int ostride0, const int ostride1, const int ostride2, const int ostride3, const global float* tData, const int tstride0, const int tstride1, const int tstride2, const int tstride3, unsigned int groups_x, unsigned int groups_y, unsigned int groups_dim, unsigned int lim, int dim) {
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
  int ostrides[4] = {ostride0, ostride1, ostride2, ostride3};
  int tstrides[4] = {tstride0, tstride1, tstride2, tstride3};
  const int groupId_dim = ids[hook(19, dim)];
  if (groupId_dim == 0)
    return;
  tData += ids[hook(19, 3)] * tstride3 + ids[hook(19, 2)] * tstride2 + ids[hook(19, 1)] * tstride1 + ids[hook(19, 0)];
  ids[hook(19, dim)] = ids[hook(19, dim)] * 64 * lim + lidy;
  oData += ids[hook(19, 3)] * ostride3 + ids[hook(19, 2)] * ostride2 + ids[hook(19, 1)] * ostride1 + ids[hook(19, 0)];
  const int id_dim = ids[hook(19, dim)];
  const int out_dim = odims[hook(20, dim)];
  bool is_valid = (ids[hook(19, 0)] < odim0);
  is_valid &= (ids[hook(19, 1)] < odim1);
  is_valid &= (ids[hook(19, 2)] < odim2);
  is_valid &= (ids[hook(19, 3)] < odim3);
  if (!is_valid)
    return;
  float accum = *(tData - tstrides[hook(21, dim)]);
  const int ostride_dim = ostrides[hook(22, dim)];
  for (int k = 0, id = id_dim; is_valid && k < lim && (id < out_dim); k++, id += 64) {
    *oData = bin_ADD_OP(*oData, accum);
    oData += 64 * ostride_dim;
  }
}