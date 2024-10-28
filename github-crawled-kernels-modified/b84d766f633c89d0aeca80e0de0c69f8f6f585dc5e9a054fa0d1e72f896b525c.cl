//{"<recovery-expr>(filters)":9,"<recovery-expr>(filters)[z].weights":8,"Image":7,"a":6,"deltas":1,"featMap":0,"featmapdim":3,"filterdim":5,"filters":2,"imagedim":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropcnn(global float* featMap, global float* deltas, global Filter* filters, int featmapdim, int imagedim, int filterdim, float a, global float* Image) {
  const int xIn = get_global_id(0);
  const int yIn = get_global_id(1);
  const int z = get_global_id(2);

  float sum = 0;
  for (int r = 0; r < featmapdim; r++) {
    for (int c = 0; c < featmapdim; c++) {
      sum += deltas[hook(1, (c + r * featmapdim + z * featmapdim * featmapdim))] * Image[hook(7, (xIn + r) + imagedim * (yIn + c))];
    }
  }

  filters[hook(9, z)].weights[hook(8, (xIn + filterdim * yIn))] -= a * sum;
}