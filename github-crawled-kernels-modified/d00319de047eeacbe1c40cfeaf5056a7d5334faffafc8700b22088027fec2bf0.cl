//{"cb":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void constantBandwidth_single_static(constant float* cb, global float* output) {
  float val = (float)(0.0f);
  unsigned int gid = get_global_id(0);
  unsigned int index = 0;

  val = val + cb[hook(0, index + 0)];
  val = val + cb[hook(0, index + 1)];
  val = val + cb[hook(0, index + 2)];
  val = val + cb[hook(0, index + 3)];
  val = val + cb[hook(0, index + 4)];
  val = val + cb[hook(0, index + 5)];
  val = val + cb[hook(0, index + 6)];
  val = val + cb[hook(0, index + 7)];
  val = val + cb[hook(0, index + 8)];
  val = val + cb[hook(0, index + 9)];
  val = val + cb[hook(0, index + 10)];
  val = val + cb[hook(0, index + 11)];
  val = val + cb[hook(0, index + 12)];
  val = val + cb[hook(0, index + 13)];
  val = val + cb[hook(0, index + 14)];
  val = val + cb[hook(0, index + 15)];
  val = val + cb[hook(0, index + 16)];
  val = val + cb[hook(0, index + 17)];
  val = val + cb[hook(0, index + 18)];
  val = val + cb[hook(0, index + 19)];
  val = val + cb[hook(0, index + 20)];
  val = val + cb[hook(0, index + 21)];
  val = val + cb[hook(0, index + 22)];
  val = val + cb[hook(0, index + 23)];
  val = val + cb[hook(0, index + 24)];
  val = val + cb[hook(0, index + 25)];
  val = val + cb[hook(0, index + 26)];
  val = val + cb[hook(0, index + 27)];
  val = val + cb[hook(0, index + 28)];
  val = val + cb[hook(0, index + 29)];
  val = val + cb[hook(0, index + 30)];
  val = val + cb[hook(0, index + 31)];
  val = val + cb[hook(0, index + 32)];
  val = val + cb[hook(0, index + 33)];
  val = val + cb[hook(0, index + 34)];
  val = val + cb[hook(0, index + 35)];
  val = val + cb[hook(0, index + 36)];
  val = val + cb[hook(0, index + 37)];
  val = val + cb[hook(0, index + 38)];
  val = val + cb[hook(0, index + 39)];
  val = val + cb[hook(0, index + 40)];
  val = val + cb[hook(0, index + 41)];
  val = val + cb[hook(0, index + 42)];
  val = val + cb[hook(0, index + 43)];
  val = val + cb[hook(0, index + 44)];
  val = val + cb[hook(0, index + 45)];
  val = val + cb[hook(0, index + 46)];
  val = val + cb[hook(0, index + 47)];
  val = val + cb[hook(0, index + 48)];
  val = val + cb[hook(0, index + 49)];
  val = val + cb[hook(0, index + 50)];
  val = val + cb[hook(0, index + 51)];
  val = val + cb[hook(0, index + 52)];
  val = val + cb[hook(0, index + 53)];
  val = val + cb[hook(0, index + 54)];
  val = val + cb[hook(0, index + 55)];
  val = val + cb[hook(0, index + 56)];
  val = val + cb[hook(0, index + 57)];
  val = val + cb[hook(0, index + 58)];
  val = val + cb[hook(0, index + 59)];
  val = val + cb[hook(0, index + 60)];
  val = val + cb[hook(0, index + 61)];
  val = val + cb[hook(0, index + 62)];
  val = val + cb[hook(0, index + 63)];
  val = val + cb[hook(0, index + 64)];
  val = val + cb[hook(0, index + 65)];
  val = val + cb[hook(0, index + 66)];
  val = val + cb[hook(0, index + 67)];
  val = val + cb[hook(0, index + 68)];
  val = val + cb[hook(0, index + 69)];
  val = val + cb[hook(0, index + 70)];
  val = val + cb[hook(0, index + 71)];
  val = val + cb[hook(0, index + 72)];
  val = val + cb[hook(0, index + 73)];
  val = val + cb[hook(0, index + 74)];
  val = val + cb[hook(0, index + 75)];
  val = val + cb[hook(0, index + 76)];
  val = val + cb[hook(0, index + 77)];
  val = val + cb[hook(0, index + 78)];
  val = val + cb[hook(0, index + 79)];
  val = val + cb[hook(0, index + 80)];
  val = val + cb[hook(0, index + 81)];
  val = val + cb[hook(0, index + 82)];
  val = val + cb[hook(0, index + 83)];
  val = val + cb[hook(0, index + 84)];
  val = val + cb[hook(0, index + 85)];
  val = val + cb[hook(0, index + 86)];
  val = val + cb[hook(0, index + 87)];
  val = val + cb[hook(0, index + 88)];
  val = val + cb[hook(0, index + 89)];
  val = val + cb[hook(0, index + 90)];
  val = val + cb[hook(0, index + 91)];
  val = val + cb[hook(0, index + 92)];
  val = val + cb[hook(0, index + 93)];
  val = val + cb[hook(0, index + 94)];
  val = val + cb[hook(0, index + 95)];
  val = val + cb[hook(0, index + 96)];
  val = val + cb[hook(0, index + 97)];
  val = val + cb[hook(0, index + 98)];
  val = val + cb[hook(0, index + 99)];
  val = val + cb[hook(0, index + 100)];
  val = val + cb[hook(0, index + 101)];
  val = val + cb[hook(0, index + 102)];
  val = val + cb[hook(0, index + 103)];
  val = val + cb[hook(0, index + 104)];
  val = val + cb[hook(0, index + 105)];
  val = val + cb[hook(0, index + 106)];
  val = val + cb[hook(0, index + 107)];
  val = val + cb[hook(0, index + 108)];
  val = val + cb[hook(0, index + 109)];
  val = val + cb[hook(0, index + 110)];
  val = val + cb[hook(0, index + 111)];
  val = val + cb[hook(0, index + 112)];
  val = val + cb[hook(0, index + 113)];
  val = val + cb[hook(0, index + 114)];
  val = val + cb[hook(0, index + 115)];
  val = val + cb[hook(0, index + 116)];
  val = val + cb[hook(0, index + 117)];
  val = val + cb[hook(0, index + 118)];
  val = val + cb[hook(0, index + 119)];
  val = val + cb[hook(0, index + 120)];
  val = val + cb[hook(0, index + 121)];
  val = val + cb[hook(0, index + 122)];
  val = val + cb[hook(0, index + 123)];
  val = val + cb[hook(0, index + 124)];
  val = val + cb[hook(0, index + 125)];
  val = val + cb[hook(0, index + 126)];
  val = val + cb[hook(0, index + 127)];
  val = val + cb[hook(0, index + 128)];
  val = val + cb[hook(0, index + 129)];
  val = val + cb[hook(0, index + 130)];
  val = val + cb[hook(0, index + 131)];
  val = val + cb[hook(0, index + 132)];
  val = val + cb[hook(0, index + 133)];
  val = val + cb[hook(0, index + 134)];
  val = val + cb[hook(0, index + 135)];
  val = val + cb[hook(0, index + 136)];
  val = val + cb[hook(0, index + 137)];
  val = val + cb[hook(0, index + 138)];
  val = val + cb[hook(0, index + 139)];
  val = val + cb[hook(0, index + 140)];
  val = val + cb[hook(0, index + 141)];
  val = val + cb[hook(0, index + 142)];
  val = val + cb[hook(0, index + 143)];
  val = val + cb[hook(0, index + 144)];
  val = val + cb[hook(0, index + 145)];
  val = val + cb[hook(0, index + 146)];
  val = val + cb[hook(0, index + 147)];
  val = val + cb[hook(0, index + 148)];
  val = val + cb[hook(0, index + 149)];
  val = val + cb[hook(0, index + 150)];
  val = val + cb[hook(0, index + 151)];
  val = val + cb[hook(0, index + 152)];
  val = val + cb[hook(0, index + 153)];
  val = val + cb[hook(0, index + 154)];
  val = val + cb[hook(0, index + 155)];
  val = val + cb[hook(0, index + 156)];
  val = val + cb[hook(0, index + 157)];
  val = val + cb[hook(0, index + 158)];
  val = val + cb[hook(0, index + 159)];
  val = val + cb[hook(0, index + 160)];
  val = val + cb[hook(0, index + 161)];
  val = val + cb[hook(0, index + 162)];
  val = val + cb[hook(0, index + 163)];
  val = val + cb[hook(0, index + 164)];
  val = val + cb[hook(0, index + 165)];
  val = val + cb[hook(0, index + 166)];
  val = val + cb[hook(0, index + 167)];
  val = val + cb[hook(0, index + 168)];
  val = val + cb[hook(0, index + 169)];
  val = val + cb[hook(0, index + 170)];
  val = val + cb[hook(0, index + 171)];
  val = val + cb[hook(0, index + 172)];
  val = val + cb[hook(0, index + 173)];
  val = val + cb[hook(0, index + 174)];
  val = val + cb[hook(0, index + 175)];
  val = val + cb[hook(0, index + 176)];
  val = val + cb[hook(0, index + 177)];
  val = val + cb[hook(0, index + 178)];
  val = val + cb[hook(0, index + 179)];
  val = val + cb[hook(0, index + 180)];
  val = val + cb[hook(0, index + 181)];
  val = val + cb[hook(0, index + 182)];
  val = val + cb[hook(0, index + 183)];
  val = val + cb[hook(0, index + 184)];
  val = val + cb[hook(0, index + 185)];
  val = val + cb[hook(0, index + 186)];
  val = val + cb[hook(0, index + 187)];
  val = val + cb[hook(0, index + 188)];
  val = val + cb[hook(0, index + 189)];
  val = val + cb[hook(0, index + 190)];
  val = val + cb[hook(0, index + 191)];
  val = val + cb[hook(0, index + 192)];
  val = val + cb[hook(0, index + 193)];
  val = val + cb[hook(0, index + 194)];
  val = val + cb[hook(0, index + 195)];
  val = val + cb[hook(0, index + 196)];
  val = val + cb[hook(0, index + 197)];
  val = val + cb[hook(0, index + 198)];
  val = val + cb[hook(0, index + 199)];
  val = val + cb[hook(0, index + 200)];
  val = val + cb[hook(0, index + 201)];
  val = val + cb[hook(0, index + 202)];
  val = val + cb[hook(0, index + 203)];
  val = val + cb[hook(0, index + 204)];
  val = val + cb[hook(0, index + 205)];
  val = val + cb[hook(0, index + 206)];
  val = val + cb[hook(0, index + 207)];
  val = val + cb[hook(0, index + 208)];
  val = val + cb[hook(0, index + 209)];
  val = val + cb[hook(0, index + 210)];
  val = val + cb[hook(0, index + 211)];
  val = val + cb[hook(0, index + 212)];
  val = val + cb[hook(0, index + 213)];
  val = val + cb[hook(0, index + 214)];
  val = val + cb[hook(0, index + 215)];
  val = val + cb[hook(0, index + 216)];
  val = val + cb[hook(0, index + 217)];
  val = val + cb[hook(0, index + 218)];
  val = val + cb[hook(0, index + 219)];
  val = val + cb[hook(0, index + 220)];
  val = val + cb[hook(0, index + 221)];
  val = val + cb[hook(0, index + 222)];
  val = val + cb[hook(0, index + 223)];
  val = val + cb[hook(0, index + 224)];
  val = val + cb[hook(0, index + 225)];
  val = val + cb[hook(0, index + 226)];
  val = val + cb[hook(0, index + 227)];
  val = val + cb[hook(0, index + 228)];
  val = val + cb[hook(0, index + 229)];
  val = val + cb[hook(0, index + 230)];
  val = val + cb[hook(0, index + 231)];
  val = val + cb[hook(0, index + 232)];
  val = val + cb[hook(0, index + 233)];
  val = val + cb[hook(0, index + 234)];
  val = val + cb[hook(0, index + 235)];
  val = val + cb[hook(0, index + 236)];
  val = val + cb[hook(0, index + 237)];
  val = val + cb[hook(0, index + 238)];
  val = val + cb[hook(0, index + 239)];
  val = val + cb[hook(0, index + 240)];
  val = val + cb[hook(0, index + 241)];
  val = val + cb[hook(0, index + 242)];
  val = val + cb[hook(0, index + 243)];
  val = val + cb[hook(0, index + 244)];
  val = val + cb[hook(0, index + 245)];
  val = val + cb[hook(0, index + 246)];
  val = val + cb[hook(0, index + 247)];
  val = val + cb[hook(0, index + 248)];
  val = val + cb[hook(0, index + 249)];
  val = val + cb[hook(0, index + 250)];
  val = val + cb[hook(0, index + 251)];
  val = val + cb[hook(0, index + 252)];
  val = val + cb[hook(0, index + 253)];
  val = val + cb[hook(0, index + 254)];
  val = val + cb[hook(0, index + 255)];
  output[hook(1, gid)] = val;
}