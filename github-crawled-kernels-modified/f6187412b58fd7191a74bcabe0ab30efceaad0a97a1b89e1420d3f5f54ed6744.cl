//{"H":3,"W":2,"image_matrix":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarizza(global float* image_matrix, global float* output, int W, int H) {
  int row = get_global_id(0);
  int col = get_global_id(1);
  int rgb = get_global_id(2);

  if (image_matrix[hook(0, row * H + col + rgb * H * W)] < 0.5f)
    output[hook(1, row * H + col + rgb * H * W)] = 0.0f;
  else
    output[hook(1, row * H + col + rgb * H * W)] = 1.0f;
}