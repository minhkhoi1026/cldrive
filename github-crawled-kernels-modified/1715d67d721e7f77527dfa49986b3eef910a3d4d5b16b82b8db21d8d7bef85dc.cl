//{"pMaps":0,"pOffset":2,"pOutput":3,"pScale":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_work_group_size(1000))) kernel void batch_norm_layer(global float* pMaps, global float* pScale, global float* pOffset, global float* pOutput) {
  const int map_no = get_global_id(2);
  const int row_no = get_global_id(1);
  const int col_no = get_global_id(0);
  const int W = get_global_size(0);
  const int H = get_global_size(1);
  float norm_pix;
  const int pos = map_no * W * H + row_no * W + col_no;
  norm_pix = pMaps[hook(0, pos)] * pScale[hook(1, map_no)] + pOffset[hook(2, map_no)];
  pOutput[hook(3, pos)] = norm_pix;
}