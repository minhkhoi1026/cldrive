//{"height":3,"mtA":0,"mtB":1,"mtC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Multiply(global float* mtA, global float* mtB, global float* mtC, const unsigned int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float sum = 0;
  for (unsigned int k = 0; k < height; ++k)
    sum += mtA[hook(0, y * height + k)] * mtB[hook(1, k * height + x)];

  mtC[hook(2, y * height + x)] = sum;
}