//{"_BITS":7,"_RADIX":6,"cells":1,"histograms":2,"local_histograms":4,"numKeys":5,"pass":3,"radixCells":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reorder(const global uint2* radixCells, global uint2* cells, global unsigned int* histograms, const unsigned int pass, local unsigned int* local_histograms, const unsigned int numKeys, const unsigned int _RADIX, const unsigned int _BITS) {
  int it = get_local_id(0);
  int ig = get_global_id(0);

  int gr = get_group_id(0);
  int groups = get_num_groups(0);
  int items = get_local_size(0);

  int start = ig * (numKeys / groups / items);
  int size = numKeys / groups / items;

  for (int ir = 0; ir < _RADIX; ir++) {
    local_histograms[hook(4, ir * items + it)] = histograms[hook(2, items * (ir * groups + gr) + it)];
  }

  barrier(0x01);

  int newpos, key, shortkey, k, newpost;

  for (int j = 0; j < size; j++) {
    k = j + start;
    key = radixCells[hook(0, k)].x;

    shortkey = ((key >> (pass * _BITS)) & (_RADIX - 1));

    newpost = local_histograms[hook(4, shortkey * items + it)];

    cells[hook(1, newpost)] = radixCells[hook(0, k)];

    newpos++;
    local_histograms[hook(4, shortkey * items + it)] = newpos;
  }
}