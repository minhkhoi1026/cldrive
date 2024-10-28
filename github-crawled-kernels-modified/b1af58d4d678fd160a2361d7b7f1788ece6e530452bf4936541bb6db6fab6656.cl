//{"groups_x":20,"groups_y":21,"iData":15,"istride0":16,"istride1":17,"istride2":18,"istride3":19,"lim":22,"oData":0,"otData":1,"otdim0":2,"otdim1":3,"otdim2":4,"otdim3":5,"otstride0":6,"otstride1":7,"otstride2":8,"otstride3":9,"rtData":10,"rtstride0":11,"rtstride1":12,"rtstride2":13,"rtstride3":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_out_idx_kernel(global float* oData, global float* otData, const int otdim0, const int otdim1, const int otdim2, const int otdim3, const int otstride0, const int otstride1, const int otstride2, const int otstride3, global float* rtData, const int rtstride0, const int rtstride1, const int rtstride2, const int rtstride3, global float* iData, const int istride0, const int istride1, const int istride2, const int istride3, unsigned int groups_x, unsigned int groups_y, unsigned int lim) {
  const unsigned int lidx = get_local_id(0);
  const unsigned int lidy = get_local_id(1);

  const unsigned int zid = get_group_id(0) / groups_x;
  const unsigned int wid = get_group_id(1) / groups_y;
  const unsigned int groupId_x = get_group_id(0) - (groups_x)*zid;
  const unsigned int groupId_y = get_group_id(1) - (groups_y)*wid;
  const unsigned int xid = groupId_x * get_local_size(0) * lim + lidx;
  const unsigned int yid = groupId_y * get_local_size(1) + lidy;

  const unsigned int off = wid * otstride3 + zid * otstride2 + yid * otstride1;
  const unsigned int gid = wid * rtstride3 + zid * rtstride2 + yid * rtstride1 + groupId_x;

  otData += wid * otstride3 + zid * otstride2 + yid * otstride1;
  iData += wid * istride3 + zid * istride2 + yid * istride1;

  bool cond = (yid < otdim1) && (zid < otdim2) && (wid < otdim3);
  if (!cond)
    return;

  unsigned int accum = (gid == 0) ? 0 : rtData[hook(10, gid - 1)];

  for (unsigned int k = 0, id = xid; k < lim && id < otdim0; k++, id += get_local_size(0)) {
    unsigned int idx = otData[hook(1, id)] + accum;
    float ival = iData[hook(15, id)];
    if (!((ival == 0)))
      oData[hook(0, idx - 1)] = (off + id);
  }
}