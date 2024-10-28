//{"_BITS":6,"_RADIX":5,"histograms":1,"local_histograms":3,"numKeys":4,"pass":2,"radixCells":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(const global uint2* radixCells, global unsigned int* histograms, const unsigned int pass, local unsigned int* local_histograms, const unsigned int numKeys, const unsigned int _RADIX, const unsigned int _BITS) {
  int it = get_local_id(0);
  int ig = get_global_id(0);

  int gr = get_group_id(0);

  int groups = get_num_groups(0);
  int items = get_local_size(0);

  for (int ir = 0; ir < _RADIX; ir++) {
    local_histograms[hook(3, ir * items + it)] = 0;
  }

  barrier(0x01);

  int size = numKeys / groups / items;
  int start = ig * size;

  int key = 0, shortkey = 0, k = 0;

  for (int j = 0; j < size; j++) {
    k = j + start;
    key = radixCells[hook(0, k)].x;

    shortkey = ((key >> (pass * _BITS)) & (_RADIX - 1));

    local_histograms[hook(3, shortkey * items + it)]++;
  }

  barrier(0x01);

  for (int ir = 0; ir < _RADIX; ir++) {
    histograms[hook(1, items * (ir * groups + gr) + it)] = local_histograms[hook(3, ir * items + it)];
  }

  barrier(0x02);
}