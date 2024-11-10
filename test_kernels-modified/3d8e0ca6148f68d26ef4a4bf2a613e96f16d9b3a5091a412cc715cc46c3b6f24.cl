//{"RKF":0,"RKR":1,"WDOT":2,"molwt":4,"rateconv":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rdwdot_kernel(global const float* RKF, global const float* RKR, global float* WDOT, const float rateconv, global const float* molwt) {
  float ROP5 = ((RKF[hook(0, (((5) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((5) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((6) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((7) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((7) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((8) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((8) - 1) * (4)) + (get_global_id(0)))]));
  float ROP12 = ((RKF[hook(0, (((12) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((13) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((13) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((14) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((15) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]));

  (WDOT[hook(2, (((2) - 1) * (4)) + (get_global_id(0)))]) = (-((RKF[hook(0, (((1) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((2) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((3) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))])) - ROP5 - ROP5 - ((RKF[hook(0, (((9) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((9) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((10) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))])) - ROP12 - ((RKF[hook(0, (((17) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((17) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((18) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((18) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((19) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((19) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((24) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((24) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((25) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((25) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((30) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((30) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((34) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((34) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((35) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((35) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((36) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((36) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((37) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((37) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((41) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((41) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((42) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((42) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((44) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((44) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((46) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((46) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((48) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((48) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((49) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((49) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((50) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((50) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((52) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((52) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((52) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((52) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((53) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((53) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((57) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((57) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((60) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((60) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((62) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((62) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((63) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((63) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((64) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((64) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((65) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((65) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((71) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((71) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((72) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((72) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((77) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((77) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((78) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((78) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((79) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((79) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((87) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((87) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((91) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((91) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((92) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((92) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((94) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((94) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((96) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((96) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((97) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((97) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((98) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((98) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((102) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((102) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((105) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((105) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((108) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((108) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((109) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((109) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((115) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((115) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((116) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((116) - 1) * (4)) + (get_global_id(0)))])) +
                                                    ((RKF[hook(0, (((118) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((118) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((124) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((124) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((126) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((126) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((127) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((127) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((128) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((128) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((132) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((132) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((133) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((133) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((134) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((134) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((135) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((135) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((146) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((146) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((148) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((148) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((149) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((149) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((150) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((150) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((156) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((156) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((157) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((157) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((165) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((165) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((167) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((167) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((170) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((170) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((171) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((171) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((173) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((173) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((180) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((180) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((185) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((185) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((186) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((186) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((190) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((190) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((191) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((191) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((192) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((192) - 1) * (4)) + (get_global_id(0)))])) + ((RKF[hook(0, (((193) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((193) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((199) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((199) - 1) * (4)) + (get_global_id(0)))])) - ((RKF[hook(0, (((200) - 1) * (4)) + (get_global_id(0)))]) - (RKR[hook(1, (((200) - 1) * (4)) + (get_global_id(0)))]))) *
                                                   rateconv * molwt[hook(4, 1)];
}