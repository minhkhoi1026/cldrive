//{"groups_x":16,"groups_y":17,"lim":18,"oData":0,"odim0":1,"odim1":2,"odim2":3,"odim3":4,"ooffset":9,"ostride0":5,"ostride1":6,"ostride2":7,"ostride3":8,"tData":10,"toffset":15,"tstride0":11,"tstride1":12,"tstride2":13,"tstride3":14}
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
kernel void bcast_first_kernel_ADD_OP(global float* oData, const int odim0, const int odim1, const int odim2, const int odim3, const int ostride0, const int ostride1, const int ostride2, const int ostride3, const int ooffset, const global float* tData, const int tstride0, const int tstride1, const int tstride2, const int tstride3, const int toffset, unsigned int groups_x, unsigned int groups_y, unsigned int lim) {
  const int lidx = get_local_id(0);
  const int lidy = get_local_id(1);
  const int lid = lidy * get_local_size(0) + lidx;
  const int zid = get_group_id(0) / groups_x;
  const int wid = get_group_id(1) / groups_y;
  const int groupId_x = get_group_id(0) - (groups_x)*zid;
  const int groupId_y = get_group_id(1) - (groups_y)*wid;
  const int xid = groupId_x * get_local_size(0) * lim + lidx;
  const int yid = groupId_y * get_local_size(1) + lidy;
  if (groupId_x != 0) {
    bool cond = (yid < odim1);
    cond &= (zid < odim2);
    cond &= (wid < odim3);
    if (cond) {
      tData += wid * tstride3 + zid * tstride2 + yid * tstride1 + toffset;
      oData += wid * ostride3 + zid * ostride2 + yid * ostride1 + ooffset;
      float accum = tData[hook(10, groupId_x - 1)];
      for (int k = 0, id = xid; k < lim && id < odim0; k++, id += 128) {
        oData[hook(0, id)] = bin_ADD_OP(accum, oData[hook(0, id)]);
      }
    }
  }
}