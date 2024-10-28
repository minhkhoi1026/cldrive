//{"columns":1,"diagonal":2,"out":3,"rows":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void eye_f32(unsigned int rows, unsigned int columns, int diagonal, global float* out) {
  const unsigned int i = get_global_id(0);
  const unsigned int j = get_global_id(1);

  out[hook(3, columns * i + j)] = ((int)(j - i) == diagonal) ? 1.0f : 0.0f;
}