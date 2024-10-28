//{"_localLuminanceAddon":6,"_localLuminanceFactor":7,"_maxInputValue":8,"cols":3,"elements_per_row":5,"input":1,"luma":0,"output":2,"rows":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void localLuminanceAdaptation(global const float* luma, global const float* input, global float* output, const int cols, const int rows, const int elements_per_row, const float _localLuminanceAddon, const float _localLuminanceFactor, const float _maxInputValue) {
  int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  int offset = mad24(gidy, elements_per_row, gidx);
  float4 luma_vec = vload4(0, luma + offset);
  float4 X0 = luma_vec * _localLuminanceFactor + _localLuminanceAddon;
  float4 input_val = vload4(0, input + offset);

  float4 out_vec = (_maxInputValue + X0) * input_val / (input_val + X0 + 0.00000000001f);
  vstore4(out_vec, 0, output + offset);
}