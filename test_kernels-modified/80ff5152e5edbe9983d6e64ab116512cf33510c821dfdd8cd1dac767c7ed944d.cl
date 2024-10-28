//{"input":0,"inputDimension":1,"subImg":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtract_kernel2D(global float* input, uint4 inputDimension, global float* subImg) {
  const unsigned int idx = get_global_id(0);

  const unsigned int w = idx % (inputDimension.x * inputDimension.y);

  const float out_val = input[hook(0, idx)] - subImg[hook(2, w)];

  input[hook(0, idx)] = out_val;
}