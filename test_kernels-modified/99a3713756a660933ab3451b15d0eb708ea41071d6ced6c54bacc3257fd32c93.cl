//{"atomOrder":2,"charges":0,"numAtoms":3,"posq":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setCharges(global float* restrict charges, global float4* restrict posq, global int* restrict atomOrder, int numAtoms) {
  for (int i = get_global_id(0); i < numAtoms; i += get_global_size(0))
    posq[hook(1, i)].w = charges[hook(0, atomOrder[ihook(2, i))];
}