//{"dataArray":0,"iter":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MemoryTask(global long* dataArray, int iter) {
  global long* tmpPtr;
  dataArray[hook(0, 9 * get_global_size(0) + get_global_id(0))] = (long)(dataArray + get_global_id(0));
  for (int i = 0; i < 9; i++) {
    dataArray[hook(0, i * get_global_size(0) + get_global_id(0))] = (long)(dataArray + (i + 1) * get_global_size(0) + get_global_id(0));
  }

  tmpPtr = (global long*)dataArray[hook(0, get_global_id(0))];
  while (iter-- > 1) {
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
    tmpPtr = (global long*)(*tmpPtr);
  }
  dataArray[hook(0, get_global_id(0))] = *tmpPtr;
}