//{"g_queryCt":2,"localCt":8,"localSegment":3,"localSegmentCnt":5,"localSegmentCntCompact":6,"localSegmentCompact":4,"queryCt":9,"segmentSizePow2":10,"tally":0,"tallyCount":1,"wait":11,"zeroSeg":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void agg_diff(global unsigned int* tally, global unsigned int* tallyCount, global unsigned int* g_queryCt, local unsigned int* localSegment, local unsigned int* localSegmentCompact, local unsigned int* localSegmentCnt, local unsigned int* localSegmentCntCompact, local unsigned int* zeroSeg, local unsigned int* localCt, local unsigned int* queryCt, unsigned int segmentSizePow2) {
  unsigned int wgSize = get_local_size(0);
  unsigned int localIdx = get_local_id(0);
  unsigned int queryIdx = get_group_id(0);
  unsigned int i, l_offset, ct, cnt;
  event_t wait[4];
  queryCt[hook(9, 0)] = 0;
  queryCt[hook(9, 1)] = 0;

  l_offset = 64 * localIdx;
  for (i = 0; i < 64; i++) {
    zeroSeg[hook(7, l_offset + i)] = 0;
  }

  for (unsigned int wgIdx = 0; wgIdx < (segmentSizePow2 / 512); wgIdx++) {
    wait[hook(11, 0)] = async_work_group_copy(localSegment, tally + queryIdx * segmentSizePow2 + wgIdx * 512, 512, 0);
    wait[hook(11, 1)] = async_work_group_copy(localSegmentCnt, tallyCount + queryIdx * segmentSizePow2 + wgIdx * 512, 512, 0);

    wait_group_events(2, wait);

    wait[hook(11, 0)] = async_work_group_copy(tallyCount + queryIdx * segmentSizePow2 + wgIdx * 512, zeroSeg, 512, 0);
    wait[hook(11, 1)] = async_work_group_copy(tally + queryIdx * segmentSizePow2 + wgIdx * 512, (local unsigned int*)zeroSeg, 512, 0);

    ct = 0;
    l_offset = localIdx * 64;
    for (i = 0; i < 64; i++) {
      cnt = localSegmentCnt[hook(5, l_offset + i)];

      localSegmentCompact[hook(4, l_offset + ct)] = (cnt != -1) ? localSegment[hook(3, l_offset + i)] : 0;
      localSegmentCntCompact[hook(6, l_offset + ct)] = (cnt != -1) ? cnt : 0;
      ct += (cnt != -1) ? 1 : 0;
    }

    localCt[hook(8, localIdx)] = ct;
    barrier(0x01);

    unsigned int myLocalCompactOffset = 0;
    for (i = 0; i < localIdx; i++) {
      myLocalCompactOffset += localCt[hook(8, i)];
    }

    for (i = 0; i < ct; i++) {
      localSegment[hook(3, myLocalCompactOffset + i)] = localSegmentCompact[hook(4, l_offset + i)];
      localSegmentCnt[hook(5, myLocalCompactOffset + i)] = localSegmentCntCompact[hook(6, l_offset + i)];
    }

    if (localIdx == 0) {
      queryCt[hook(9, 1)] = 0;
      for (i = 0; i < wgSize; i++) {
        queryCt[hook(9, 1)] += localCt[hook(8, i)];
      }
      queryCt[hook(9, 0)] += queryCt[hook(9, 1)];
    }

    wait_group_events(2, wait);

    barrier(0x01 | 0x02);

    wait[hook(11, 2)] = async_work_group_copy(tallyCount + queryIdx * segmentSizePow2 + queryCt[hook(9, 0)] - queryCt[hook(9, 1)], localSegmentCnt, queryCt[hook(9, 1)], 0);
    wait[hook(11, 3)] = async_work_group_copy(tally + queryIdx * segmentSizePow2 + queryCt[hook(9, 0)] - queryCt[hook(9, 1)], localSegment, queryCt[hook(9, 1)], 0);

    wait_group_events(2, wait + 2);
  }

  if (localIdx == 0) {
    g_queryCt[hook(2, queryIdx)] = queryCt[hook(9, 0)];
  }
}