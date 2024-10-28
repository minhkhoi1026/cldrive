//{"delbound":9,"mhi":10,"mhi_cols":7,"mhi_offset":5,"mhi_rows":6,"mhi_step":4,"mhiptr":3,"silh":0,"silh_offset":2,"silh_step":1,"timestamp":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateMotionHistory(global const uchar* silh, int silh_step, int silh_offset, global uchar* mhiptr, int mhi_step, int mhi_offset, int mhi_rows, int mhi_cols, float timestamp, float delbound) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < mhi_cols && y < mhi_rows) {
    int silh_index = mad24(y, silh_step, silh_offset + x);
    int mhi_index = mad24(y, mhi_step, mhi_offset + x * (int)sizeof(float));

    silh += silh_index;
    global float* mhi = (global float*)(mhiptr + mhi_index);

    float val = mhi[hook(10, 0)];
    val = silh[hook(0, 0)] ? timestamp : val < delbound ? 0 : val;
    mhi[hook(10, 0)] = val;
  }
}