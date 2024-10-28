//{"atomOrder":3,"innerInvAtomOrder":7,"innerPosq":4,"innerPosqCorrection":5,"innerVelm":6,"numAtoms":8,"posq":0,"posqCorrection":1,"velm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyState(global float4* posq, global float4* posqCorrection, global float4* velm, global int* restrict atomOrder, global float4* innerPosq, global float4* innerPosqCorrection, global float4* innerVelm, global int* restrict innerInvAtomOrder, int numAtoms) {
  for (int i = get_global_id(0); i < numAtoms; i += get_global_size(0)) {
    int index = innerInvAtomOrder[hook(7, atomOrder[ihook(3, i))];
    innerPosq[hook(4, index)] = posq[hook(0, i)];
    innerVelm[hook(6, index)] = velm[hook(2, i)];
  }
}