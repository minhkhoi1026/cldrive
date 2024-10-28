//{"segmentSizePow2":2,"tally":0,"tallyCount":1,"topk":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void take_topk(global unsigned int* tally, global unsigned int* tallyCount, unsigned int segmentSizePow2, unsigned int topk) {
  unsigned int grpId = get_group_id(0);
  unsigned int localId = get_local_id(0);

  unsigned int myCopyLoc = (1 & (unsigned int)grpId) ? ((unsigned)(grpId * segmentSizePow2) + localId) : ((unsigned)(grpId * segmentSizePow2) + localId + (segmentSizePow2 - topk));

  tallyCount[hook(1, (unsigned int)(grpId * topk) + localId)] = tally[hook(0, myCopyLoc)];
}