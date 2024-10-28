//{"gInput":0,"gOutput":1,"ishape0":8,"ishape1":9,"ishape2":10,"origin0":2,"origin1":3,"origin2":4,"oshape0":5,"oshape1":6,"oshape2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void extractSlice(const global float* gInput, global float* gOutput, int origin0, int origin1, int origin2, int oshape0, int oshape1, int oshape2, int ishape0, int ishape1, int ishape2) {
  int g0 = origin0 + (int)get_global_id(0) % oshape0;
  int g1 = origin1 + (int)(get_global_id(0) / oshape0) % oshape1;
  int g2 = origin2 + (int)(get_global_id(0) / (oshape0 * oshape1));
  int gid = g2 * ishape1 * ishape0 + g1 * ishape0 + g0;

  gOutput[hook(1, get_global_id(0))] = gInput[hook(0, gid)];
}