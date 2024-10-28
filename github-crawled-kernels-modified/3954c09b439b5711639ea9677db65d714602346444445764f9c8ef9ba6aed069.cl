//{"area":1,"numOfIntervals":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pieCalculation(global int* numOfIntervals, global float* area) {
  int globalId = get_global_id(0);
  int intervalCount = globalId;
  float intervalMidPoint = 0.0f;
  float distance = 0.5f;
  int noOfint = *numOfIntervals;
  float intervalWidth = 1.0 / (*numOfIntervals);
  float sum = 0.0f;
  float tempResult = 0.0f;
  int icnt;
  if (globalId < (*numOfIntervals)) {
    intervalMidPoint = intervalWidth * ((intervalCount + 1) - distance);
    sum = (4.0 / (1.0 + intervalMidPoint * intervalMidPoint));
  }
  area[hook(1, intervalCount)] = intervalWidth * sum;
  barrier(0x02);
  if (globalId == 0) {
    tempResult = 0.0;
    for (icnt = 0; icnt < noOfint; icnt++) {
      tempResult += area[hook(1, icnt)];
    }
    *area = tempResult;
  }
}