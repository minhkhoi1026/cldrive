//{"DAQParams":4,"OCLParams":3,"buffer":0,"dataOut":1,"gain":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iqDemodAvg(constant unsigned short* buffer, global double* dataOut, constant double* gain, constant int* OCLParams, constant int* DAQParams) {
  int i, j, k;
  int iIndex, qIndex;
  unsigned long int iData32, qData32;
  double iData, qData, iq2Data, logData;

  int bufIndex, numAverage, useGain, decimate;
  int numBuffers, bufLength, recLength;

  bufIndex = OCLParams[hook(3, 0)];
  numAverage = OCLParams[hook(3, 1)];
  useGain = OCLParams[hook(3, 2)];
  decimate = OCLParams[hook(3, 3)];

  numBuffers = DAQParams[hook(4, 0)];
  bufLength = DAQParams[hook(4, 1)];
  recLength = DAQParams[hook(4, 3)];

  i = get_global_id(0);

  iIndex = i * decimate;
  qIndex = i * decimate + 5;

  iData32 = 0;
  qData32 = 0;
  for (j = 0; j < numAverage; j++) {
    k = (numBuffers + bufIndex - j) % numBuffers;

    iData32 += buffer[hook(0, iIndex + k * bufLength)];
    qData32 += buffer[hook(0, qIndex + k * bufLength)];
  }
  iData32 /= numAverage;
  qData32 /= numAverage;

  iData = (double)iData32 * 1.2210012210012e-05 - 0.3987300000000;
  qData = (double)qData32 * 1.2210012210012e-05 - 0.3987300000000;

  if (useGain == 1) {
    iData *= gain[hook(2, iIndex % recLength)];
    qData *= gain[hook(2, qIndex % recLength)];
  }

  iq2Data = (iData * iData + qData * qData);
  logData = 10 * log10(iq2Data) - -60.000000000;

  dataOut[hook(1, i)] = max(logData, 0.0);
}