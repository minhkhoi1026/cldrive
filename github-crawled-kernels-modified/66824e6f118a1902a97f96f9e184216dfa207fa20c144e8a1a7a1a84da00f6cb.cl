//{"G":8,"G_inc1":11,"G_inc2":12,"G_internal_size1":15,"G_internal_size2":16,"G_size1":13,"G_size2":14,"G_start1":9,"G_start2":10,"actVec":4,"deltaVec":6,"derivVec":2,"errorVec":0,"sizeAct":5,"sizeDelta":7,"sizeDeriv":3,"sizeErr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropagate_last(global const float* errorVec, uint4 sizeErr, global const float* derivVec, uint4 sizeDeriv, global const float* actVec, uint4 sizeAct, global float* deltaVec, uint4 sizeDelta, global float* G, unsigned int G_start1, unsigned int G_start2, unsigned int G_inc1, unsigned int G_inc2, unsigned int G_size1, unsigned int G_size2, unsigned int G_internal_size1, unsigned int G_internal_size2) {
  for (unsigned int i = get_global_id(0); i < sizeDelta.z; i += get_global_size(0))
    deltaVec[hook(6, i * sizeDelta.y + sizeDelta.x)] = derivVec[hook(2, i * sizeDeriv.y + sizeDeriv.x)] * errorVec[hook(0, i * sizeErr.y + sizeErr.x)];

  barrier(0x02);

  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < G_size1; row += get_num_groups(0)) {
    float tmp = deltaVec[hook(6, row * sizeDelta.y + sizeDelta.x)];
    for (unsigned int col = col_gid; col < G_size2; col += get_local_size(0))
      G[hook(8, (row * G_inc1 + G_start1) * G_internal_size2 + col * G_inc2 + G_start2)] -= tmp * (col < sizeAct.z ? actVec[hook(4, col * sizeAct.y + sizeAct.x)] : 1.0f);
  }
}