//{"A":0,"B":1,"C":2,"height":4,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mm(const global float* A, const global float* B, global float* C, unsigned int width, unsigned int height) {
  unsigned int row = get_global_id(1);
  unsigned int column = get_global_id(0);

  float tmp = 0.0f;
  for (unsigned int index = 0; index < width; ++index) {
    tmp += A[hook(0, row * width + index)] * B[hook(1, index * width + column)];
  }
  C[hook(2, row * width + column)] = tmp;
}