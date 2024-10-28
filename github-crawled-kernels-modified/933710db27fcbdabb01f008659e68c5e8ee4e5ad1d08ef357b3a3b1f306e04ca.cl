//{"channels":11,"computeNum":6,"global_size_dim0":0,"global_size_dim1":1,"global_size_dim2":2,"groupNum":10,"groupWorkSize":5,"input":3,"lastNum":7,"output":4,"reductSize":8,"workNum":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void reduct_1d(private const int global_size_dim0, private const int global_size_dim1, private const int global_size_dim2, read_only image2d_t input, write_only image2d_t output, private const int groupWorkSize, private const int computeNum, private const int lastNum, private const int reductSize, private const int workNum, private const int groupNum, private const int channels) {
  const int w = get_local_id(0);
  const int h = get_local_id(1);
  const int bg = get_global_id(2);
  const int width = get_local_size(0);
  const int index = mad24(h, width, w);
  const int b = bg / groupNum;
  const int group_index = mad24(b, -groupNum, bg);
  const int remain_channel = channels % 4;

  float4 in;
  float4 scale;
  int pos_x, pos_y;
  float4 tempResult = (float4){0, 0, 0, 0};
  float4 out = (float4){0, 0, 0, 0};

  const bool greater_last = (lastNum > 0 && index >= lastNum);
  const int actual_computeNum = select(computeNum, computeNum - 1, greater_last);
  if (actual_computeNum == 0)
    return;
  const int base_offset = mul24(index, actual_computeNum);
  const int offset = select(base_offset, base_offset + lastNum, greater_last);
  scale = (float4)(1.f / reductSize);

  for (int i = 0; i < actual_computeNum; ++i) {
    int element_idx = offset + i;
    for (int j = 0; j < reductSize; j++) {
      tempResult = tempResult + in;
    }

    tempResult = tempResult * scale;

    out = tempResult;
  }
}