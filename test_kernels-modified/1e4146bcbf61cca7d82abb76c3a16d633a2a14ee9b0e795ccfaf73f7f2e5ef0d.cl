//{"X":5,"base":2,"charset":1,"charsetLength":3,"hashes":0,"plainTextLength":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ComputeHashes(global uint4* hashes, constant char* charset, constant char* base, const unsigned int charsetLength, const unsigned int plainTextLength) {
  unsigned int X[5];
  unsigned int id = get_global_id(0);
  int counter = id;

  int oc, a = 0, carry = 0;
  X[hook(5, 0)] = 0;
  X[hook(5, 1)] = 0;
  X[hook(5, 2)] = 0;
  X[hook(5, 3)] = 0;
  X[hook(5, 4)] = 0;

  for (int i = 0; i < plainTextLength; ++i) {
    oc = counter / charsetLength;
    a = base[hook(2, i)] + carry + counter - oc * charsetLength;
    if (a >= charsetLength) {
      a -= charsetLength;
      carry = 1;
    } else
      carry = 0;
    X[hook(5, i >> 2)] |= charset[hook(1, a)] << ((i & 3) << 3);
    counter = oc;
  }

  X[hook(5, plainTextLength >> 2)] |= ((unsigned int)(0x00000080) << ((plainTextLength & 3) << 3));

  unsigned int A, B, C, D;
  A = 0x67452301;
  B = 0xefcdab89;
  C = 0x98badcfe;
  D = 0x10325476;

  {
    A += (D ^ (B & (C ^ D))) + X[hook(5, 0)] + 0xD76AA478;
    A = ((A << 7) | ((A & 0xFFFFFFFF) >> (32 - 7))) + B;
  };
  {
    D += (C ^ (A & (B ^ C))) + X[hook(5, 1)] + 0xE8C7B756;
    D = ((D << 12) | ((D & 0xFFFFFFFF) >> (32 - 12))) + A;
  };
  {
    C += (B ^ (D & (A ^ B))) + X[hook(5, 2)] + 0x242070DB;
    C = ((C << 17) | ((C & 0xFFFFFFFF) >> (32 - 17))) + D;
  };
  {
    B += (A ^ (C & (D ^ A))) + X[hook(5, 3)] + 0xC1BDCEEE;
    B = ((B << 22) | ((B & 0xFFFFFFFF) >> (32 - 22))) + C;
  };
  {
    A += (D ^ (B & (C ^ D))) + X[hook(5, 4)] + 0xF57C0FAF;
    A = ((A << 7) | ((A & 0xFFFFFFFF) >> (32 - 7))) + B;
  };
  {
    D += (C ^ (A & (B ^ C))) + 0x4787C62A;
    D = ((D << 12) | ((D & 0xFFFFFFFF) >> (32 - 12))) + A;
  };
  {
    C += (B ^ (D & (A ^ B))) + 0xA8304613;
    C = ((C << 17) | ((C & 0xFFFFFFFF) >> (32 - 17))) + D;
  };
  {
    B += (A ^ (C & (D ^ A))) + 0xFD469501;
    B = ((B << 22) | ((B & 0xFFFFFFFF) >> (32 - 22))) + C;
  };
  {
    A += (D ^ (B & (C ^ D))) + 0x698098D8;
    A = ((A << 7) | ((A & 0xFFFFFFFF) >> (32 - 7))) + B;
  };
  {
    D += (C ^ (A & (B ^ C))) + 0x8B44F7AF;
    D = ((D << 12) | ((D & 0xFFFFFFFF) >> (32 - 12))) + A;
  };
  {
    C += (B ^ (D & (A ^ B))) + 0xFFFF5BB1;
    C = ((C << 17) | ((C & 0xFFFFFFFF) >> (32 - 17))) + D;
  };
  {
    B += (A ^ (C & (D ^ A))) + 0x895CD7BE;
    B = ((B << 22) | ((B & 0xFFFFFFFF) >> (32 - 22))) + C;
  };
  {
    A += (D ^ (B & (C ^ D))) + 0x6B901122;
    A = ((A << 7) | ((A & 0xFFFFFFFF) >> (32 - 7))) + B;
  };
  {
    D += (C ^ (A & (B ^ C))) + 0xFD987193;
    D = ((D << 12) | ((D & 0xFFFFFFFF) >> (32 - 12))) + A;
  };
  {
    C += (B ^ (D & (A ^ B))) + (plainTextLength << 3) + 0xA679438E;
    C = ((C << 17) | ((C & 0xFFFFFFFF) >> (32 - 17))) + D;
  };
  {
    B += (A ^ (C & (D ^ A))) + 0x49B40821;
    B = ((B << 22) | ((B & 0xFFFFFFFF) >> (32 - 22))) + C;
  };

  {
    A += (C ^ (D & (B ^ C))) + X[hook(5, 1)] + 0xF61E2562;
    A = ((A << 5) | ((A & 0xFFFFFFFF) >> (32 - 5))) + B;
  };
  {
    D += (B ^ (C & (A ^ B))) + 0xC040B340;
    D = ((D << 9) | ((D & 0xFFFFFFFF) >> (32 - 9))) + A;
  };
  {
    C += (A ^ (B & (D ^ A))) + 0x265E5A51;
    C = ((C << 14) | ((C & 0xFFFFFFFF) >> (32 - 14))) + D;
  };
  {
    B += (D ^ (A & (C ^ D))) + X[hook(5, 0)] + 0xE9B6C7AA;
    B = ((B << 20) | ((B & 0xFFFFFFFF) >> (32 - 20))) + C;
  };
  {
    A += (C ^ (D & (B ^ C))) + 0xD62F105D;
    A = ((A << 5) | ((A & 0xFFFFFFFF) >> (32 - 5))) + B;
  };
  {
    D += (B ^ (C & (A ^ B))) + 0x02441453;
    D = ((D << 9) | ((D & 0xFFFFFFFF) >> (32 - 9))) + A;
  };
  {
    C += (A ^ (B & (D ^ A))) + 0xD8A1E681;
    C = ((C << 14) | ((C & 0xFFFFFFFF) >> (32 - 14))) + D;
  };
  {
    B += (D ^ (A & (C ^ D))) + X[hook(5, 4)] + 0xE7D3FBC8;
    B = ((B << 20) | ((B & 0xFFFFFFFF) >> (32 - 20))) + C;
  };
  {
    A += (C ^ (D & (B ^ C))) + 0x21E1CDE6;
    A = ((A << 5) | ((A & 0xFFFFFFFF) >> (32 - 5))) + B;
  };
  {
    D += (B ^ (C & (A ^ B))) + (plainTextLength << 3) + 0xC33707D6;
    D = ((D << 9) | ((D & 0xFFFFFFFF) >> (32 - 9))) + A;
  };
  {
    C += (A ^ (B & (D ^ A))) + X[hook(5, 3)] + 0xF4D50D87;
    C = ((C << 14) | ((C & 0xFFFFFFFF) >> (32 - 14))) + D;
  };
  {
    B += (D ^ (A & (C ^ D))) + 0x455A14ED;
    B = ((B << 20) | ((B & 0xFFFFFFFF) >> (32 - 20))) + C;
  };
  {
    A += (C ^ (D & (B ^ C))) + 0xA9E3E905;
    A = ((A << 5) | ((A & 0xFFFFFFFF) >> (32 - 5))) + B;
  };
  {
    D += (B ^ (C & (A ^ B))) + X[hook(5, 2)] + 0xFCEFA3F8;
    D = ((D << 9) | ((D & 0xFFFFFFFF) >> (32 - 9))) + A;
  };
  {
    C += (A ^ (B & (D ^ A))) + 0x676F02D9;
    C = ((C << 14) | ((C & 0xFFFFFFFF) >> (32 - 14))) + D;
  };
  {
    B += (D ^ (A & (C ^ D))) + 0x8D2A4C8A;
    B = ((B << 20) | ((B & 0xFFFFFFFF) >> (32 - 20))) + C;
  };

  {
    A += (B ^ C ^ D) + 0xFFFA3942;
    A = ((A << 4) | ((A & 0xFFFFFFFF) >> (32 - 4))) + B;
  };
  {
    D += (A ^ B ^ C) + 0x8771F681;
    D = ((D << 11) | ((D & 0xFFFFFFFF) >> (32 - 11))) + A;
  };
  {
    C += (D ^ A ^ B) + 0x6D9D6122;
    C = ((C << 16) | ((C & 0xFFFFFFFF) >> (32 - 16))) + D;
  };
  {
    B += (C ^ D ^ A) + (plainTextLength << 3) + 0xFDE5380C;
    B = ((B << 23) | ((B & 0xFFFFFFFF) >> (32 - 23))) + C;
  };
  {
    A += (B ^ C ^ D) + X[hook(5, 1)] + 0xA4BEEA44;
    A = ((A << 4) | ((A & 0xFFFFFFFF) >> (32 - 4))) + B;
  };
  {
    D += (A ^ B ^ C) + X[hook(5, 4)] + 0x4BDECFA9;
    D = ((D << 11) | ((D & 0xFFFFFFFF) >> (32 - 11))) + A;
  };
  {
    C += (D ^ A ^ B) + 0xF6BB4B60;
    C = ((C << 16) | ((C & 0xFFFFFFFF) >> (32 - 16))) + D;
  };
  {
    B += (C ^ D ^ A) + 0xBEBFBC70;
    B = ((B << 23) | ((B & 0xFFFFFFFF) >> (32 - 23))) + C;
  };
  {
    A += (B ^ C ^ D) + 0x289B7EC6;
    A = ((A << 4) | ((A & 0xFFFFFFFF) >> (32 - 4))) + B;
  };
  {
    D += (A ^ B ^ C) + X[hook(5, 0)] + 0xEAA127FA;
    D = ((D << 11) | ((D & 0xFFFFFFFF) >> (32 - 11))) + A;
  };
  {
    C += (D ^ A ^ B) + X[hook(5, 3)] + 0xD4EF3085;
    C = ((C << 16) | ((C & 0xFFFFFFFF) >> (32 - 16))) + D;
  };
  {
    B += (C ^ D ^ A) + 0x04881D05;
    B = ((B << 23) | ((B & 0xFFFFFFFF) >> (32 - 23))) + C;
  };
  {
    A += (B ^ C ^ D) + 0xD9D4D039;
    A = ((A << 4) | ((A & 0xFFFFFFFF) >> (32 - 4))) + B;
  };
  {
    D += (A ^ B ^ C) + 0xE6DB99E5;
    D = ((D << 11) | ((D & 0xFFFFFFFF) >> (32 - 11))) + A;
  };
  {
    C += (D ^ A ^ B) + 0x1FA27CF8;
    C = ((C << 16) | ((C & 0xFFFFFFFF) >> (32 - 16))) + D;
  };
  {
    B += (C ^ D ^ A) + X[hook(5, 2)] + 0xC4AC5665;
    B = ((B << 23) | ((B & 0xFFFFFFFF) >> (32 - 23))) + C;
  };

  {
    A += (C ^ (B | ~D)) + X[hook(5, 0)] + 0xF4292244;
    A = ((A << 6) | ((A & 0xFFFFFFFF) >> (32 - 6))) + B;
  };
  {
    D += (B ^ (A | ~C)) + 0x432AFF97;
    D = ((D << 10) | ((D & 0xFFFFFFFF) >> (32 - 10))) + A;
  };
  {
    C += (A ^ (D | ~B)) + (plainTextLength << 3) + 0xAB9423A7;
    C = ((C << 15) | ((C & 0xFFFFFFFF) >> (32 - 15))) + D;
  };
  {
    B += (D ^ (C | ~A)) + 0xFC93A039;
    B = ((B << 21) | ((B & 0xFFFFFFFF) >> (32 - 21))) + C;
  };
  {
    A += (C ^ (B | ~D)) + 0x655B59C3;
    A = ((A << 6) | ((A & 0xFFFFFFFF) >> (32 - 6))) + B;
  };
  {
    D += (B ^ (A | ~C)) + X[hook(5, 3)] + 0x8F0CCC92;
    D = ((D << 10) | ((D & 0xFFFFFFFF) >> (32 - 10))) + A;
  };
  {
    C += (A ^ (D | ~B)) + 0xFFEFF47D;
    C = ((C << 15) | ((C & 0xFFFFFFFF) >> (32 - 15))) + D;
  };
  {
    B += (D ^ (C | ~A)) + X[hook(5, 1)] + 0x85845DD1;
    B = ((B << 21) | ((B & 0xFFFFFFFF) >> (32 - 21))) + C;
  };
  {
    A += (C ^ (B | ~D)) + 0x6FA87E4F;
    A = ((A << 6) | ((A & 0xFFFFFFFF) >> (32 - 6))) + B;
  };
  {
    D += (B ^ (A | ~C)) + 0xFE2CE6E0;
    D = ((D << 10) | ((D & 0xFFFFFFFF) >> (32 - 10))) + A;
  };
  {
    C += (A ^ (D | ~B)) + 0xA3014314;
    C = ((C << 15) | ((C & 0xFFFFFFFF) >> (32 - 15))) + D;
  };
  {
    B += (D ^ (C | ~A)) + 0x4E0811A1;
    B = ((B << 21) | ((B & 0xFFFFFFFF) >> (32 - 21))) + C;
  };
  {
    A += (C ^ (B | ~D)) + X[hook(5, 4)] + 0xF7537E82;
    A = ((A << 6) | ((A & 0xFFFFFFFF) >> (32 - 6))) + B;
  };
  {
    D += (B ^ (A | ~C)) + 0xBD3AF235;
    D = ((D << 10) | ((D & 0xFFFFFFFF) >> (32 - 10))) + A;
  };
  {
    C += (A ^ (D | ~B)) + X[hook(5, 2)] + 0x2AD7D2BB;
    C = ((C << 15) | ((C & 0xFFFFFFFF) >> (32 - 15))) + D;
  };
  {
    B += (D ^ (C | ~A)) + 0xEB86D391;
    B = ((B << 21) | ((B & 0xFFFFFFFF) >> (32 - 21))) + C;
  };

  hashes[hook(0, id)].x = A + 0x67452301;
  hashes[hook(0, id)].y = B + 0xefcdab89;
  hashes[hook(0, id)].z = C + 0x98badcfe;
  hashes[hook(0, id)].w = D + 0x10325476;
}