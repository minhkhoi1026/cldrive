//{"dst":64,"src1":0,"src10":9,"src11":10,"src12":11,"src13":12,"src14":13,"src15":14,"src16":15,"src17":16,"src18":17,"src19":18,"src2":1,"src20":19,"src21":20,"src22":21,"src23":22,"src24":23,"src25":24,"src26":25,"src27":26,"src28":27,"src29":28,"src3":2,"src30":29,"src31":30,"src32":31,"src33":32,"src34":33,"src35":34,"src36":35,"src37":36,"src38":37,"src39":38,"src4":3,"src40":39,"src41":40,"src42":41,"src43":42,"src44":43,"src45":44,"src46":45,"src47":46,"src48":47,"src49":48,"src5":4,"src50":49,"src51":50,"src52":51,"src53":52,"src54":53,"src55":54,"src56":55,"src57":56,"src58":57,"src59":58,"src6":5,"src60":59,"src61":60,"src62":61,"src63":62,"src64":63,"src7":6,"src8":7,"src9":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_test(constant int* src1, constant int* src2, constant int* src3, constant int* src4, constant int* src5, constant int* src6, constant int* src7, constant int* src8, constant int* src9, constant int* src10, constant int* src11, constant int* src12, constant int* src13, constant int* src14, constant int* src15, constant int* src16, constant int* src17, constant int* src18, constant int* src19, constant int* src20, constant int* src21, constant int* src22, constant int* src23, constant int* src24, constant int* src25, constant int* src26, constant int* src27, constant int* src28, constant int* src29, constant int* src30, constant int* src31, constant int* src32, constant int* src33, constant int* src34, constant int* src35, constant int* src36, constant int* src37, constant int* src38, constant int* src39, constant int* src40, constant int* src41, constant int* src42, constant int* src43, constant int* src44, constant int* src45, constant int* src46, constant int* src47, constant int* src48, constant int* src49, constant int* src50, constant int* src51, constant int* src52, constant int* src53, constant int* src54, constant int* src55, constant int* src56, constant int* src57, constant int* src58, constant int* src59, constant int* src60, constant int* src61, constant int* src62, constant int* src63, constant int* src64, global int* dst) {
  int tid = get_global_id(0);

  dst[hook(64, tid)] = src1[hook(0, tid)];
  dst[hook(64, tid)] += src2[hook(1, tid)];
  dst[hook(64, tid)] += src3[hook(2, tid)];
  dst[hook(64, tid)] += src4[hook(3, tid)];
  dst[hook(64, tid)] += src5[hook(4, tid)];
  dst[hook(64, tid)] += src6[hook(5, tid)];
  dst[hook(64, tid)] += src7[hook(6, tid)];
  dst[hook(64, tid)] += src8[hook(7, tid)];
  dst[hook(64, tid)] += src9[hook(8, tid)];
  dst[hook(64, tid)] += src10[hook(9, tid)];
  dst[hook(64, tid)] += src11[hook(10, tid)];
  dst[hook(64, tid)] += src12[hook(11, tid)];
  dst[hook(64, tid)] += src13[hook(12, tid)];
  dst[hook(64, tid)] += src14[hook(13, tid)];
  dst[hook(64, tid)] += src15[hook(14, tid)];
  dst[hook(64, tid)] += src16[hook(15, tid)];
  dst[hook(64, tid)] += src17[hook(16, tid)];
  dst[hook(64, tid)] += src18[hook(17, tid)];
  dst[hook(64, tid)] += src19[hook(18, tid)];
  dst[hook(64, tid)] += src20[hook(19, tid)];
  dst[hook(64, tid)] += src21[hook(20, tid)];
  dst[hook(64, tid)] += src22[hook(21, tid)];
  dst[hook(64, tid)] += src23[hook(22, tid)];
  dst[hook(64, tid)] += src24[hook(23, tid)];
  dst[hook(64, tid)] += src25[hook(24, tid)];
  dst[hook(64, tid)] += src26[hook(25, tid)];
  dst[hook(64, tid)] += src27[hook(26, tid)];
  dst[hook(64, tid)] += src28[hook(27, tid)];
  dst[hook(64, tid)] += src29[hook(28, tid)];
  dst[hook(64, tid)] += src30[hook(29, tid)];
  dst[hook(64, tid)] += src31[hook(30, tid)];
  dst[hook(64, tid)] += src32[hook(31, tid)];
  dst[hook(64, tid)] += src33[hook(32, tid)];
  dst[hook(64, tid)] += src34[hook(33, tid)];
  dst[hook(64, tid)] += src35[hook(34, tid)];
  dst[hook(64, tid)] += src36[hook(35, tid)];
  dst[hook(64, tid)] += src37[hook(36, tid)];
  dst[hook(64, tid)] += src38[hook(37, tid)];
  dst[hook(64, tid)] += src39[hook(38, tid)];
  dst[hook(64, tid)] += src40[hook(39, tid)];
  dst[hook(64, tid)] += src41[hook(40, tid)];
  dst[hook(64, tid)] += src42[hook(41, tid)];
  dst[hook(64, tid)] += src43[hook(42, tid)];
  dst[hook(64, tid)] += src44[hook(43, tid)];
  dst[hook(64, tid)] += src45[hook(44, tid)];
  dst[hook(64, tid)] += src46[hook(45, tid)];
  dst[hook(64, tid)] += src47[hook(46, tid)];
  dst[hook(64, tid)] += src48[hook(47, tid)];
  dst[hook(64, tid)] += src49[hook(48, tid)];
  dst[hook(64, tid)] += src50[hook(49, tid)];
  dst[hook(64, tid)] += src51[hook(50, tid)];
  dst[hook(64, tid)] += src52[hook(51, tid)];
  dst[hook(64, tid)] += src53[hook(52, tid)];
  dst[hook(64, tid)] += src54[hook(53, tid)];
  dst[hook(64, tid)] += src55[hook(54, tid)];
  dst[hook(64, tid)] += src56[hook(55, tid)];
  dst[hook(64, tid)] += src57[hook(56, tid)];
  dst[hook(64, tid)] += src58[hook(57, tid)];
  dst[hook(64, tid)] += src59[hook(58, tid)];
  dst[hook(64, tid)] += src60[hook(59, tid)];
  dst[hook(64, tid)] += src61[hook(60, tid)];
  dst[hook(64, tid)] += src62[hook(61, tid)];
  dst[hook(64, tid)] += src63[hook(62, tid)];
  dst[hook(64, tid)] += src64[hook(63, tid)];
}