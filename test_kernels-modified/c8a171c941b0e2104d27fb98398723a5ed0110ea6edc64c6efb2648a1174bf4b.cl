//{"divImg":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divide_kernel3D_loginv_Ushort(global ushort* input, global ushort* divImg, global float* output) {
  const unsigned int idx = get_global_id(0);

  const float short_lim = log((float)65535);
  const float mu_in = short_lim - log((float)input[hook(0, idx)]);
  const float mu_div = short_lim - log((float)divImg[hook(1, idx)]);
  output[hook(2, idx)] = mu_in / mu_div;
}