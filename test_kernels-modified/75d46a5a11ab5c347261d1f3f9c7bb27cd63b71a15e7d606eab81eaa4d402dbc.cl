//{"deltaVec":4,"derivVec":2,"errorVec":0,"sizeDelta":5,"sizeDeriv":3,"sizeErr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropagate_inner_2(global float* errorVec, uint4 sizeErr, global const float* derivVec, uint4 sizeDeriv, global float* deltaVec, uint4 sizeDelta) {
  for (unsigned int i = get_global_id(0); i < sizeDelta.z; i += get_global_size(0))
    deltaVec[hook(4, i * sizeDelta.y + sizeDelta.x)] = derivVec[hook(2, i * sizeDeriv.y + sizeDeriv.x)] * errorVec[hook(0, i * sizeErr.y + sizeErr.x)];
}