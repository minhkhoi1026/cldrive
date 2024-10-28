//{"a":2,"a_T":3,"heightA":0,"widthA":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixTranspose(const int heightA, const int widthA, global const float* a, global float* a_T) {
  const int alpha = 4;
  const int colA = get_global_id(0) * alpha;
  const int rowA = get_global_id(1) * alpha;

  if ((rowA < heightA) && (colA < widthA)) {
    float* src_a_0 = a + (rowA + 0) * widthA + (colA + 0);
    float* src_a_1 = a + (rowA + 1) * widthA + (colA + 0);
    float* src_a_2 = a + (rowA + 2) * widthA + (colA + 0);
    float* src_a_3 = a + (rowA + 3) * widthA + (colA + 0);

    float4 vec1x4_0 = *((float4*)src_a_0);
    float4 vec1x4_1 = *((float4*)src_a_1);
    float4 vec1x4_2 = *((float4*)src_a_2);
    float4 vec1x4_3 = *((float4*)src_a_3);

    a_T[hook(3, (colA + 0) * heightA + (rowA + 0))] = vec1x4_0.x;
    a_T[hook(3, (colA + 1) * heightA + (rowA + 0))] = vec1x4_0.y;
    a_T[hook(3, (colA + 2) * heightA + (rowA + 0))] = vec1x4_0.z;
    a_T[hook(3, (colA + 3) * heightA + (rowA + 0))] = vec1x4_0.w;

    a_T[hook(3, (colA + 0) * heightA + (rowA + 1))] = vec1x4_1.x;
    a_T[hook(3, (colA + 1) * heightA + (rowA + 1))] = vec1x4_1.y;
    a_T[hook(3, (colA + 2) * heightA + (rowA + 1))] = vec1x4_1.z;
    a_T[hook(3, (colA + 3) * heightA + (rowA + 1))] = vec1x4_1.w;

    a_T[hook(3, (colA + 0) * heightA + (rowA + 2))] = vec1x4_2.x;
    a_T[hook(3, (colA + 1) * heightA + (rowA + 2))] = vec1x4_2.y;
    a_T[hook(3, (colA + 2) * heightA + (rowA + 2))] = vec1x4_2.z;
    a_T[hook(3, (colA + 3) * heightA + (rowA + 2))] = vec1x4_2.w;

    a_T[hook(3, (colA + 0) * heightA + (rowA + 3))] = vec1x4_3.x;
    a_T[hook(3, (colA + 1) * heightA + (rowA + 3))] = vec1x4_3.y;
    a_T[hook(3, (colA + 2) * heightA + (rowA + 3))] = vec1x4_3.z;
    a_T[hook(3, (colA + 3) * heightA + (rowA + 3))] = vec1x4_3.w;
  }
}