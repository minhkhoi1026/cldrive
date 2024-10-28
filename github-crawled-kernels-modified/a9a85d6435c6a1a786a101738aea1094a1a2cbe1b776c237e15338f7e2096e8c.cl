//{"delta":0,"hRes":4,"magicNumber":3,"maxIter":2,"minimum":1,"outputi":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot(const float2 delta, const float2 minimum, const unsigned int maxIter, const unsigned int magicNumber, const unsigned int hRes, global int* outputi) {
  int2 id = (int2)(get_global_id(0), get_global_id(1));

  float2 pos = minimum + delta * (float2)(id.x, id.y);
  float2 squared = pos * pos;
  float2 val = pos;

  int iter = 0;
  while ((iter < maxIter) && ((squared.x + squared.y) < magicNumber)) {
    val.y = (2 * (val.x * val.y));
    val.x = squared.x - squared.y;
    val += pos;
    squared = val * val;

    iter++;
  }
  if (iter >= maxIter)
    iter = 0;

  outputi[hook(5, id.y * hRes + id.x)] = iter;
}