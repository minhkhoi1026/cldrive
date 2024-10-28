//{"in":0,"out":1,"u8_gamma_to_linear_lut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float u8_gamma_to_linear_lut[] = {0.0000000000000000f, 0.0003035269835488f, 0.0006070539670977f, 0.0009105809506465f, 0.0012141079341954f, 0.0015176349177442f, 0.0018211619012930f, 0.0021246888848419f, 0.0024282158683907f, 0.0027317428519395f, 0.0030352698354884f, 0.0033465357638992f, 0.0036765073240474f, 0.0040247170184963f, 0.0043914420374103f, 0.0047769534806937f, 0.0051815167023384f, 0.0056053916242027f, 0.0060488330228571f, 0.0065120907925945f, 0.0069954101872654f, 0.0074990320432262f, 0.0080231929853850f, 0.0085681256180693f, 0.0091340587022208f, 0.0097212173202378f, 0.0103298230296269f, 0.0109600940064882f, 0.0116122451797439f, 0.0122864883569159f, 0.0129830323421730f, 0.0137020830472897f, 0.0144438435960925f, 0.0152085144229127f, 0.0159962933655096f, 0.0168073757528874f, 0.0176419544883841f, 0.0185002201283797f, 0.0193823609569357f, 0.0202885630566524f, 0.0212190103760036f, 0.0221738847933874f, 0.0231533661781104f, 0.0241576324485048f, 0.0251868596273616f, 0.0262412218948499f, 0.0273208916390749f, 0.0284260395044208f, 0.0295568344378088f, 0.0307134437329936f, 0.0318960330730115f, 0.0331047665708851f, 0.0343398068086822f, 0.0356013148750203f, 0.0368894504011000f, 0.0382043715953465f, 0.0395462352767328f, 0.0409151969068532f, 0.0423114106208097f, 0.0437350292569735f, 0.0451862043856755f, 0.0466650863368801f, 0.0481718242268894f, 0.0497065659841272f, 0.0512694583740432f, 0.0528606470231802f, 0.0544802764424424f, 0.0561284900496001f, 0.0578054301910672f, 0.0595112381629812f, 0.0612460542316176f, 0.0630100176531677f, 0.0648032666929058f, 0.0666259386437729f, 0.0684781698444002f, 0.0703600956965959f, 0.0722718506823175f, 0.0742135683801496f, 0.0761853814813079f, 0.0781874218051863f, 0.0802198203144683f, 0.0822827071298148f, 0.0843762115441488f, 0.0865004620365498f, 0.0886555862857729f, 0.0908417111834077f, 0.0930589628466875f, 0.0953074666309647f, 0.0975873471418625f, 0.0998987282471139f, 0.1022417330881013f, 0.1046164840911042f, 0.1070231029782676f, 0.1094617107782993f, 0.1119324278369056f, 0.1144353738269737f, 0.1169706677585108f, 0.1195384279883456f, 0.1221387722296019f, 0.1247718175609505f, 0.1274376804356474f, 0.1301364766903643f, 0.1328683215538180f, 0.1356333296552057f, 0.1384316150324518f, 0.1412632911402716f, 0.1441284708580578f, 0.1470272664975950f, 0.1499597898106086f, 0.1529261519961502f, 0.1559264637078274f, 0.1589608350608804f, 0.1620293756391110f, 0.1651321945016676f, 0.1682694001896907f, 0.1714411007328226f, 0.1746474036555850f, 0.1778884159836291f, 0.1811642442498602f, 0.1844749945004410f, 0.1878207723006779f, 0.1912016827407914f, 0.1946178304415758f, 0.1980693195599489f, 0.2015562537943971f, 0.2050787363903169f, 0.2086368701452558f, 0.2122307574140552f,
                                           0.2158605001138993f, 0.2195261997292692f, 0.2232279573168085f, 0.2269658735100984f, 0.2307400485243492f, 0.2345505821610052f, 0.2383975738122710f, 0.2422811224655549f, 0.2462013267078355f, 0.2501582847299534f, 0.2541520943308267f, 0.2581828529215958f, 0.2622506575296962f, 0.2663556048028625f, 0.2704977910130658f, 0.2746773120603846f, 0.2788942634768104f, 0.2831487404299921f, 0.2874408377269175f, 0.2917706498175359f, 0.2961382707983211f, 0.3005437944157765f, 0.3049873140698863f, 0.3094689228175085f, 0.3139887133757175f, 0.3185467781250919f, 0.3231432091129507f, 0.3277780980565422f, 0.3324515363461794f, 0.3371636150483304f, 0.3419144249086609f, 0.3467040563550296f, 0.3515325995004394f, 0.3564001441459435f, 0.3613067797835095f, 0.3662525955988395f, 0.3712376804741491f, 0.3762621229909065f, 0.3813260114325301f, 0.3864294337870490f, 0.3915724777497233f, 0.3967552307256269f, 0.4019777798321958f, 0.4072402119017367f, 0.4125426134839038f, 0.4178850708481375f, 0.4232676699860717f, 0.4286904966139066f, 0.4341536361747489f, 0.4396571738409188f, 0.4452011945162279f, 0.4507857828382235f, 0.4564110231804047f, 0.4620769996544071f, 0.4677837961121590f, 0.4735314961480095f, 0.4793201831008268f, 0.4851499400560704f, 0.4910208498478356f, 0.4969329950608704f, 0.5028864580325687f, 0.5088813208549338f, 0.5149176653765214f, 0.5209955732043543f, 0.5271151257058131f, 0.5332764040105052f, 0.5394794890121072f, 0.5457244613701866f, 0.5520114015120001f, 0.5583403896342679f, 0.5647115057049292f, 0.5711248294648731f, 0.5775804404296506f, 0.5840784178911641f, 0.5906188409193369f, 0.5972017883637634f, 0.6038273388553378f, 0.6104955708078648f, 0.6172065624196511f, 0.6239603916750761f, 0.6307571363461468f, 0.6375968739940326f, 0.6444796819705821f, 0.6514056374198242f, 0.6583748172794485f, 0.6653872982822721f, 0.6724431569576875f, 0.6795424696330938f, 0.6866853124353135f, 0.6938717612919899f, 0.7011018919329731f, 0.7083757798916868f, 0.7156935005064807f, 0.7230551289219693f, 0.7304607400903537f, 0.7379104087727308f, 0.7454042095403874f, 0.7529422167760779f, 0.7605245046752924f, 0.7681511472475070f, 0.7758222183174236f, 0.7835377915261935f, 0.7912979403326302f, 0.7991027380144090f, 0.8069522576692516f, 0.8148465722161012f, 0.8227857543962835f, 0.8307698767746546f, 0.8387990117407400f, 0.8468732315098580f, 0.8549926081242338f, 0.8631572134541023f, 0.8713671191987972f, 0.8796223968878317f, 0.8879231178819663f, 0.8962693533742664f, 0.9046611743911496f, 0.9130986517934192f, 0.9215818562772946f, 0.9301108583754237f, 0.9386857284578880f, 0.9473065367331999f, 0.9559733532492861f, 0.9646862478944651f, 0.9734452903984125f, 0.9822505503331171f, 0.9911020971138298f, 1.0000000000000000f};

kernel void rgba_gamma_u8_to_ragabaf(global const uchar4* in, global float4* out) {
  int gid = get_global_id(0);
  uchar4 in_v = in[hook(0, gid)];
  float4 out_v;
  float4 tmp_v;

  tmp_v = (float4)(u8_gamma_to_linear_lut[hook(2, (int)in_v.x)], u8_gamma_to_linear_lut[hook(2, (int)in_v.y)], u8_gamma_to_linear_lut[hook(2, (int)in_v.z)], in_v.w / 255.0f);

  out_v = tmp_v * tmp_v.w;
  out_v.w = tmp_v.w;

  out[hook(1, gid)] = out_v;
}