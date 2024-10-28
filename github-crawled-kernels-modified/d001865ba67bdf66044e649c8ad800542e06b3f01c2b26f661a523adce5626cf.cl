//{"gridA":0,"gridB":1,"num_elements":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtractBySave(global float* gridA, global const float* gridB, int const num_elements) {
  int global_id = get_global_id(0);

  if (global_id >= num_elements)
    return;

  if (isnan(gridA[hook(0, global_id)]) || isnan(gridB[hook(1, global_id)]) || isinf(gridA[hook(0, global_id)]) || isinf(gridB[hook(1, global_id)]))
    gridA[hook(0, global_id)] = 0;
  else
    gridA[hook(0, global_id)] -= gridB[hook(1, global_id)];
}