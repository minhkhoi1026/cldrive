//{"blockmat":6,"blockperm":7,"inperm":4,"invect":0,"nbcol":2,"nbrow":3,"outperm":5,"outvect":1,"tilesize":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(const global int* invect, global int* outvect, const int nbcol, const int nbrow, const global int* inperm, global int* outperm, local int* blockmat, local int* blockperm, const int tilesize) {
  int i0 = get_global_id(0) * tilesize;
  int j = get_global_id(1);

  int jloc = get_local_id(1);

  for (int iloc = 0; iloc < tilesize; iloc++) {
    int k = (i0 + iloc) * nbcol + j;
    blockmat[hook(6, iloc * tilesize + jloc)] = invect[hook(0, k)];
  }

  barrier(0x01);

  int j0 = get_group_id(1) * tilesize;

  for (int iloc = 0; iloc < tilesize; iloc++) {
    int kt = (j0 + iloc) * nbrow + i0 + jloc;
    outvect[hook(1, kt)] = blockmat[hook(6, jloc * tilesize + iloc)];
  }
}