//{"channelMap":2,"currInputMap":3,"in":0,"inBlockLength":6,"num_input_blocks":7,"out":1,"outBlockLength":5,"prevInputMap":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdInterleaveFFTBlockMultiChan(global const float* in, global float* out, global const int* channelMap, global const int* currInputMap, global const int* prevInputMap, int outBlockLength, int inBlockLength, int num_input_blocks) {
  int glbl_id = get_global_id(0);
  int n = glbl_id / (outBlockLength / 2);
  int ch = channelMap[hook(2, n)];

  int currInput = currInputMap[hook(3, n)];
  int prevInput = prevInputMap[hook(4, n)];

  int i = glbl_id - n * (outBlockLength / 2);

  if (i < inBlockLength)
    out[hook(1, glbl_id * 2)] = in[hook(0, ch * inBlockLength * num_input_blocks + prevInput * inBlockLength + i)];
  else if (i < 2 * inBlockLength)
    out[hook(1, glbl_id * 2)] = in[hook(0, ch * inBlockLength * num_input_blocks + currInput * inBlockLength + i - inBlockLength)];
  else
    out[hook(1, glbl_id * 2)] = 0;

  out[hook(1, glbl_id * 2 + 1)] = 0;
}