//{"grid":0,"num_elements":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divideBySaveVal(global float* grid, const float value, int const num_elements) {
  int global_id = get_global_id(0);

  if (global_id >= num_elements)
    return;
  if (isnan(grid[hook(0, global_id)]) || isnan(grid[hook(0, global_id)]))
    grid[hook(0, global_id)] = 0;
  else
    grid[hook(0, global_id)] /= value;
}