//{"corner_response_alpha":5,"output":3,"sigmaD":4,"xx":0,"xy":1,"yy":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void harris_corner_response(global float* xx, global float* xy, global float* yy, global float* output, float sigmaD, float corner_response_alpha) {
  int i = get_global_id(0);
  float A = xx[hook(0, i)] * pow(sigmaD, 2);
  float B = yy[hook(2, i)] * pow(sigmaD, 2);
  float C = xy[hook(1, i)] * pow(sigmaD, 2);

  output[hook(3, i)] = A * B - C * C - corner_response_alpha * pow(A + B, 2);
}