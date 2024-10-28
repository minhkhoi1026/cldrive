//{"mat":0,"pass":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floydWarshallPass_hard_float(global float* mat, unsigned pass) {
  unsigned i = get_global_id(0);
  unsigned j = get_global_id(1);
  unsigned size = get_global_size(0);

  float oldWeight = mat[hook(0, j * size + i)];
  float tempWeight = (mat[hook(0, j * size + pass)] + mat[hook(0, pass * size + i)]);

  if (tempWeight < oldWeight)
    mat[hook(0, j * size + i)] = tempWeight;
}