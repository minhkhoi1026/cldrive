//{"cu":9,"cv":10,"h":12,"pnew":8,"pold":5,"tdts8":0,"tdtsdx":1,"tdtsdy":2,"unew":6,"uold":3,"vnew":7,"vold":4,"z":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l200(double tdts8, double tdtsdx, double tdtsdy, global double* uold, global double* vold, global double* pold, global double* unew, global double* vnew, global double* pnew, global double* cu, global double* cv, global double* z, global double* h) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (y < 64 && x < 64) {
    unew[hook(6, (y + 1) * (64 + 1) + (x))] = uold[hook(3, (y + 1) * (64 + 1) + (x))] + tdts8 * (z[hook(11, (y + 1) * (64 + 1) + (x + 1))] + z[hook(11, (y + 1) * (64 + 1) + (x))]) * (cv[hook(10, (y + 1) * (64 + 1) + (x + 1))] + cv[hook(10, (y) * (64 + 1) + (x + 1))] + cv[hook(10, (y) * (64 + 1) + (x))] + cv[hook(10, (y + 1) * (64 + 1) + (x))]) - tdtsdx * (h[hook(12, (y + 1) * (64 + 1) + (x))] - h[hook(12, (y) * (64 + 1) + (x))]);
    vnew[hook(7, (y) * (64 + 1) + (x + 1))] = vold[hook(4, (y) * (64 + 1) + (x + 1))] - tdts8 * (z[hook(11, (y + 1) * (64 + 1) + (x + 1))] + z[hook(11, (y) * (64 + 1) + (x + 1))]) * (cu[hook(9, (y + 1) * (64 + 1) + (x + 1))] + cu[hook(9, (y) * (64 + 1) + (x + 1))] + cu[hook(9, (y) * (64 + 1) + (x))] + cu[hook(9, (y + 1) * (64 + 1) + (x))]) - tdtsdy * (h[hook(12, (y) * (64 + 1) + (x + 1))] - h[hook(12, (y) * (64 + 1) + (x))]);
    pnew[hook(8, (y) * (64 + 1) + (x))] = pold[hook(5, (y) * (64 + 1) + (x))] - tdtsdx * (cu[hook(9, (y + 1) * (64 + 1) + (x))] - cu[hook(9, (y) * (64 + 1) + (x))]) - tdtsdy * (cv[hook(10, (y) * (64 + 1) + (x + 1))] - cv[hook(10, (y) * (64 + 1) + (x))]);
  }
}