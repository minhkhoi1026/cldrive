//{"M":4,"icolidx":3,"irowidx":2,"ocolidx":1,"orowidx":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csr2coo(global int* orowidx, global int* ocolidx, global const int* irowidx, global const int* icolidx, const int M) {
  int lid = get_local_id(0);
  for (int rowId = get_group_id(0); rowId < M; rowId += get_num_groups(0)) {
    int colStart = irowidx[hook(2, rowId)];
    int colEnd = irowidx[hook(2, rowId + 1)];
    for (int colId = colStart + lid; colId < colEnd; colId += get_local_size(0)) {
      orowidx[hook(0, colId)] = rowId;
      ocolidx[hook(1, colId)] = icolidx[hook(3, colId)];
    }
  }
}