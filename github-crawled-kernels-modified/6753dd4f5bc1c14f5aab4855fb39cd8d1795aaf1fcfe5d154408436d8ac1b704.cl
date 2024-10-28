//{"d_rows":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transMatrix(global float* input, global float* output, global int* d_rows) {
  unsigned int xIndex = get_global_id(0);
  unsigned int yIndex = get_global_id(1);

  if (xIndex < (*d_rows) && yIndex < (*d_rows)) {
    unsigned int index_in = xIndex + (*d_rows) * yIndex;
    unsigned int index_out = yIndex + (*d_rows) * xIndex;
    output[hook(1, index_out)] = input[hook(0, index_in)];
  }
}