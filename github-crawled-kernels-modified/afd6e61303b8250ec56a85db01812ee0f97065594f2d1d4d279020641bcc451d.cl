//{"W":4,"W_inc1":7,"W_inc2":8,"W_internal_size1":11,"W_internal_size2":12,"W_size1":9,"W_size2":10,"W_start1":5,"W_start2":6,"errorVec":0,"lastDeltaVec":2,"sizeErr":1,"sizeLastDelta":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backpropagate_inner_1(global float* errorVec, uint4 sizeErr, global const float* lastDeltaVec, uint4 sizeLastDelta, global const float* W, unsigned int W_start1, unsigned int W_start2, unsigned int W_inc1, unsigned int W_inc2, unsigned int W_size1, unsigned int W_size2, unsigned int W_internal_size1, unsigned int W_internal_size2) {
  for (unsigned int row = get_global_id(0); row < W_size2 - 1; row += get_global_size(0)) {
    float dot_prod = 0;
    for (unsigned int col = 0; col < W_size1; ++col)
      dot_prod += W[hook(4, (row * W_inc2 + W_start2) + (col * W_inc1 + W_start1) * W_internal_size2)] * lastDeltaVec[hook(2, sizeLastDelta.x + sizeLastDelta.y * col)];
    errorVec[hook(0, row * sizeErr.y + sizeErr.x)] = dot_prod;
  }
}