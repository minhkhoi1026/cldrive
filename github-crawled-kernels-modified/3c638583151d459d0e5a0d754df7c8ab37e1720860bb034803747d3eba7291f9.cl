//{"exponent":1,"grid":0,"num_elements":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void power(global float* grid, const float exponent, int const num_elements) {
  int global_id = get_global_id(0);

  if (global_id >= num_elements)
    return;

  grid[hook(0, global_id)] = pow(grid[hook(0, global_id)], exponent);
}