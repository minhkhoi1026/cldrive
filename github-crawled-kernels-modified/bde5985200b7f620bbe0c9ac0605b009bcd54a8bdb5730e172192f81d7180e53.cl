//{"round_input":0,"round_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rounding(global float4* round_input, global float4* round_output) {
  round_output[hook(1, 0)] = rint(*round_input);
  round_output[hook(1, 1)] = round(*round_input);
  round_output[hook(1, 2)] = ceil(*round_input);
  round_output[hook(1, 3)] = floor(*round_input);
  round_output[hook(1, 4)] = trunc(*round_input);
}