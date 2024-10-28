//{"mat":0,"res":2,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matVecMult(constant float4* mat, constant float4* vec, global float* res) {
  int row = get_global_id(0);
  int vecPerRow = get_global_size(0) / 4;

  float sum = 0.0f;
  for (int i = 0; i < vecPerRow; ++i)
    sum += dot(mat[hook(0, row * vecPerRow + i)], vec[hook(1, i)]);

  res[hook(2, row)] = sum;
}