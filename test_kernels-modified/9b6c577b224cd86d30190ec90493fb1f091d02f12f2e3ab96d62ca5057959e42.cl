//{"output":2,"set_one":0,"set_two":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Summer(global float* set_one, global float* set_two, global float* output) {
  unsigned int glid = get_global_id(0);

  output[hook(2, glid)] = set_one[hook(0, glid)] + set_two[hook(1, glid)];
}