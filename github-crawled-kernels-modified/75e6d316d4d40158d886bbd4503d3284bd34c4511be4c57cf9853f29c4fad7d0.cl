//{"in_size":2,"input":1,"output":0,"p_in":3,"p_out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum(global int* restrict output, global int* restrict input, const unsigned int in_size) {
  local int p_in[512];
  local int p_out[512];
  int base = 0;
  int cnt = in_size / 512;

  for (int i = 0; i < cnt; i++) {
    for (int b = 0; b < 512; b++)
      p_in[hook(3, b)] = input[hook(1, i * 512 + b)];

    p_out[hook(4, 0)] = base;
    for (int b = 1; b < 512; b++)
      p_out[hook(4, b)] = p_out[hook(4, b - 1)] + p_in[hook(3, b - 1)];
    base = p_out[hook(4, 512 - 1)] + p_in[hook(3, 512 - 1)];

    for (int b = 0; b < 512; b++)
      output[hook(0, i * 512 + b)] = p_out[hook(4, b)];
  }
}