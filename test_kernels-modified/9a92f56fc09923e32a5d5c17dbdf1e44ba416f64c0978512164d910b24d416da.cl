//{"G":4,"G_inc1":7,"G_inc2":8,"G_internal_size1":11,"G_internal_size2":12,"G_size1":9,"G_size2":10,"G_start1":5,"G_start2":6,"actVec":0,"deltaVec":2,"sizeAct":1,"sizeDelta":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropagate_inner_3(global const float* actVec, uint4 sizeAct, global float* deltaVec, uint4 sizeDelta, global float* G, unsigned int G_start1, unsigned int G_start2, unsigned int G_inc1, unsigned int G_inc2, unsigned int G_size1, unsigned int G_size2, unsigned int G_internal_size1, unsigned int G_internal_size2) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < G_size1; row += get_num_groups(0)) {
    float tmp = deltaVec[hook(2, row * sizeDelta.y + sizeDelta.x)];
    for (unsigned int col = col_gid; col < G_size2; col += get_local_size(0)) {
      G[hook(4, (row * G_inc1 + G_start1) * G_internal_size2 + col * G_inc2 + G_start2)] -= tmp * (col < sizeAct.z ? actVec[hook(0, col * sizeAct.y + sizeAct.x)] : 1.0f);
    }
  }
}