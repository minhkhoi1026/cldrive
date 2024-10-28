//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int G1 = 0;
constant int G2 = 0;
int G3 = 0;
global int G4 = 0;
kernel void bar() {
}