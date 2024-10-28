//{"C":2,"M":0,"lM":4,"lx":5,"ly":6,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dsp_compute(global const float2* M, global const float2* x, const float C, global float2* y, local float2* lM, local float2* lx, local float2* ly) {
  int grp_id = get_group_id(0);
  int num_elems = get_local_size(0);

  event_t ev1 = async_work_group_copy(lM, M + grp_id * num_elems, num_elems, 0);
  event_t ev2 = async_work_group_copy(lx, x + grp_id * num_elems, num_elems, 0);

  wait_group_events(1, &ev1);
  wait_group_events(1, &ev2);

  int lid = get_local_id(0);
  ly[hook(6, lid)] = lx[hook(5, lid)] * lM[hook(4, lid)] + C;

  event_t ev3 = async_work_group_copy(y + grp_id * num_elems, ly, num_elems, 0);
  wait_group_events(1, &ev3);
}