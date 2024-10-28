//{"errVec":0,"incErr":2,"incOutputVec":12,"incTeachingEnabledInp":9,"incTeachingInp":6,"outputVec":10,"sizeErr":3,"startErr":1,"startOutputVec":11,"startTeachingEnabledInp":8,"startTeachingInp":5,"teachingInpEnabledVec":7,"teachingInpVec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_error_vector(global float* errVec, unsigned int startErr, unsigned int incErr, unsigned int sizeErr, global const float* teachingInpVec, unsigned int startTeachingInp, unsigned int incTeachingInp, global const char* teachingInpEnabledVec, unsigned int startTeachingEnabledInp, unsigned int incTeachingEnabledInp, global const float* outputVec, unsigned int startOutputVec, unsigned int incOutputVec) {
  for (unsigned int i = get_global_id(0); i < sizeErr; i += get_global_size(0)) {
    if (teachingInpEnabledVec[hook(7, i * incTeachingEnabledInp + startTeachingEnabledInp)])
      errVec[hook(0, i * incErr + startErr)] = teachingInpVec[hook(4, i * incTeachingInp + startTeachingInp)] - outputVec[hook(10, i * incOutputVec + startOutputVec)];
    else
      errVec[hook(0, i * incErr + startErr)] = 0;
  }
}