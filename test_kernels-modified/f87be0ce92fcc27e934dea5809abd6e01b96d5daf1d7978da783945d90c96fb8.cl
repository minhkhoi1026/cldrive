//{"forces":0,"innerAtomOrder":3,"innerForces":2,"invAtomOrder":1,"numAtoms":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyForces(global float4* forces, global int* restrict invAtomOrder, global float4* innerForces, global int* restrict innerAtomOrder, int numAtoms) {
  for (int i = get_global_id(0); i < numAtoms; i += get_global_size(0)) {
    int index = invAtomOrder[hook(1, innerAtomOrder[ihook(3, i))];
    forces[hook(0, index)] = innerForces[hook(2, i)];
  }
}