//{"queueSorted":2,"segmentSize":3,"talley":0,"talleyCount":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void talley_count(global unsigned int* talley, global int* talleyCount, global unsigned int* queueSorted, int segmentSize) {
  int queryIdx = get_global_id(0);

  int Q = queryIdx * segmentSize;

  int ok;
  int count = 1;
  unsigned int obj = queueSorted[hook(2, Q)];
  int idx = 0;

  for (int i = 1; i < segmentSize; i++) {
    ok = (obj != queueSorted[hook(2, Q + i)]);

    talley[hook(0, Q + idx)] = ok ? obj : talley[hook(0, Q + idx)];
    talleyCount[hook(1, Q + idx)] = ok ? count : talleyCount[hook(1, Q + idx)];

    obj = ok ? queueSorted[hook(2, Q + i)] : obj;
    count = (1 - ok) * count;
    idx += ok;
    count++;
  }
  talley[hook(0, Q + idx)] = obj;
  talleyCount[hook(1, Q + idx)] = count;
}