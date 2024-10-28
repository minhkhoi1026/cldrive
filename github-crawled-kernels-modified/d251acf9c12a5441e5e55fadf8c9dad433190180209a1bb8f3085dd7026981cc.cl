//{"complex_data":0,"ixoff":2,"iyoff":3,"trans_nx":4,"trans_ny":5,"transmission_function":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transmit(global float2* complex_data, global float2* transmission_function, int ixoff, int iyoff, int trans_nx, int trans_ny) {
  int ix = get_global_id(0);
  int iy = get_global_id(1);
  int index = iy * get_global_size(0) + ix;
  int ixt, iyt;

  ixt = ix + ixoff;
  if (ixt >= trans_nx) {
    ixt = ixt - trans_nx;
  } else if (ixt < 0) {
    ixt = ixt + trans_nx;
  }

  iyt = iy + iyoff;
  if (iyt >= trans_ny) {
    iyt = iyt - trans_ny;
  } else if (iyt < 0) {
    iyt = iyt + trans_ny;
  }

  size_t index_trans = iyt * trans_nx + ixt;
  float2 pr = complex_data[hook(0, index)];
  float2 tr = transmission_function[hook(1, index_trans)];
  pr.s0 = pr.s0 * tr.s0 - pr.s1 * tr.s1;
  pr.s1 = pr.s0 * tr.s1 + pr.s1 * tr.s0;
  complex_data[hook(0, index)] = pr;
}