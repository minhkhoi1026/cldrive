//{"buffer_pool":0,"output_u":8,"output_v":7,"output_y":6,"src_u_buffer":10,"src_v_buffer":11,"src_y_buffer":9,"u_plane_offset":2,"uv_stride":5,"v_plane_offset":3,"y_plane_offset":1,"y_stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void yuv_rgba(global uchar* buffer_pool, int y_plane_offset, int u_plane_offset, int v_plane_offset, int y_stride, int uv_stride, write_only image2d_t output_y, write_only image2d_t output_v, write_only image2d_t output_u) {
  int gIdx, gIdy;
  gIdx = get_global_id(0);
  gIdy = get_global_id(1);

  global uchar2* src_y_buffer = (global uchar2*)(buffer_pool + y_plane_offset);
  global uchar* src_u_buffer = buffer_pool + u_plane_offset;
  global uchar* src_v_buffer = buffer_pool + v_plane_offset;

  float2 y0, y1;
  float u, v;

  y0 = convert_float2(src_y_buffer[hook(9, (gIdy << 1) * (y_stride >> 1) + gIdx)]);
  y1 = convert_float2(src_y_buffer[hook(9, ((gIdy << 1) + 1) * (y_stride >> 1) + gIdx)]);
  u = (float)(src_u_buffer[hook(10, gIdy * uv_stride + gIdx)]);
  v = (float)(src_v_buffer[hook(11, gIdy * uv_stride + gIdx)]);

  float4 leftTop = (float4)(y0.x, 0, 0, 255.0f);
  float4 rightTop = (float4)(y0.y, 0, 0, 255.0f);
  float4 leftBottom = (float4)(y1.x, 0, 0, 255.0f);
  float4 RightBottom = (float4)(y1.y, 0, 0, 255.0f);
  float4 u_4 = (float4)(u, 0, 0, 255.0f);
  float4 v_4 = (float4)(v, 0, 0, 255.0f);

  write_imagef(output_y, (int2)(gIdx * 2, gIdy * 2), leftTop / (float4)255.0f);
  write_imagef(output_y, (int2)(gIdx * 2 + 1, gIdy * 2), rightTop / (float4)255.0f);
  write_imagef(output_y, (int2)(gIdx * 2, gIdy * 2 + 1), leftBottom / (float4)255.0f);
  write_imagef(output_y, (int2)(gIdx * 2 + 1, gIdy * 2 + 1), RightBottom / (float4)255.0f);

  write_imagef(output_v, (int2)(gIdx, gIdy), v_4 / (float4)255.0f);
  write_imagef(output_u, (int2)(gIdx, gIdy), u_4 / (float4)255.0f);
}