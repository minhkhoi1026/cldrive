//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int sz0 = 5;
const global int sz1 = 16;
const constant int sz2 = 8;
kernel void testvla() {
  int vla0[sz0];

  char vla1[sz1];

  local short vla2[sz2];
}