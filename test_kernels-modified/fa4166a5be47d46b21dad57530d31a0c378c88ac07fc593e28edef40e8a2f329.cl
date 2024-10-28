//{"mod_input":0,"mod_output":1,"round_input":2,"round_output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mod_round(global float* mod_input, global float* mod_output, global float4* round_input, global float4* round_output) {
  mod_output[hook(1, 0)] = fmod(mod_input[hook(0, 0)], mod_input[hook(0, 1)]);
  mod_output[hook(1, 1)] = remainder(mod_input[hook(0, 0)], mod_input[hook(0, 1)]);

  round_output[hook(3, 0)] = rint(*round_input);
  round_output[hook(3, 1)] = round(*round_input);
  round_output[hook(3, 2)] = ceil(*round_input);
  round_output[hook(3, 3)] = floor(*round_input);
  round_output[hook(3, 4)] = trunc(*round_input);
}