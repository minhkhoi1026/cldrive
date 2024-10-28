//{"M":0,"V":1,"W":4,"height":3,"row":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatVecMulUncoalesced0(const global float* M, const global float* V, unsigned int width, unsigned int height, global float* W) {
  unsigned int y = get_global_id(0);
  if (y < height) {
    const global float* row = M + y * width;

    float dotProduct = 0;
    for (int x = 0; x < width; ++x)
      dotProduct += row[hook(5, x)] * V[hook(1, x)];

    W[hook(4, y)] = dotProduct;
  }
}