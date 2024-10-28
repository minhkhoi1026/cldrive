//{"backwardMap":15,"backwardMapPtr":9,"backwardMap_offset":11,"backwardMap_step":10,"backwardMotionPtr":3,"backwardMotion_offset":5,"backwardMotion_step":4,"cols":13,"forwardMap":14,"forwardMapPtr":6,"forwardMap_offset":8,"forwardMap_step":7,"forwardMotionPtr":0,"forwardMotion_offset":2,"forwardMotion_step":1,"rows":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildMotionMaps(global const uchar* forwardMotionPtr, int forwardMotion_step, int forwardMotion_offset, global const uchar* backwardMotionPtr, int backwardMotion_step, int backwardMotion_offset, global const uchar* forwardMapPtr, int forwardMap_step, int forwardMap_offset, global const uchar* backwardMapPtr, int backwardMap_step, int backwardMap_offset, int rows, int cols) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int forwardMotion_index = mad24(forwardMotion_step, y, (int)sizeof(float2) * x + forwardMotion_offset);
    int backwardMotion_index = mad24(backwardMotion_step, y, (int)sizeof(float2) * x + backwardMotion_offset);
    int forwardMap_index = mad24(forwardMap_step, y, (int)sizeof(float2) * x + forwardMap_offset);
    int backwardMap_index = mad24(backwardMap_step, y, (int)sizeof(float2) * x + backwardMap_offset);

    float2 forwardMotion = *(global const float2*)(forwardMotionPtr + forwardMotion_index);
    float2 backwardMotion = *(global const float2*)(backwardMotionPtr + backwardMotion_index);
    global float2* forwardMap = (global float2*)(forwardMapPtr + forwardMap_index);
    global float2* backwardMap = (global float2*)(backwardMapPtr + backwardMap_index);

    float2 basePoint = (float2)(x, y);

    forwardMap[hook(14, 0)] = basePoint + backwardMotion;
    backwardMap[hook(15, 0)] = basePoint + forwardMotion;
  }
}