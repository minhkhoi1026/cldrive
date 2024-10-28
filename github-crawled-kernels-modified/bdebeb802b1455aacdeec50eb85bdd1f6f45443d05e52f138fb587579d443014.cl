//{"evt":0,"iop":3,"iscript":2,"nrg":6,"script":1,"step":4,"vm":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampleKernel(global int* evt, global const int* script, global int* iscript, global int* iop, global int* step, global char* vm, global int* nrg) {
  int idx = get_global_id(0);
  int lstep = step[hook(4, 0)];

  if (evt[hook(0, idx)] == 0) {
    evt[hook(0, idx)] = script[hook(1, idx * lstep * 2 + iscript[ihook(2, idx) * 2)];
    iop[hook(3, idx)] = script[hook(1, idx * lstep * 2 + iscript[ihook(2, idx) * 2 + 1)];
    iscript[hook(2, idx)] = (iscript[hook(2, idx)] + 1) % lstep;
  }

  if (nrg[hook(6, idx)] <= 0) {
    evt[hook(0, idx)] = 9999999;
    vm[hook(5, idx)] = 1;
  }
}