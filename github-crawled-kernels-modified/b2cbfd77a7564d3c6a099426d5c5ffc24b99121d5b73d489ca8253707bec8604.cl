//{"block_sz":7,"channels_map":2,"in":0,"in_channel_stride":5,"ir":1,"ir_channel_stride":6,"num_blocks":4,"num_channels":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partitionIR(global float* in, global float* ir, global const int* channels_map, int num_channels, int num_blocks, int in_channel_stride, int ir_channel_stride, int block_sz) {
  int sampleId = get_global_id(0);
  int blockId = get_global_id(1);
  int chId = channels_map[hook(2, get_global_id(2))];
  if (blockId >= num_blocks)
    return;
  if (sampleId >= block_sz)
    return;
  int in_channel_offset = in_channel_stride * chId;
  int ir_channel_offset = ir_channel_stride * chId;
  int block_offset = blockId * block_sz;
  int ir_block_offset = block_offset * 2;
  int in_block_offset = block_offset;
  ir[hook(1, ir_channel_offset + ir_block_offset + sampleId)] = in[hook(0, in_channel_offset + in_block_offset + sampleId)];
  ir[hook(1, ir_channel_offset + ir_block_offset + block_sz + sampleId)] = 0;
}