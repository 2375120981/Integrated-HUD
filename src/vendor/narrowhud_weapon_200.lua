-- Based on NarrowHUD 2.0.0 by luka189; see third_party/narrowhud200/LICENSE.txt.
-- Generated reading modules only; MDL host, no Chef loader or original drawing.
return function(chef)
local DATA = (function()
-- NarrowHUD game data, made by tools/make_data.py from the game's network config (game build 26251122).
-- Types: "id stand-in-name roles" (roles: the letters of the weapon fields the type declares).
return {
  build = "26251122",
  roles = {
    carry = { letter = "k", id = "788b9753", name = "n5jmvf" },
    chamber = { letter = "c", id = "4a893e74", name = "q6nx6da" },
    charging = { letter = "g", id = "88b7cf6d", name = "sadziaa" },
    fire_mode = { letter = "f", id = "49c250a6", name = "if5_pz" },
    floor = { letter = "j", id = "c3a3f66c", name = "dvpupm" },
    guide = { letter = "v", id = "f8d23bd2", name = "vnbwh6a" },
    heat = { letter = "h", id = "a5023836", name = "v0zaf3" },
    held = { letter = "y", id = "3132608f", name = "jkcsuw" },
    lock = { letter = "z", id = "9b738dca", name = "ih9ii3" },
    locked = { letter = "w", id = "1ddc206a", name = "tl1o1s" },
    magazines = { letter = "m", id = "ec64918b", name = "w5kykv" },
    options = { letter = "x", id = "31f86165", name = "ozvglfc" },
    overheated = { letter = "o", id = "f6275c53", name = "bybgjfa" },
    owner = { letter = "n", id = "3ccffa7f", name = "g5g7b9d" },
    pos = { letter = "t", id = "8bbeb160", name = "yapgpda" },
    reload_stage = { letter = "l", id = "cd889dbc", name = "r290mha" },
    remaining = { letter = "e", id = "69889752", name = "c60sehb" },
    rounds = { letter = "r", id = "d7a5d63e", name = "hhrfiqc" },
    rpm = { letter = "q", id = "4cbcc2a2", name = "v7xdy8" },
    selected = { letter = "s", id = "a74ef0d5", name = "x97c5fa" },
    slot0 = { letter = "a", id = "04ec5b95", name = "ip47m3" },
    slot1 = { letter = "b", id = "e525fa9c", name = "agg1dab" },
    spare = { letter = "p", id = "9a34c336", name = "mra3dwb" },
    underbarrel = { letter = "u", id = "67526982", name = "te9ea3" },
  },
  player = { id = "803159b3", name = "un6y1d", avatar = "u4d1h9a" },
  avatar = { id = "5d9752f9", name = "vvhx8ga", grenades = "du7kbt", stims = "ei6_t2", refs = "27c07e3e:u_tuw4a 913af9a2:awh5q9 0c09236b:caj8s4a eef04e89:rvanyac cf55c86e:xllcyj 20efbed4:pgqdzdb" },
  weapons = "0162dd9e cb5i1m cfmnqruxy\n01dcb81f rt6fam cflmqrxy\n04645757 r8qx1x cfklmnqrtuxy\n06887ef8 ayy2lmj cfklmnqrtuxy\n06b58c5d tspk_2d cflmqrxy\n0b9762b2 nor4hjc fkntuxy\n0df6deff g_b_smc cfjklmnqruxy\n0fab788f u2rur0f fghlmoxy\n0fe87029 baj_bt cflmnrtuxy\n104184f7 xtkwjc cfklmnrtuxy\n108163bf p4p3w1g cflmqrxy\n11167bfa q_ds4ja cflmnqrtuxy\n11b34d0d hhgr6ab cflmqrxy\n11d8c98b d3kc2ja cfklmnqrtuxy\n1220e497 fy1w9ra cflmnqrtuxy\n12962fc2 vb9v6c cfklmqrxy\n1387c1da o11x9tk cfmnqruxy\n13a71430 zn0uqwd cfmnqruxy\n14c9c273 ooyfyk cfmnruxy\n15ae0889 zoaemkb cfklmnqrtuxy\n15f1a9f0 hsiotza fjklntuxy\n16425925 asugoqa abcflnpqstuxy\n17783758 h9cayib fghjkmnoqtuxy\n17b02218 pyo51wa abcfklnpqstuxy\n17db8107 eqxvds cfjklmqrtuxy\n193ffddf fhqmg0a abcfklnpqstuxy\n1962a5a9 b8ayvi cfklmnqrtuxy\n1cb22371 r0sk8kb cfmqrtxy\n1cf134a2 ve_wqb cflmqrxy\n1d3b01d7 vygkbwa cflmnqrtuxy\n1d568224 dwe3sjg cfmruxy\n1eabc11a huvwede cflmqrxy\n1f3765c1 mbrrnm cfklmnqrtuxy\n1fffb81f c459gjb cfjklmnqruxy\n2166c7a1 yqgkp5b cflmnrtuxy\n21ce6db8 i73blf cfmnqrxy\n21ef3f7d h_rsvaa cflmqrxy\n228e0659 onx7x2f cfmnqrtxy\n22929ccb m8qm65 cfklmnqrtuxy\n2345fac7 rlnkruf fghlmoxy\n2363e364 vchepva cfmnqruxy\n240cc071 lw_nv2e cfmruxy\n2596fa0a u5iqbia cfmnruxy\n2605e68d lzrzpaa cflmnqrtuxy\n26acc614 bhy750 cfjklmnqrtuxy\n2ac9b588 zjqdu0 abcfklnpqstuxy\n2b651283 l4iswcb fkntx\n2cc09a42 e5r2_cb cflmqrxy\n2ce3f1c2 i6w8guf cflmqrxy\n2cef5e3b pko9xwb cfklmnqrtuxy\n2d552a28 fs2owp cfmnqrtxy\n2d6a81f7 p56r7gc cflmrtxy\n2ddd091d tnc2nwa cfjklmnrtuxy\n2df95dfe jq39fx cfjklmnqrtuxy\n2f027b59 hxz583a fknuxy\n2fad831f ouwua6a cfmqrtxy\n30294946 h2zhqia cfklmnqrtuxy\n303d2220 cltj79b cfklmnqrtuxy\n30b55bbc yvdekca cfklmnqrtuxy\n311cd513 zsrkd9a cfmqrxy\n314a1bf5 hg8xdoa cfjklmnqrtuxy\n3219a457 x33zuna cflmqrxy\n3244dc49 na3ik9 cfklmnqrtuxy\n32fba243 t3doqng abcfjklnpqstuxy\n33a9a66c sdsikk fklntuxy\n3416fff4 lczg51c cfmnqruxy\n3478da46 y1uve6 abcfklnpqstuxy\n35fba577 be5nqzc cflmqrtxy\n3622f8dc khs7fa fghklmnoqtuxy\n362577f7 vqjgpra abcflnpqstuxy\n366d3622 q3otzqb fghjkmnoqtuxy\n36d20472 lcf66l cflmqrxy\n36fcbd00 rl1ken cflmnqrtuxy\n380e3e45 ycfwzkh cflmqrxy\n384511d9 n_vdsea cflmrxy\n396381a9 pjwb87a cfmnqrtxy\n3ae02f80 phx4lmc cfmnruxy\n3b60cae4 o_fyw1b abcflnpqstuxy\n3b718900 gy43ise cfklmnqrtuxy\n3bd04c18 bf0m9l cfkmnqruxy\n3bf357e5 w0cy0qd cfklmnqrtuxy\n3c3cec57 o8n_doa cfmrtxy\n3c709c50 zy_r2w cfmnqruxy\n3cb2f6ef j1fsq0b cflmqrxy\n3d538455 nu2o21a cfjkmnqrtuvwxyz\n3d7ed060 s4ngu2a cfjklmqrtuxy\n3e51c09b j8kw9_ cflmnqrtuxy\n3f87a7e8 jpekgac abcfklnpqstuxy\n3fa67f3a z1wgo4c cflmqrxy\n3fcc00c4 mghew3a cflmnqruxy\n4091a284 xiet4d cflmqrxy\n41de83ec z0s4rn cfmnqrtxy\n428b28d4 jywz6vc fghlmoxy\n42a6b5ba t24vbr fghklmnotuxy\n4321fb69 v36fp0 cfklmnqrtuxy\n437d9eed cf635_f abcflnpqstuxy\n43f3fd0a m8kmwum fghlmoxy\n43f7d548 wua58n cflmqrxy\n447bac84 xv7yjjb cflmqrxy\n46b64e6c c9wx3qd cflmqrxy\n479c3dc3 hk9wsza cflmqrxy\n47caeb33 d8ba58b cflmrxy\n48643cfd anefmq fkntuxy\n4953af80 aebzqla cflmqrxy\n4a6da2f4 tkbd10d cflmqrxy\n4bef0443 vi9u5xb fghlmoxy\n4c0b5b68 y5c92z cflmqrxy\n4c9d9517 g_e9cq cflmqrxy\n4daea8e1 vueow2b cfklmnqrtuxy\n4e64c4dc cioda4 cfmnqruxy\n4e87d68d dtkk1fb fghlmnoqtuxy\n4ee55ac0 x0ngm5g cfmqrtxy\n4f57a016 zvx33h cflmqrxy\n5198e974 s3fcuma cflmqrxy\n521229d8 o6pa72 cfjklmnqrtuxy\n530e19df e11ivoc cfklmnrtuxy\n532cf6bd v5bkaja cfmrtxy\n5590232e a1nulw cfklmnqrtuxy\n55b5b982 foz1o0 cflmqrxy\n5652ed49 rrugh0c cfmqrtxy\n56c0a062 x9xf7ge abcflnpqstuxy\n56c65009 zb9a7rb cflmnqrxy\n56e55184 l6t3hub cflmnqrtuxy\n57079738 cz7jsqa fkntuxy\n576582ee tlqj89 cfmqrxy\n589b3518 zxpwm7a cfmqrxy\n58cd3b3d kmmxe7b fghlmoxy\n5ada6b71 oafcf7 fghklmnotuxy\n5b4312d0 qzc20g cflmqrxy\n5c813e43 ho_zkj fkntuxy\n5e0cd6f6 j_9h5e abcfklnpqstuxy\n5f3517bf fsxuztb cfklmnqrtuxy\n5f498a97 ghf0k8 fghlmoxy\n603f3825 xwyv6va cfkmnqrtxy\n60cac78a h2u8a4d cfklmnqrtuxy\n60f45420 b7fc4yb cflmnqruxy\n61e573c5 xq431j cflmnqrtuxy\n656d507b v_6isba cfjklmnqrtuwxyz\n66247907 pnfembd cflmqrxy\n66d1da14 blsxt_f cflmqrxy\n66f5d393 p5xmp1e cfjlmnruxy\n671c9d10 q_u2bmc cflmqrxy\n674b88a9 o97598 cfmqrxy\n6876b30a ug33y9f cfklmnqrtuxy\n69971ef9 g7cylgd cfklmnqrtuxy\n6b2c3bed kbv6zx abcfjklnpstuxy\n6b47e064 yl2gysa fjklnqtuxy\n6ba62b83 fkgswoa cflmqrxy\n6c26a65d bk_010a cfklmnqrtuxy\n6c558aa5 r1mvgg abcflnpqstuxy\n6cc38f79 kur75r cfklmnqrtuxy\n6d3f8345 uc27r8 cfmnqruxy\n6d745627 oxnktga cflmnqruxy\n6ec2a850 lh9psp cfjkmnqrtuxy\n6ee7730f vrkgtza cfmqrxy\n6f536276 xucjhyb fklntuxy\n7405f976 t2d8jce cfmqrtxy\n74a83b1a vkviu1b cflmqrtxy\n7559f271 wz3jut cfmnqrtxy\n756a4e4d hbae32 cfklmnrtuxy\n76120872 n03j_i cfklmnrtuxy\n76b81cf6 v6a39yb cfmqrxy\n792fcf7d v7ah_nc cflmqrxy\n7b32b291 ugrii2 cflmrxy\n7ba2fa73 lean2wa cflmqrxy\n7bfb2e06 wg3mv1a abcfjklnpqstuxy\n7dce85e3 mfjhk7 fghklmnotuxy\n7ea9ed9a xm04dy cfjklmqrtuxy\n82a8d3c2 en4ydjb cfklmnqrtuxy\n83d1036e t2a5_nb cfjklmnqrtuwxyz\n8583e435 xjcgsqe cfklmnqrtuxy\n8653fcbb we86rxe cflmnqrxy\n866289c6 vk5r_v cfmqrtxy\n86709cb9 y1lf8zc cfklmnrtuxy\n8696c4f0 tnfqska fkntuxy\n8a3c6fee atz1va cfjklmnqrtuxy\n8af9104d mo9cpba cflmqrxy\n8b35c29b jynqi_ cflmqrxy\n8c0aee6e pcdv3w cfjklmnqrtuxy\n8c9c57bd d7w57eb cfmqrxy\n8e49803f tml8eha cfmqrxy\n8ed281fe gmfgr9 cflmqrxy\n8f7838eb fnodub cflmqrxy\n8fcdd35c vqgjhhc cfklmnqrtuxy\n903649ec rq31jta fjkntuxy\n90e6bc26 d882sag cflmqrxy\n910092f7 wlqsjcf cflmqrxy\n913cc553 bsb6dbb fjkntuvxy\n91fafc27 x_j7xb cfklmnrtuxy\n93e5c833 nl8xrab cflmqrxy\n942a0601 pglrgxa cfklmnqrtuxy\n947ed108 wgx6kjb cfkmnrxy\n95c5dc52 g_lw6nb cfmnqrtxy\n960653cb kzxaipa fghklmnoqtuxy\n967a3fed ia4hs6c cfklmnqrtuxy\n96c78961 xtco_xp fghjkmnotuxy\n96c8cffd lp1so cfklmnqrtuxy\n985c00c1 j8b25ha cflmqrxy\n986600d1 kxp2yo cfmnqrtxy\n992ff297 yfh87yd cfkmnqrxy\n9a109898 k3a8cca cflmqrtxy\n9a57488b ulzw2bd cflmqrtxy\n9b692603 agsgufb cfmqrxy\n9c06f074 ub3mcka abcfklnpqstuxy\n9c2493bb qgnxc5 cflmqrxy\n9c2e7f43 sjviib cfjkmnqrtuxy\n9c6e0012 p7z6_af cflmqrtxy\n9ca7fac8 jc8o2bb cfmnqrtxy\n9ce82ac5 lhxfy_ fghklmoqtuxy\n9d474323 f3wys2 fghmnouxy\n9df87863 sabad8c cfmnqrwxyz\n9e18f0cf znvy6p cfjklmnqrtuxy\n9f16a5a2 ia44ole cfklmnqrtuxy\n9f489d46 glqzce cflmqrxy\n9f76be2f n_tj4p cfmrxy\n9fdd94c0 atms0y cfmnqruxy\na0c664de i8z202 cflmqrxy\na1b9967a etbwa4a cflmqrxy\na2154c5f n9ixixc cflmqrxy\na261d7f0 g8oq5jb cfmqrtxy\na37f0894 kih3u3b cfmnqruxy\na3d75b9c n6p87sc cflmqrxy\na41ddfcd c8bzfgk cfklmnqrtuxy\na4eff4fa gqvwvd cfjklmnqrtuxy\na5f78db3 zqjzayb fghlmoxy\na5fa507c tupyfub cflmqrtxy\na6445802 p640rzc cfklmnqrtuxy\na6e06a41 cufoss fkntuxy\na7bf4a1a ydgjp6c cflmqrxy\na85c14c9 hn1gt4 cflmrtxy\na8a3d145 vjxp4bg cflmqrxy\na9e88c96 unppkbd fghjkmnotuxy\nab38cade bhd28qa cfklmnqrtuxy\nac1eb0d8 au8yh_b cflmqrtxy\nac5e38f5 q9lm7k cflmqrxy\naca39ec2 fbak2wd cflmnqrtuxy\naca565f4 n4vziwa abcfklnpqstuxy\nb00e2017 w5vz9i cflmqrxy\nb2bfd847 mxfr0g cfjklmnqrtuxy\nb30f446f v6jii8j cfklmnqrtuxy\nb3246bb7 sv_6kpa fjklnqtuxy\nb4a17af7 f00yfpg fjkntuxy\nb4ac0dfa lrynvoa abcflnpqstuxy\nb551b138 ygo7dx cfmnqruxy\nb5de6995 i7owagc cflmqrxy\nb697955d omhdnm cfjklmnqrtuxy\nb72b1558 qpa42ja cfmqrxy\nb747653b gj5ez3a cflmqrxy\nb770b0ae ls2py8b cfmqrxy\nb7e3b4ba qp93ob cfmqrxy\nba161726 w6vav9 cfklmnqrtuxy\nbaaf62c6 q4v17ae cflmqrtxy\nbb06e598 t1deyec cflmqrxy\nbbdb37fc yc1hc2b cflmqrtxy\nbd5f17dd k04_p7e abcfklnpqstuxy\nbe95e875 bua_pld cfmnqruxy\nbe9b793e njgfbx cfklmnqrtuxy\nbf35608c z2j6__c cfkmnqruxy\nc0e5aa7f nphgvya cfklmnqrtuxy\nc0ff5282 xbn9pc cfjkmnqrtuxy\nc12ff9b6 zdwebbb cflmqrxy\nc198eb1f dd131qd cflmqrxy\nc1a7efde y9j07z cflmqrxy\nc3457794 uknvqtc cfjklmqrtuxy\nc4235b66 nqeyoda cfklmnqrtuxy\nc59a82aa l26sw3b cflmqrxy\nc7448f32 thqhyt fkntuxy\nc7dfd9eb vdvv_d cfklmnqrtuxy\nc920c2d3 v7fgk0b cfklmnqrtuwxyz\ncb5e2fe5 k_l4zkc cfmqrxy\ncbb08197 l_k4hn abcflnpqsuxy\ncbb5137e ndgokac fjkntuxy\ncbbe1757 m_t_gk cflmqrxy\ncd0e4b4a ptqxg5 cfklmnqrtuxy\nce49e408 arusi5d cflmqrxy\ncf8a216f o2oevj cfmqrxy\ncfaa9ddc mbahpjb cfklmnqrtuxy\ncffb9569 h1of7_ cflmqrxy\nd100e0c8 rdl422a fghjklmnotuxy\nd17fa690 je8jvj fghlmoxy\nd372022f e8y8yka cfmnqrtxy\nd37ac78d j7qe90 cflmrxy\nd3c9a08c bukir_ cfklmnqrtuxy\nd496b132 tt8fmz fghklmnoqtuxy\nd5e0448b hbtp4i abcfklnpqstuxy\nd724a2f9 v9tes cfjkmnqrtuxy\nd7b78574 rc01gvc cflmqrxy\nd96a6ff6 n5x07wa cfmqrxy\nda0f356e y1pjqca abcflnpqstuxy\ndab37dc8 v5aq5zb cflmqrxy\ndb3250ac w1ev9w cflmqrxy\ndc85eae0 cdusa7b cflmrtxy\ndd0943b3 se9a21 fghlmoxy\ndd7fc64f t31kcoh fkntuxy\ndd9f1091 x3_zfz cfmnqrtxy\nde4a23b1 wh0u6q cflmqrxy\ndef25ee4 fg4kmyl cfjklmnrtuxy\ne1f10066 x4eez5 abcfjklnpqstuxy\ne2ab08d5 d929yh cfmqrtxy\ne3d29b1f flwjtq fghklmnotuxy\ne4016fc8 lixbksg cflmqrxy\ne42d5902 kup_rdc cfklmnqrtuxy\ne44d791e t9094pc cflmqruxy\ne45066e4 fpkhqaa cflmrtxy\ne645b6ee htx7gy cfjklmnqrtuxy\ne6adb635 r243ek cflmrtxy\ne867d2a4 ro5zvpb cflmqrxy\ne8e363c2 ijid6 cflmqrxy\ne8fbaa5a n5m8vcd cflmqruxy\ne92f56ed prs40ha cflmqrwxyz\nea366586 lrvzitd cflmqrxy\neb38d34e zshdarb cfklmnqrtuxy\neb621141 g4enegg cfmqrtxy\nec516bbd jwajvc cfmnqruxy\nee956607 emqrkfc cfkmnqrxy\need3b279 y18wpo cflmnqrtuxy\nef108792 gtikxeb cfmnqruxy\nef423da7 r21mled cflmqrxy\nefa02c2f tdrcwja cfklmnqrtuxy\nf0aa3287 vhiibka cfmqrxy\nf18d75e5 utnls5a abcfklnpqstuxy\nf1dbc135 lp5jqga cfkmnqruxy\nf2c595ea so5lnk cfjklmnrtuxy\nf3108c72 bzglyn cflmqrxy\nf3d3ab0e b_rwkhi cfmnrxy\nf47c41c8 c4ja4qf cflmqrxy\nf53d4725 a97mzja cfmnqruxy\nf5ff8d80 vxyfjb fghlmoxy\nf697c0ce qldj_r cfmqrxy\nf6e0573f w4ku6pb cflmnqrxy\nf7335279 qt9arse fghlmoxy\nf84e3448 bet0nca cflmqrxy\nf8508b98 sb9b5ib cfmnrxy\nf867203c tzvkvjb cflmnrxy\nf86855c2 ln3c6m cflmqrxy\nf8b4b238 t1dv17a cflmqrxy\nf94a73b3 iw3a4hj cflmnqrtuxy\nfa6ddf17 ngjbpfg cflmqrxy\nfb8c4465 gp65z6c fghkmnoxy\nfbc7f2e1 so8utv cfklmnqrtuxy\nfbd58864 ekpktpa cfmnqrtxy\nfc1ece86 tpge9n abcfklnpqstuxy\nfd115815 a0v0u7b cfmqrtxy\nfd585726 e5j54r cfklmnqrtuwxyz\nfde8ab3d tc9txxa fghklmoqtuxy\nfe07a595 fzzqcab cfmqrtxy\nfe3cf398 xle70k cflmqrxy\nfe760204 ny71w4j cfklmnqrtuxy\nfeae4480 jnqcrdc fghlmnotuxy\nff1a600e ne17gi cflmrtxy",
  backpacks = "066c9036 gyo1rh eknt\n07170cd0 m4hit2 eknt\n0ab1da38 yehsgn eknt\n0dff968f ped7xtd ekn\n139293f3 wsf9spc eknt\n219da219 pgooz8 en\n24bfe86e aovmr4d eknt\n32fd58bf raqnyi eknt\n42eb8b5a i739ida eknt\n447380d4 mbe7zzc eknt\n61ea0c42 hfgntfa eknt\n66d03a73 g5hky2c eknt\n6c17c3b1 gm_1w9 eknt\n764f37a0 zd15_ke eknt\n816a11e0 oxgf3v eknt\n8b40a204 gy7kqp ekn\n94ff3b20 po3v8ob eknt\n96cb35d7 qp_xmbb ekn\n9f9ef431 kfc4b8 eknt\na42ace6a lnlden eknt\nb32572a6 uubzxyb eknt\nb5b092f9 fblrz4 eknt\nb9ea8c7e xan7ggd eknt\nbb2729e9 seqbw5e ekn\nc4bf68fd b7h2qjd eknt\ne80c471f d7139m eknt\ne866a492 ku9copa eknt\nec1b10be fsdmxxb ekt\nee341a1b ywbkord eknt\nf439bdce uo1re8c ekn",
  others = "016ad05b do356cc\n02e37449 oaj9bd\n035c6912 t1gnc4b\n04831f03 ly6rtl\n04f392ce q9t3tdd\n05256e47 tmeyi8b\n0528d3f1 c6wcflb\n0614692e n4wfo2h\n063864f4 zczpoq\n069fe281 b3pekpd\n06df063d o55naab\n075cdabd bqfkdl\n09162638 m4ev76a\n0a0aca1e vf8rvac\n0a3ac4b7 v5v37gc\n0a3d04da tjon_rc\n0a84375b e28tuk\n0ae6d36d lxo950a\n0b1e7ba8 simyap\n0ba3b9b6 bkfktxe\n0d212647 lzwlgz\n0d3766ad z43bx7b\n0df416d3 cai7za\n0e1c32ff p5qgs5c\n0e3813da dqhnwme\n0e4657e1 j4gw1ba\n0e704a37 ggm9s0\n10662676 kdldaaa\n10a7a547 ai7j9oc\n110f5501 hj9dje\n11999d28 bs1zp\n12e6e20a hpn948d\n12f13143 wg4ozib\n12fb5348 e3p4b5b\n1350175f piviuka\n14111926 jwzw9e\n1543c83c pkufvu\n15d8ff78 ez1lkcb\n1610e8f7 hdtk22f\n16d649b7 b5u0xl\n17d1f072 a7ac5k\n1844523d fzoa2h\n18ba422a cbly88\n1958acb5 o3hbiq\n197f01b9 sli5uea\n1992a002 i5gpcnb\n19e070f1 vub7eae\n1bc27c36 n7e__6\n1bec6c1a m1thuya\n1ca1b438 t7pqo5b\n1d69de7e f2odupa\n1dbd1418 g5obbba\n1e46a0ba x2eg91\n202a87e4 mrz_wva\n2199ab14 ifjg6\n22454df5 rmzoopa\n227e74f7 gehtvdd\n232f7cfb e5552hc\n236532ca kavvkhb\n23e8951a vkke9h\n2432c30a y3fk0fb\n250845e3 ah3cltc\n25e3ede2 aq6wi6a\n25ed6c5a u1lph2b\n282f2449 k8s9n1c\n2896eb7a ybaduic\n294f0f56 lk2b1pb\n2b3769f5 r2pg2u\n2c0c01f7 thovzda\n2c2d0375 bsdeqnh\n2c5ec231 uxyp8a\n2c5f2ee8 wwyruuh\n2c936b1a oq3wha\n2dabc7a1 c1r54va\n2e22de0c slidfyd\n2e4cd57e zmom_lf\n2e756a55 il5m26\n2ee9b0a8 nde_ss\n2f13298f kxdhu6\n2fa146c1 oi4lc8a\n300010c2 qrt6h8c\n300d0945 k9f16bc\n3164f902 ko52k6a\n316cf44f a9t0xib\n326c559b jzf7s7c\n32740ce1 mcjnaoa\n3347eae2 bz7u4lh\n34e1bc3a lcrjw4a\n3557a973 yj1loyg\n37193958 ysk4yge\n385c8416 i1834ub\n388b859b cozbx0a\n388c70c6 rwlcmga\n39d74051 pbkoh_\n3a9a3ab0 ddb66ra\n3ab8c79c t7niita\n3b39f325 a9w_yq\n3bd94e74 fjb9_m\n3ccba54a b3ljjna\n3e08f90b np_n5fa\n3e4a6f81 ccwid6a\n3e9bf7f1 tkqs5mb\n3f1df6e6 yvza6h\n3f63a4d0 q9685z\n3f66ee0f uc_av0a\n3f7f6f33 qoksea\n40b7da1a xlx9vi\n40d759ad hwbjdg\n40ff7f06 ffc2lb\n41c028ad neb_jea\n41d645a7 xwz5fr\n427dd56b pu0vi7a\n435bd81a hbr8jx\n44b569d8 d69e7b\n471166bf wtbl_rb\n4796fd39 ois60eb\n47c89128 iy6yvj\n480608e4 c6p_ne\n48bfef27 ijus8v\n4a62a3a9 xg0b6ka\n4b0981ce p8r4bk\n4b3aa0ac z1wvlgb\n4bc5ef4f tgrw4ha\n4bcf66c1 b3i593f\n4c513556 jiludqb\n4cc82e42 k4avz2\n4d57c925 vw3ze5a\n50c22dd1 zfzkup\n5246ed5d cc24eza\n52a928b8 wfav0kd\n52ab0f35 j8lqirc\n52be0afa ub36ce\n5368c409 fa2o6wb\n54fb3142 khml1gd\n55404d5c rmcmu1h\n584af088 v64v0nl\n58a6b551 adlqlz\n59ceb175 yy4d2ib\n59db0275 nu7tv1b\n5a57ec03 v5f1ibi\n5aa66d27 o0uo3ja\n5ad45913 k4tb20\n5b15c8b1 vu8eqpb\n5b1b61bf twkjfaa\n5c362825 hxt3ksd\n5c374763 pp683d\n5c957a4f sc209a\n5d1874a5 mgfeuvd\n5d26d816 t70tq5b\n5d2ad31e ajrd8a\n5d9752f9 vvhx8ga\n5e48caee n3w73e\n5e95439c m_lpruc\n5ea61948 msxll_b\n5eacef33 h_k33x\n5f4c079d tet0x7a\n5f71ab1c p4sq0\n633dc1fd xo0i2t\n63d59833 y3yg84\n63ef5e70 amtigoe\n65e0a9f9 rkprhx\n67e52a93 ukhwz6b\n681b1f5f zz5xydb\n68206c6c sota8d\n694998e8 l7gpjra\n699d97bf jgtq5de\n6a073cc6 k477i5a\n6bd7b324 g4950ta\n6cabe8d6 q643bf\n6d121eac gcpwdb\n6d19af0c bdvqkca\n6e58d501 ay61gqa\n71a6d908 k1m_wgf\n73096f3a mjdtxk\n754b27f3 zoqxswb\n76121bca uv0f2y\n76222958 ga7nzea\n76e395be c_z820r\n76fd7f40 t1hg3ka\n77a7220c qa5eg8g\n77b60330 g2gd95\n79229595 go4k8b\n79bc04a2 h_iqtf\n7a5f71c2 kuqg11\n7ac91d9f ggihqlg\n7aff173b fl0pgt\n7bd09cce bkwujzb\n7c409383 acznuz\n7cc58292 ckdu_9c\n7ccda1fd ztpmrp\n7d16f96c ducgny\n7d18f080 xuquzq\n7dfd8294 pb2aoib\n7e15b7b7 aenxhur\n7e5c3991 dgrniza\n7ee31704 divj9i\n814c5e3d ypxjgib\n81cd79d7 cltkced\n8290e00a z7dp9b\n83164c66 scdyn3d\n841120c9 b4c63q\n86588e3a r663m2\n870a7011 hx6squa\n8714a611 a4s6kab\n88ef4e78 gedsdfb\n893c8d4b o8fk4c\n8a2f8aea ir_vqaf\n8b2ee1ef j7654q\n8b49fa83 up6qmb\n8cf62663 gj9ftna\n8d501cff hzwyye\n8d84ddce rs9ym4a\n8d8612a6 claqsn\n8dc48815 wjr990b\n8e3d0f3e r88rb7b\n8f395664 x0xeo8d\n9047e466 t2gald\n90911398 oo_cysa\n909d70a8 mzd6hq\n90e1c2e6 y1v25t\n91a3f64d ip6np4a\n91ebbb62 vz42ebd\n91f10108 nrhk99b\n92805c4b uo3hyob\n92961ea8 y5dq10a\n92ab71b9 biak6hb\n93f77732 ic0iage\n97425204 wegn6s\n97810ed4 j3v4r0c\n97fa018b p1xx7rb\n98bcefdc cd7hzia\n9a2b9962 gv_4i9\n9bc82452 kbck_1d\n9c55417a m_bg2y\n9d5c0899 re84n4b\n9d5e0955 bqo326\n9dfe94e2 gw5pdn\n9e7c7dae czdp8va\n9f8f7978 ou2if_c\na173c570 mt8lgqb\na21aa238 rpnegeb\na2dacf51 kagaaxa\na31625eb lopnqc\na328719e voi1cka\na342b39c b6uqfzh\na35323b6 qe6vkbb\na3c69a38 zxh4qea\na4c0f05c wzz25v\na4e5b53d ngwkd3a\na50b25a2 cp6nggd\na7635820 bi53lad\na850d1ea zjb4j7b\na9be1db4 lval0pc\naa399519 tfu7pma\naa3bb1f1 wmc8rif\naa81fa86 xjni1kd\nabd2abbd g340np\nabd39ddc zzn446\nadf44a31 qo2ny6a\nae35e7d7 z9630_\naf1edef6 vpimb6a\naf5c87f7 bl7guba\nb02559d4 ddfdjfc\nb0b9f710 xp006w\nb14934be h28zoja\nb3d4f788 knao2d\nb3fe387c r4fx4xb\nb534cf53 xc7pzu\nb5806815 sedw9t\nb5badd9f sxg7gq\nb5e759dd qhyd8ic\nb6e028e0 rcdj3g\nb74909be gpjbt_\nb7caeb25 n91uf6\nb85fdd15 zf1ehq\nb89fb64b sbq5e\nb92645a7 wx6w26b\nb936384d wyjxo5g\nb947136f bknywoe\nb955e332 qqoq4z\nbae3f0a6 aiod29\nbaff629d qlag98a\nbcb7db19 fm11gvd\nbde66196 qo8goca\nbe6d7e88 oib40wa\nbe800f6b qwp0aw\nbeb09041 r4qvymb\nc086198b si0w4_d\nc1470645 k_ayiab\nc1a624f4 i80cf5\nc208c35d r5gp6v\nc2190fca dejlql\nc342c783 yv229nd\nc4999b5a rpeucf\nc5c670cf x4ymwr\nc5d2dc37 gw175db\nc743473d vic_bq\nc8102937 b9hj4oa\nc88cac8d r8b97rb\nc89adf0c c_abhh\nc93e6559 oevnsda\nc9680f06 cer7rsc\nc9c82488 g0cusga\nca2e4080 f14re7\nca6aa021 xsxiq0\ncbaf7c43 dwhwpkc\ncc26c744 mw0yfwg\ncc708c80 jc28ywc\ncdb1e951 x8xgwid\ncdccbaa6 agh4jfa\ncee8a56a e5lgqk\ncf77fa4b bsc0uba\nd03a263f qrsxwkc\nd0584627 vrtmov\nd0e4a852 jl3cvr\nd1632c83 wn9t9c\nd1704f67 ay6p06\nd3e4682e gp9hfkc\nd4398a6d yhia2xc\nd4b864fb gze9z3i\nd55e91c6 onmf43b\nd675eb10 ozb4a6b\nd6f22bc8 pmoi3vd\nd6f2d68f milhpv\nd6fcdf7f fndpaoa\nd7dd3d12 a_lv66\nd7dde809 sioaja\nd8434d8a sabj8v\nd87eba03 co3mg\nd8a779ba b80lrlc\nd8bc4dd6 qmchqo\nd8c9f173 rmo5r_\nd9f738f7 mp1oyk\ndb56604e cgo61ad\ndba1eefb l0fuxj\ndc9cb1a0 h3i_i2b\ndd35fa59 pyhx5d\ndd7c491e kqzrkka\ndde69d3c eiobko\nde71f699 qhc1n2f\ndeeeea0b tdpbyg\ne085bb63 d8l3l6\ne0b3c3c2 xkp7boa\ne15d6bbb kztzqo\ne233f374 l1nngca\ne2ec99c6 zmn8xba\ne308e8a7 csum__a\ne4055bb1 rz4mndb\ne4355027 twx711f\ne445d96c z23zbp\ne4ff5d75 s0t9sh\ne776ac13 d7pmbsa\ne8328961 wsxy_0\ne838cdee gty38\ne86fb7d6 ikpm_vb\ne8708109 vrz21mb\ne8a9014b tgyiaif\neaa49812 y1q9mbc\neb08206f qnjq4w\neb784ac7 v2gatwf\nebc18699 xoxiinc\nebcffb75 imz0vc\necbda4d6 rbgokoa\ned02cc7a oaq0q8a\nefb4a22e ee_mx7c\nf130eab6 gb2gx7c\nf245e76f maaax5\nf259751e o61wgqa\nf32cebf7 nyat8jc\nf3ebe1ab v3h_mcs\nf45f531b ui1u2bb\nf4f6e5c8 t0z9fmb\nf5553215 qxcid\nf615bf3d w4brroc\nf67fc09f wkwkkd\nf72f7061 yxw6d7d\nf88ae9a1 bvrhp9a\nf96b8f11 q7jjyj\nf9b833b2 ogrbcdd\nfa4d0a5b k266ob\nfb36c186 ihri6gh\nfb771b86 llij8vc\nfb99fb71 e32ffye\nfba8eacd uh_i01f\nfd6cdb49 wt221pa\nfe199ea7 mt9g41\nfea8ed8d r2ddjzc\nfecf05c3 qpberpa\nff14374b jxok1qa\nff18dcb2 w114qw\nff3cf8d8 oxqa86c\nff55ea5b oheju3\nffbd5c9a pu17hcf",
  fields = "0162dd9e 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e b741b700 5e5865a0\n01dcb81f 3132608f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e c336a25c 078c5d3b 60e13e87 cd889dbc ec64918b d7a5d63e 4a893e74 da1ad977 256605bd\n04645757 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n06887ef8 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 a5fb73ef\n06b58c5d 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\n0b9762b2 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\n0df6deff 50ac6619 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n0fab788f 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\n0fe87029 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc ec64918b d7a5d63e 4a893e74 7030c54e\n104184f7 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e ec64918b d7a5d63e 4a893e74\n108163bf dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\n11167bfa 3132608f 50ac6619 8bbeb160 20605662 2d27198c 3ccffa7f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 c336a25c 67526982 31182caf 49c250a6 31f86165 09d8bef4 cd889dbc\n11b34d0d 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4\n11d8c98b 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n1220e497 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n12962fc2 c336a25c 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 50ac6619 403d474a 788b9753 99901914 1dd07f05 39d141d6\n1387c1da 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 3ccffa7f 50ac6619 3132608f 67526982 31182caf da1ad977 256605bd\n13a71430 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\n14c9c273 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 7030c54e\n15ae0889 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n15f1a9f0 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 7030c54e cd889dbc\n16425925 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n17783758 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b a5023836 f6275c53 88b7cf6d\n17b02218 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n17db8107 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n193ffddf 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n1962a5a9 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n1cb22371 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf e4158f0b c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n1cf134a2 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n1d3b01d7 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n1d568224 50ac6619 7030c54e 49c250a6 31f86165 09d8bef4 078c5d3b 60e13e87 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 14d334b6 c4c9b9ef 67526982 31182caf a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 9a9b14c4 c336a25c\n1eabc11a 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n1f3765c1 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n1fffb81f 50ac6619 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n2166c7a1 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc ec64918b d7a5d63e 4a893e74 7030c54e\n21ce6db8 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f\n21ef3f7d 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n228e0659 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n22929ccb 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n2345fac7 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\n2363e364 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\n240cc071 50ac6619 7030c54e 49c250a6 31f86165 09d8bef4 078c5d3b 60e13e87 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 9a9b14c4 c336a25c\n2596fa0a 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf\n2605e68d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n26acc614 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n2ac9b588 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74 788b9753 99901914 1dd07f05 39d141d6\n2b651283 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd a5f83fa0 9256767e 7f6b358d 49c250a6 31f86165 09d8bef4\n2cc09a42 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n2ce3f1c2 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n2cef5e3b 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n2d552a28 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n2d6a81f7 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\n2ddd091d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n2df95dfe 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n2f027b59 788b9753 99901914 1dd07f05 39d141d6 3132608f 49c250a6 31f86165 09d8bef4 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 67526982 31182caf 3ccffa7f 50ac6619\n2fad831f c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d 6fa852e3 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 c336a25c 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 d7082cbf 0c0bd772 d9810f60 dfbea721 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 a5f83fa0 9256767e 7f6b358d e4158f0b da1ad977 256605bd 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 3132608f 49c250a6 31f86165 09d8bef4\n30294946 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n303d2220 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n30b55bbc 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n311cd513 ec64918b d7a5d63e 4a893e74 6f3ab277 4cbcc2a2 7030c54e c336a25c 49c250a6 31f86165 09d8bef4 3132608f\n314a1bf5 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n3219a457 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e\n3244dc49 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n32fba243 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74 6f3ab277 4cbcc2a2 7030c54e cd889dbc\n33a9a66c 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e\n3416fff4 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\n3478da46 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n35fba577 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7\n3622f8dc 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d 6f3ab277 4cbcc2a2 7030c54e\n362577f7 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n366d3622 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b a5023836 f6275c53 88b7cf6d\n36d20472 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e\n36fcbd00 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n380e3e45 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n384511d9 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\n396381a9 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n3ae02f80 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 7030c54e\n3b60cae4 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n3b718900 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n3bd04c18 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 67526982 31182caf 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3 c4c9b9ef\n3bf357e5 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n3c3cec57 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d dfbea721 40ac6a69 5ac80a00 078c5d3b 60e13e87 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e d7082cbf e4158f0b ac08fe53 7a4bdbbe 5dd8181b b6347304 50ac6619 c336a25c e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 e9bb563f 09c56a96 edbf0131 2932144a 4441caf8 c58881d5 da1ad977 256605bd dc9fd59c ead4dd3f 1e4b5baa 99da4321 3132608f 49c250a6 31f86165 09d8bef4 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74\n3c709c50 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e b741b700\n3cb2f6ef 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 49c250a6 31f86165 09d8bef4 c336a25c 6f3ab277 4cbcc2a2 7030c54e\n3d538455 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c d7082cbf 078c5d3b 60e13e87 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 f8d23bd2 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 d6e3606a ad1808d1\n3d7ed060 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc 6fa852e3\n3e51c09b 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n3f87a7e8 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n3fa67f3a 3132608f 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c\n3fcc00c4 3132608f 50ac6619 da1ad977 256605bd 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 67526982 31182caf 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c 3ccffa7f\n4091a284 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4\n41de83ec 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n428b28d4 3132608f 49c250a6 31f86165 09d8bef4 d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 ac08fe53 7a4bdbbe 5dd8181b b6347304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c 50ac6619\n42a6b5ba 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d\n4321fb69 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n437d9eed 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n43f3fd0a 3132608f 49c250a6 31f86165 09d8bef4 c4c9b9ef d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 dfbea721 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 c336a25c 50ac6619\n43f7d548 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n447bac84 3132608f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 49c250a6 31f86165 09d8bef4\n46b64e6c 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\n479c3dc3 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e\n47caeb33 dfbea721 d7082cbf 95c46304 078c5d3b 60e13e87 3132608f 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\n48643cfd 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\n4953af80 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4\n4a6da2f4 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n4bef0443 3132608f 49c250a6 31f86165 09d8bef4 c4c9b9ef d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 dfbea721 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 c336a25c 50ac6619\n4c0b5b68 3132608f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 49c250a6 31f86165 09d8bef4\n4c9d9517 c4c9b9ef c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 d7082cbf 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 50ac6619\n4daea8e1 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 788b9753 99901914 1dd07f05 39d141d6\n4e64c4dc 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\n4e87d68d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc ec64918b a5023836 f6275c53 88b7cf6d 6f3ab277 4cbcc2a2 7030c54e\n4ee55ac0 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d dfbea721 ead4dd3f 1e4b5baa 99da4321 40ac6a69 5ac80a00 078c5d3b 60e13e87 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd ac08fe53 7a4bdbbe 5dd8181b b6347304 50ac6619 e4158f0b e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de c336a25c ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 edbf0131 2932144a 4441caf8 c58881d5 d7082cbf dc9fd59c 6f3ab277 4cbcc2a2 7030c54e 3132608f 95c46304 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74\n4f57a016 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n5198e974 3132608f ac08fe53 7a4bdbbe 5dd8181b b6347304 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7\n521229d8 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n530e19df 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e ec64918b d7a5d63e 4a893e74\n532cf6bd c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d dfbea721 40ac6a69 5ac80a00 078c5d3b 60e13e87 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e d7082cbf e4158f0b ac08fe53 7a4bdbbe 5dd8181b b6347304 50ac6619 c336a25c e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 e9bb563f 09c56a96 edbf0131 2932144a 4441caf8 c58881d5 da1ad977 256605bd dc9fd59c ead4dd3f 1e4b5baa 99da4321 3132608f 49c250a6 31f86165 09d8bef4 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74\n5590232e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n55b5b982 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\n5652ed49 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a09ccd0a b19ad128 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 73dbc5b5 40ac6a69 5ac80a00 c6819f35 4543230a e4158f0b 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 dfbea721 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 078c5d3b 60e13e87 ea04d444 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 dc9fd59c ac08fe53 7a4bdbbe 5dd8181b b6347304 da1ad977 256605bd 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 3132608f 6f3ab277 4cbcc2a2 7030c54e\n56c0a062 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n56c65009 49c250a6 31f86165 09d8bef4 b741b700 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f da1ad977 256605bd dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cd889dbc\n56e55184 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n57079738 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 f06bf1ae\n576582ee 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n589b3518 ec64918b d7a5d63e 4a893e74 6f3ab277 4cbcc2a2 7030c54e c336a25c 49c250a6 31f86165 09d8bef4 3132608f\n58cd3b3d 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\n5ada6b71 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d\n5b4312d0 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87\n5c813e43 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 d7082cbf\n5e0cd6f6 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n5f3517bf 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n5f498a97 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\n603f3825 3132608f 50ac6619 8bbeb160 20605662 2d27198c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 3ccffa7f 788b9753 99901914 1dd07f05 39d141d6\n60cac78a 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n60f45420 3132608f 50ac6619 da1ad977 256605bd 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 67526982 31182caf 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 3ccffa7f\n61e573c5 3132608f 50ac6619 8bbeb160 20605662 2d27198c 3ccffa7f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 c336a25c 67526982 31182caf 49c250a6 31f86165 09d8bef4 cd889dbc\n656d507b 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 078c5d3b 60e13e87 d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n66247907 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n66d1da14 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n66f5d393 50ac6619 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb c3a3f66c 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n671c9d10 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n674b88a9 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n6876b30a 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n69971ef9 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n6b2c3bed 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74 cd889dbc\n6b47e064 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e cd889dbc\n6ba62b83 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\n6c26a65d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n6c558aa5 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n6cc38f79 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n6d3f8345 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e b741b700\n6d745627 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e cd889dbc\n6ec2a850 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n6ee7730f 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n6f536276 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6\n7405f976 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf e4158f0b c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n74a83b1a 3132608f dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 d7082cbf ea04d444 8bbeb160 9a9b14c4 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc 20605662 ec64918b d7a5d63e 4a893e74 da1ad977 256605bd c336a25c ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619\n7559f271 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n756a4e4d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 ec64918b d7a5d63e 4a893e74 cd889dbc\n76120872 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e ec64918b d7a5d63e 4a893e74\n76b81cf6 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n792fcf7d 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4\n7b32b291 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\n7ba2fa73 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 95c46304 ac08fe53 7a4bdbbe 5dd8181b b6347304 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c\n7bfb2e06 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e cd889dbc 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n7dce85e3 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d\n7ea9ed9a 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n82a8d3c2 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n83d1036e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 078c5d3b 60e13e87 d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n8583e435 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n8653fcbb 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f cd889dbc 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f da1ad977 256605bd dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\n866289c6 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a09ccd0a b19ad128 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 73dbc5b5 40ac6a69 5ac80a00 c6819f35 4543230a e4158f0b 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 dfbea721 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 078c5d3b 60e13e87 ea04d444 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 dc9fd59c ac08fe53 7a4bdbbe 5dd8181b b6347304 da1ad977 256605bd 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 3132608f 6f3ab277 4cbcc2a2 7030c54e\n86709cb9 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e ec64918b d7a5d63e 4a893e74\n8696c4f0 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\n8a3c6fee 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n8af9104d 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 da1ad977 256605bd\n8b35c29b 3132608f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 49c250a6 31f86165 09d8bef4\n8c0aee6e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n8c9c57bd 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f b741b700 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n8e49803f ec64918b d7a5d63e 4a893e74 49c250a6 31f86165 09d8bef4 c336a25c 6f3ab277 4cbcc2a2 7030c54e 3132608f\n8ed281fe dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\n8f7838eb 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n8fcdd35c 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n903649ec 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 7030c54e\n90e6bc26 3132608f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e c336a25c 078c5d3b 60e13e87 cd889dbc ec64918b d7a5d63e 4a893e74 da1ad977 256605bd\n910092f7 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n913cc553 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c f8d23bd2 d6e3606a ad1808d1\n91fafc27 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 7030c54e ec64918b d7a5d63e 4a893e74\n93e5c833 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\n942a0601 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n947ed108 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3\n95c5dc52 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n960653cb 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d 6f3ab277 4cbcc2a2 7030c54e\n967a3fed 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n96c78961 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 0d3e7714 f1d8b86f ec64918b a5023836 f6275c53 88b7cf6d\n96c8cffd 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n985c00c1 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n986600d1 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n992ff297 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3\n9a109898 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n9a57488b 3132608f 078c5d3b 60e13e87 8bbeb160 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 20605662 50ac6619\n9b692603 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f b741b700 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n9c06f074 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\n9c2493bb 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\n9c2e7f43 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n9c6e0012 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n9ca7fac8 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\n9ce82ac5 67526982 31182caf 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b a5023836 f6275c53 88b7cf6d cd889dbc 6fa852e3 c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 98b4aaf0 8bbeb160 20605662 da1ad977 256605bd\n9d474323 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 67526982 31182caf ec64918b a5023836 f6275c53 88b7cf6d\n9df87863 078c5d3b 60e13e87 575af211 e7e8099d c336a25c d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 98b4aaf0 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 3ccffa7f da1ad977 256605bd\n9e18f0cf 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\n9f16a5a2 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\n9f489d46 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\n9f76be2f c41e1a93 9a21c77e 65b0e026 c6fe28e8 fa559991 268ac291 0fab729a 0dc3d709 c92b2117 05c37e2c 40ac6a69 5ac80a00 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c 3132608f 95c46304 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 50ac6619 e144c5e3 ea04d444 d7082cbf 078c5d3b 60e13e87 dfbea721 edbf0131 2932144a 4441caf8 c58881d5 da1ad977 256605bd e9bb563f 09c56a96\n9fdd94c0 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\na0c664de 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\na1b9967a c4c9b9ef c336a25c 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 50ac6619\na2154c5f 078c5d3b 60e13e87 d7082cbf e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc dfbea721 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619\na261d7f0 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a09ccd0a b19ad128 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 73dbc5b5 40ac6a69 5ac80a00 c6819f35 4543230a e4158f0b 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 dfbea721 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 078c5d3b 60e13e87 ea04d444 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 dc9fd59c ac08fe53 7a4bdbbe 5dd8181b b6347304 da1ad977 256605bd 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 3132608f 6f3ab277 4cbcc2a2 7030c54e\na37f0894 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\na3d75b9c 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\na41ddfcd 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\na4eff4fa 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e cd889dbc ec64918b d7a5d63e 4a893e74\na5f78db3 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\na5fa507c 3132608f 078c5d3b 60e13e87 d7082cbf 8bbeb160 9a9b14c4 14d334b6 4a53b701 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc 20605662 ec64918b d7a5d63e 4a893e74 da1ad977 256605bd c336a25c ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619\na6445802 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\na6e06a41 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\na7bf4a1a 078c5d3b 60e13e87 d7082cbf e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc dfbea721 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619\na85c14c9 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\na8a3d145 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\na9e88c96 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c ec64918b a5023836 f6275c53 88b7cf6d\nab38cade 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nac1eb0d8 3132608f 078c5d3b 60e13e87 8bbeb160 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 20605662 50ac6619\nac5e38f5 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\naca39ec2 3132608f 50ac6619 8bbeb160 20605662 2d27198c 3ccffa7f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 c336a25c 67526982 31182caf 49c250a6 31f86165 09d8bef4 cd889dbc\naca565f4 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nb00e2017 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nb2bfd847 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\nb30f446f 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nb3246bb7 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c b741b700 6f3ab277 4cbcc2a2 7030c54e cd889dbc\nb4a17af7 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 0fd39f0a\nb4ac0dfa 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nb551b138 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e b741b700\nb5de6995 3132608f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 49c250a6 31f86165 09d8bef4\nb697955d 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\nb72b1558 ec64918b d7a5d63e 4a893e74 6f3ab277 4cbcc2a2 7030c54e c336a25c 49c250a6 31f86165 09d8bef4 3132608f\nb747653b 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nb770b0ae 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\nb7e3b4ba 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\nba161726 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nbaaf62c6 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nbb06e598 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\nbbdb37fc 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7\nbd5f17dd 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nbe95e875 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\nbe9b793e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nbf35608c 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 67526982 31182caf 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3 c4c9b9ef\nc0e5aa7f 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nc0ff5282 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nc12ff9b6 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4\nc198eb1f 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\nc1a7efde 3132608f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e c336a25c 078c5d3b 60e13e87 cd889dbc ec64918b d7a5d63e 4a893e74 da1ad977 256605bd e144c5e3\nc3457794 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc 6fa852e3\nc4235b66 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nc59a82aa 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nc7448f32 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\nc7dfd9eb 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 788b9753 99901914 1dd07f05 39d141d6\nc920c2d3 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 078c5d3b 60e13e87 d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 788b9753 99901914 1dd07f05 39d141d6\ncb5e2fe5 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\ncbb08197 49c250a6 31f86165 09d8bef4 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74 cd889dbc c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f 67526982 31182caf 50ac6619 da1ad977 256605bd\ncbb5137e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c\ncbbe1757 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\ncd0e4b4a 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nce49e408 078c5d3b 60e13e87 d7082cbf dfbea721 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 95c46304 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619 da1ad977 256605bd\ncf8a216f 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\ncfaa9ddc 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\ncffb9569 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\nd100e0c8 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c ec64918b a5023836 f6275c53 88b7cf6d cd889dbc\nd17fa690 3132608f 49c250a6 31f86165 09d8bef4 d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 ac08fe53 7a4bdbbe 5dd8181b b6347304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c 50ac6619\nd372022f 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\nd37ac78d 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\nd3c9a08c 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nd496b132 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d 6f3ab277 4cbcc2a2 7030c54e\nd5e0448b 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nd724a2f9 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nd7b78574 3132608f 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7\nd96a6ff6 ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 3132608f\nda0f356e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\ndab37dc8 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\ndb3250ac 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\ndc85eae0 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\ndd0943b3 3132608f 49c250a6 31f86165 09d8bef4 d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 ac08fe53 7a4bdbbe 5dd8181b b6347304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c 50ac6619\ndd7fc64f 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6\ndd9f1091 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\nde4a23b1 078c5d3b 60e13e87 d7082cbf e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 49c250a6 31f86165 09d8bef4 c336a25c ec64918b d7a5d63e 4a893e74 cd889dbc dfbea721 3132608f 6f3ab277 4cbcc2a2 7030c54e 50ac6619\ndef25ee4 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\ne1f10066 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74 cd889dbc\ne2ab08d5 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a09ccd0a b19ad128 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 c336a25c 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 d7082cbf dfbea721 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 da1ad977 256605bd a5f83fa0 9256767e 7f6b358d e4158f0b 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 3132608f ec64918b d7a5d63e 4a893e74 ead4dd3f 1e4b5baa 99da4321 d92082f9 5f8eb478 e0a79052 9611c029 cc0b45e5 9d5d6cc7\ne3d29b1f 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 ec64918b a5023836 f6275c53 88b7cf6d ac08fe53 7a4bdbbe 5dd8181b b6347304\ne4016fc8 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\ne42d5902 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\ne44d791e 3132608f 50ac6619 da1ad977 256605bd 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 67526982 31182caf 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\ne45066e4 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\ne645b6ee 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc\ne6adb635 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\ne867d2a4 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\ne8e363c2 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\ne8fbaa5a 3132608f 50ac6619 da1ad977 256605bd 95c46304 cd889dbc ec64918b d7a5d63e 4a893e74 e0a79052 9611c029 cc0b45e5 9d5d6cc7 67526982 31182caf 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\ne92f56ed 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 078c5d3b 60e13e87 d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 6f3ab277 4cbcc2a2 7030c54e\nea366586 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e e0a79052 9611c029 cc0b45e5 9d5d6cc7 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 da1ad977 256605bd\neb38d34e 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\neb621141 c41e1a93 9a21c77e a5f83fa0 9256767e 7f6b358d ea04d444 d92082f9 5f8eb478 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 70fc271f 7238cd66 78e0a237 8da10a32 3132608f 95c46304 6f3ab277 4cbcc2a2 7030c54e edbf0131 2932144a 4441caf8 c58881d5 e144c5e3 c336a25c cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 50ac6619 98b4aaf0 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e4158f0b c6819f35 4543230a 078c5d3b 60e13e87 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 dfbea721 da1ad977 256605bd e0a79052 9611c029 cc0b45e5 9d5d6cc7 e9bb563f 09c56a96\nec516bbd 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\nee956607 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3\need3b279 3132608f 50ac6619 8bbeb160 20605662 2d27198c 3ccffa7f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 c336a25c 67526982 31182caf 49c250a6 31f86165 09d8bef4 cd889dbc\nef108792 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e b741b700\nef423da7 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\nefa02c2f 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 788b9753 99901914 1dd07f05 39d141d6\nf0aa3287 ec64918b d7a5d63e 4a893e74 6f3ab277 4cbcc2a2 7030c54e c336a25c 49c250a6 31f86165 09d8bef4 3132608f\nf18d75e5 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nf1dbc135 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 67526982 31182caf 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b d7a5d63e 4a893e74 6fa852e3 c4c9b9ef\nf2c595ea 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 c3a3f66c ec64918b d7a5d63e 4a893e74 cd889dbc\nf3108c72 3132608f 078c5d3b 60e13e87 d7082cbf 49c250a6 31f86165 09d8bef4 e0a79052 9611c029 cc0b45e5 9d5d6cc7 6f3ab277 4cbcc2a2 7030c54e 95c46304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c ac08fe53 7a4bdbbe 5dd8181b b6347304 cd889dbc ec64918b d7a5d63e 4a893e74 50ac6619\nf3d3ab0e 50ac6619 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f 3132608f 95c46304 49c250a6 31f86165 09d8bef4 7030c54e ec64918b d7a5d63e 4a893e74 d7082cbf\nf47c41c8 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nf53d4725 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 c4c9b9ef d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 e0a79052 9611c029 cc0b45e5 9d5d6cc7 49c250a6 31f86165 09d8bef4 3132608f 95c46304 ec64918b d7a5d63e 4a893e74 67526982 31182caf 6f3ab277 4cbcc2a2 7030c54e\nf5ff8d80 3132608f cd889dbc c336a25c 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d\nf697c0ce 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f 6f3ab277 4cbcc2a2 7030c54e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\nf6e0573f 49c250a6 31f86165 09d8bef4 50ac6619 ec64918b d7a5d63e 4a893e74 c336a25c 3132608f e0a79052 9611c029 cc0b45e5 9d5d6cc7 cd889dbc 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f da1ad977 256605bd dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\nf7335279 3132608f 49c250a6 31f86165 09d8bef4 c4c9b9ef d7082cbf ec64918b a5023836 f6275c53 88b7cf6d 95c46304 cd889dbc 078c5d3b 60e13e87 dfbea721 e0a79052 9611c029 cc0b45e5 9d5d6cc7 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 c336a25c 50ac6619\nf84e3448 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619\nf8508b98 7030c54e ec64918b d7a5d63e 4a893e74 49c250a6 31f86165 09d8bef4 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 c336a25c 3132608f 3ccffa7f da1ad977 256605bd\nf867203c 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 7030c54e 3ccffa7f\nf86855c2 3132608f 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 cd889dbc c336a25c 49c250a6 31f86165 09d8bef4\nf8b4b238 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 c336a25c 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e\nf94a73b3 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nfa6ddf17 dfbea721 d7082cbf f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 ea04d444 95c46304 e0a79052 9611c029 cc0b45e5 9d5d6cc7 078c5d3b 60e13e87 3132608f 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 c336a25c cd889dbc ec64918b d7a5d63e 4a893e74 ac08fe53 7a4bdbbe 5dd8181b b6347304 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 da1ad977 256605bd\nfb8c4465 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 ec64918b a5023836 f6275c53 88b7cf6d 95c46304 6fa852e3\nfbc7f2e1 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nfbd58864 98b4aaf0 3132608f 95c46304 c336a25c e9bb563f 09c56a96 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74 cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 7a4bdbbe c2eb5c15 e144c5e3 d7082cbf 6f3ab277 4cbcc2a2 7030c54e 3ccffa7f d22b948c c20428c6 6d1d5cfb\nfc1ece86 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e 9a34c336 a74ef0d5 04ec5b95 e525fa9c 4a893e74\nfd115815 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf e4158f0b c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nfd585726 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 078c5d3b 60e13e87 d7082cbf 49de1d41 9b738dca 1ddc206a 83ac92c6 47b06683 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74 788b9753 99901914 1dd07f05 39d141d6 a5fb73ef\nfde8ab3d 67526982 31182caf 3132608f 788b9753 99901914 1dd07f05 39d141d6 ac08fe53 7a4bdbbe 5dd8181b b6347304 d7082cbf 6d2d83f8 7d9563dd d8819b3e 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e 95c46304 ec64918b a5023836 f6275c53 88b7cf6d cd889dbc 6fa852e3 c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 50ac6619 98b4aaf0 8bbeb160 20605662\nfe07a595 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf e4158f0b c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 3132608f 49c250a6 31f86165 09d8bef4 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nfe3cf398 3132608f cd889dbc c336a25c 6f3ab277 4cbcc2a2 7030c54e 49c250a6 31f86165 09d8bef4 ec64918b d7a5d63e 4a893e74\nfe760204 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc 788b9753 99901914 1dd07f05 39d141d6 6f3ab277 4cbcc2a2 7030c54e ec64918b d7a5d63e 4a893e74\nfeae4480 50ac6619 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3132608f 67526982 31182caf 49c250a6 31f86165 09d8bef4 3ccffa7f c20428c6 6d1d5cfb cd889dbc ec64918b a5023836 f6275c53 88b7cf6d\nff1a600e 3132608f cd889dbc ec64918b d7a5d63e 4a893e74 8bbeb160 20605662 2d27198c c336a25c 49c250a6 31f86165 09d8bef4 7030c54e\n066c9036 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n07170cd0 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n0ab1da38 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n0dff968f 50ac6619 0d3e7714 f1d8b86f a09ccd0a b19ad128 69889752 a5ae4500 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c 0c0bd772 d9810f60 da1ad977 256605bd 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 e144c5e3 3b5a954f 6396946a 3ccffa7f\n139293f3 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n219da219 50ac6619 0d3e7714 f1d8b86f c336a25c 7d5f40d9 ed3b9b9b 699eea38 a2bc3db6 c4c9b9ef 69889752 a5ae4500 98b4aaf0 3ccffa7f\n24bfe86e 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n32fd58bf 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n42eb8b5a 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n447380d4 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n61ea0c42 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n66d03a73 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n6c17c3b1 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n764f37a0 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n816a11e0 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n8b40a204 50ac6619 af4c7e8a 0d4e190d 308e0842 a09ccd0a b19ad128 69889752 a5ae4500 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e 4b108e47 c336a25c 0c0bd772 d9810f60 da1ad977 256605bd 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 e144c5e3 3b5a954f 6396946a 3ccffa7f\n94ff3b20 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\n96cb35d7 50ac6619 a09ccd0a b19ad128 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 e144c5e3 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c af4c7e8a 0d4e190d 308e0842 0c0bd772 d9810f60 3b5a954f 6396946a 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 da1ad977 256605bd dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 3ccffa7f 69889752 a5ae4500\n9f9ef431 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\na42ace6a 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\nb32572a6 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\nb5b092f9 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\nb9ea8c7e 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\nbb2729e9 50ac6619 af4c7e8a 0d4e190d 308e0842 a09ccd0a b19ad128 69889752 a5ae4500 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e 4b108e47 c336a25c 0c0bd772 d9810f60 da1ad977 256605bd 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 e144c5e3 3b5a954f 6396946a 3ccffa7f\nc4bf68fd 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\ne80c471f 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\ne866a492 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7\nec1b10be 788b9753 99901914 1dd07f05 39d141d6 c336a25c 69889752 a5ae4500 8bbeb160 20605662 2d27198c 98b4aaf0\nee341a1b 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 69889752 a5ae4500\nf439bdce 50ac6619 0d3e7714 f1d8b86f a09ccd0a b19ad128 69889752 a5ae4500 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c 0c0bd772 d9810f60 da1ad977 256605bd 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 e144c5e3 3b5a954f 6396946a 3ccffa7f\n016ad05b 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n02e37449 c336a25c 50ac6619 7a4bdbbe f298010f b4d3d2c4 a8a7a276 35670f88 94c8e108 e22bdb62 0d3e7714 f1d8b86f 788b9753 99901914 1dd07f05 39d141d6 403d474a 3ccffa7f 8bbeb160 20605662 2d27198c e9bb563f 09c56a96\n035c6912 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n04831f03 78eb72bc c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6\n04f392ce c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n05256e47 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n0528d3f1 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f 0d3e7714 f1d8b86f\n0614692e 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n063864f4 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n069fe281 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n06df063d 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n075cdabd 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n09162638 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n0a0aca1e 788b9753 99901914 1dd07f05 39d141d6 c336a25c\n0a3ac4b7 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 50ac6619 7d5f40d9 ed3b9b9b 699eea38 a2bc3db6\n0a3d04da c336a25c 0d3e7714 f1d8b86f 50ac6619 d7082cbf 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 403d474a\n0a84375b c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n0ae6d36d 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n0b1e7ba8 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n0ba3b9b6 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n0d212647 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n0d3766ad c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n0df416d3 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 0d3e7714 f1d8b86f d7082cbf 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\n0e1c32ff c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n0e3813da 788b9753 99901914 1dd07f05 39d141d6 fbfc1639 96e597aa b2f605cd 326b5cbe 5796af1e 9ec078a2 2772a84b 42f29da2 c336a25c\n0e4657e1 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n0e704a37 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n10662676 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb e544ab57 e525ddf7 a6a66276 1623f3c8 788b9753 99901914 1dd07f05 39d141d6 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c d7082cbf\n10a7a547 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n110f5501 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n11999d28 50ac6619 8bbeb160 20605662 2d27198c c336a25c 788b9753 99901914 1dd07f05 39d141d6\n12e6e20a 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n12f13143 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 7a4bdbbe f298010f 0d3e7714 f1d8b86f 54c63742 b538a8fd 6e6a5976 b19ad128 3ccffa7f 8bbeb160 20605662 2d27198c e9bb563f 09c56a96\n12fb5348 3ccffa7f c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\n1350175f c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n14111926 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 50ac6619 0d3e7714 f1d8b86f\n1543c83c 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n15d8ff78 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n1610e8f7 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n16d649b7 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n17d1f072 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n1844523d 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 78eb72bc\n18ba422a 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n1958acb5 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb e544ab57 e525ddf7 a6a66276 1623f3c8 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c d7082cbf\n197f01b9 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\n1992a002 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n19e070f1 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n1bc27c36 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n1bec6c1a c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n1ca1b438 c336a25c 50ac6619 c4c9b9ef 788b9753 99901914 1dd07f05 39d141d6\n1d69de7e c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n1dbd1418 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n1e46a0ba 50ac6619 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 9ea124c4 8581a867 29668fe9 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524\n202a87e4 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n2199ab14 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 0d3e7714 f1d8b86f d7082cbf 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\n22454df5 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n227e74f7 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\n232f7cfb 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\n236532ca c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\n23e8951a c336a25c 8bbeb160 788b9753 99901914 1dd07f05 39d141d6 fbfc1639 96e597aa b2f605cd 326b5cbe 5796af1e 9ec078a2 2772a84b 42f29da2 c4c9b9ef\n2432c30a 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n250845e3 c336a25c 788b9753 99901914 1dd07f05 39d141d6 403d474a 6e4f5b19 ca0ae4bd 010ed77a\n25e3ede2 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n25ed6c5a c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6\n282f2449 8bbeb160 20605662 c336a25c 9a9b14c4 00516845 2b88eda4 be76ee23 788b9753 99901914 1dd07f05 39d141d6\n2896eb7a 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n294f0f56 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 7a4bdbbe f298010f 0d3e7714 f1d8b86f 54c63742 b538a8fd 6e6a5976 b19ad128 3ccffa7f 8bbeb160 20605662 2d27198c e9bb563f 09c56a96\n2b3769f5 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n2c0c01f7 50ac6619 0c0bd772 d9810f60 3b5a954f 6396946a e144c5e3 c336a25c e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a09ccd0a b19ad128 6fa852e3 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 6d2d83f8 7d9563dd d8819b3e dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 d7082cbf a5f83fa0 9256767e 7f6b358d cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 da1ad977 256605bd ead4dd3f 1e4b5baa d040a7f9 3ccffa7f af4c7e8a 0d4e190d 308e0842\n2c2d0375 6d2d83f8 7d9563dd d8819b3e c336a25c 76372cef 254a8599 43bda2ad 7cbe3dce 788b9753 99901914 1dd07f05 39d141d6\n2c5ec231 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n2c5f2ee8 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n2c936b1a 50ac6619 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 b4d3d2c4 a8a7a276 35670f88 94c8e108 e22bdb62\n2dabc7a1 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n2e22de0c 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n2e4cd57e c336a25c 50ac6619 c4c9b9ef 788b9753 99901914 1dd07f05 39d141d6\n2e756a55 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n2ee9b0a8 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n2f13298f 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\n2fa146c1 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\n300010c2 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\n300d0945 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n3164f902 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n316cf44f 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f\n326c559b c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n32740ce1 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n3347eae2 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n34e1bc3a 50ac6619 a09ccd0a b19ad128 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 e144c5e3 6fa852e3 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c af4c7e8a 0d4e190d 308e0842 0c0bd772 d9810f60 3b5a954f 6396946a 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 da1ad977 256605bd dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 3ccffa7f\n3557a973 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 67526982 31182caf 3ccffa7f 50ac6619\n37193958 be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\n385c8416 50ac6619 c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f\n388b859b 50ac6619 a09ccd0a b19ad128 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 e144c5e3 6fa852e3 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c af4c7e8a 0d4e190d 308e0842 0c0bd772 d9810f60 3b5a954f 6396946a 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 da1ad977 256605bd dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 3ccffa7f\n388c70c6 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n39d74051 50ac6619 c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f\n3a9a3ab0 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f f8d23bd2 faaa8598 f2ccc2f2 07da923b ef17e023\n3ab8c79c 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 67526982 31182caf 3ccffa7f 50ac6619\n3b39f325 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\n3bd94e74 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n3ccba54a 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n3e08f90b c336a25c 788b9753 99901914 1dd07f05 39d141d6\n3e4a6f81 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n3e9bf7f1 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n3f1df6e6 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 78eb72bc\n3f63a4d0 82830aed 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619 c336a25c 8bbeb160 20605662 d7082cbf\n3f66ee0f 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n3f7f6f33 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n40b7da1a 50ac6619 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 0d3e7714 f1d8b86f d7082cbf 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\n40d759ad 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n40ff7f06 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n41c028ad 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n41d645a7 be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\n427dd56b c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 3ccffa7f\n435bd81a c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n44b569d8 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\n471166bf 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 da1ad977 256605bd\n4796fd39 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n47c89128 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n480608e4 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\n48bfef27 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\n4a62a3a9 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n4b0981ce c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n4b3aa0ac c336a25c 9ea124c4 8581a867 29668fe9 92744c94 2026b832 34c576bb 50ac6619 8bbeb160 20605662 2d27198c 788b9753 99901914 1dd07f05 39d141d6\n4bc5ef4f c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n4bcf66c1 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\n4c513556 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n4cc82e42 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n4d57c925 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c 6bdd349b 2b8c9d76 9c38c179 87006e13 bce36da3 30c58a14 6c6a788d 6df99bd2 cac86b86 c93d2240\n50c22dd1 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619\n5246ed5d 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\n52a928b8 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n52ab0f35 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f\n52be0afa b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c\n5368c409 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n54fb3142 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb d7082cbf c4c9b9ef 6fa852e3 e144c5e3 af4c7e8a 0d4e190d 308e0842 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n55404d5c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n584af088 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n58a6b551 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n59ceb175 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n59db0275 c336a25c 788b9753 99901914 1dd07f05 39d141d6 403d474a\n5a57ec03 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f 0d3e7714 f1d8b86f\n5aa66d27 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 67526982 31182caf 3ccffa7f 50ac6619\n5ad45913 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n5b15c8b1 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n5b1b61bf be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\n5c362825 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n5c374763 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c c336a25c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7\n5c957a4f 50ac6619 0c0bd772 d9810f60 3b5a954f 6396946a e144c5e3 c336a25c e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a09ccd0a b19ad128 6fa852e3 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 6d2d83f8 7d9563dd d8819b3e dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 d7082cbf a5f83fa0 9256767e 7f6b358d cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 da1ad977 256605bd ead4dd3f 1e4b5baa d040a7f9 3ccffa7f af4c7e8a 0d4e190d 308e0842\n5d1874a5 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619\n5d26d816 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n5d2ad31e 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n5d9752f9 98b4aaf0 cd889dbc 6ff0e58a 5faee212 7870bb31 e3186939 af97ede7 bdc1cb8a 4b7fae39 b463e168 27c07e3e 248ff28e 913af9a2 0c09236b eef04e89 cf55c86e a5f83fa0 9256767e 7f6b358d a09ccd0a b19ad128 50ac6619 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e 2bbcabe5 d1930672 95c46304 788b9753 99901914 1dd07f05 39d141d6 c336a25c d7082cbf be76ee23 d92082f9 5f8eb478 8d874f55 edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a33df340 c20428c6 6d1d5cfb\n5e48caee 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n5e95439c 50ac6619 a09ccd0a b19ad128 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 98b4aaf0 e144c5e3 6fa852e3 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c af4c7e8a 0d4e190d 308e0842 0c0bd772 d9810f60 3b5a954f 6396946a 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 da1ad977 256605bd dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 3ccffa7f\n5ea61948 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\n5eacef33 c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 3ccffa7f 50ac6619\n5f4c079d 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 cb0453ea 9d550ad3 bbecde19 8fd2d63e d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 7a4bdbbe f298010f 0d3e7714 f1d8b86f 54c63742 b538a8fd 6e6a5976 b19ad128 3ccffa7f 8bbeb160 20605662 2d27198c e9bb563f 09c56a96\n5f71ab1c c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n633dc1fd 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n63d59833 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\n63ef5e70 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 279581de b812a6da\n65e0a9f9 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n67e52a93 c336a25c 9ea124c4 8581a867 29668fe9 92744c94 2026b832 34c576bb 50ac6619 8bbeb160 20605662 2d27198c 788b9753 99901914 1dd07f05 39d141d6\n681b1f5f 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 67526982 31182caf 3ccffa7f 50ac6619\n68206c6c c336a25c 788b9753 99901914 1dd07f05 39d141d6\n694998e8 c336a25c 6d2d83f8 7d9563dd d8819b3e d7082cbf 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 50ac6619\n699d97bf c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n6a073cc6 50ac6619 94b551d6 1c28f6e8 5f77d282 acb8e785 a3005e44 0e5ec213 8c539e52 e34c21a2 60e6d501 20605662 a98cef24 d7082cbf a5d1f45b 81ccef2c a5f83fa0 9256767e 7f6b358d 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 e144c5e3 e9bb563f 09c56a96 8f00b7f4 f298010f 8c1dfe5a c336a25c af4c7e8a 0d4e190d 308e0842 0c0bd772 d9810f60 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 d5077fc6 99efa19f d9d28923 7066744c 523f2320 60b7f986 dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 3ccffa7f 98b4aaf0 788b9753 99901914 1dd07f05 39d141d6 6d2d83f8 7d9563dd d8819b3e 078c5d3b 60e13e87\n6bd7b324 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\n6cabe8d6 c336a25c 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e\n6d121eac c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n6d19af0c c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n6e58d501 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n71a6d908 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n73096f3a c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n754b27f3 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n76121bca 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n76222958 82830aed 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619 c336a25c 8bbeb160 20605662 d7082cbf\n76e395be c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n76fd7f40 50ac6619 c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f\n77a7220c 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n77b60330 c336a25c 50ac6619 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 403d474a\n79229595 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n79bc04a2 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n7a5f71c2 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f 50ac6619\n7ac91d9f c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n7aff173b c336a25c 788b9753 99901914 1dd07f05 39d141d6\n7bd09cce 50ac6619 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n7c409383 50ac6619 c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f\n7cc58292 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\n7ccda1fd c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\n7d16f96c 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n7d18f080 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n7dfd8294 c336a25c da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6\n7e15b7b7 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n7e5c3991 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 c336a25c d4088bd8\n7ee31704 c336a25c 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\n814c5e3d 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n81cd79d7 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n8290e00a c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n83164c66 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\n841120c9 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\n86588e3a c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 0d3e7714 f1d8b86f\n870a7011 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n8714a611 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\n88ef4e78 50ac6619 c4c9b9ef 7a4bdbbe f298010f 788b9753 99901914 1dd07f05 39d141d6 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 403d474a 0d3e7714 f1d8b86f c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n893c8d4b 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\n8a2f8aea 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n8b2ee1ef 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n8b49fa83 c336a25c 50ac6619 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 403d474a\n8cf62663 c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 0d3e7714 f1d8b86f\n8d501cff c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n8d84ddce 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\n8d8612a6 3ccffa7f c336a25c 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 0d3e7714 f1d8b86f\n8dc48815 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f 0d3e7714 f1d8b86f\n8e3d0f3e 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n8f395664 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 f8d23bd2 faaa8598 f2ccc2f2 07da923b ef17e023 0d3e7714 f1d8b86f\n9047e466 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 403d474a\n90911398 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\n909d70a8 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n90e1c2e6 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n91a3f64d c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n91ebbb62 c336a25c 788b9753 99901914 1dd07f05 39d141d6 403d474a\n91f10108 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\n92805c4b 50ac6619 c336a25c 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f\n92961ea8 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n92ab71b9 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524\n93f77732 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n97425204 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\n97810ed4 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\n97fa018b 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\n98bcefdc c336a25c 788b9753 99901914 1dd07f05 39d141d6 403d474a\n9a2b9962 be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 00516845 2b88eda4\n9bc82452 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619\n9c55417a c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\n9d5c0899 3ccffa7f c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\n9d5e0955 78eb72bc c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 0d3e7714 f1d8b86f\n9dfe94e2 3ccffa7f c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\n9e7c7dae 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\n9f8f7978 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\na173c570 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\na21aa238 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\na2dacf51 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\na31625eb 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\na328719e c336a25c fbfc1639 96e597aa b2f605cd 326b5cbe 5796af1e 9ec078a2 2772a84b 42f29da2 788b9753 99901914 1dd07f05 39d141d6\na342b39c 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\na35323b6 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\na3c69a38 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c c336a25c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7\na4c0f05c 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 50ac6619 7d5f40d9 ed3b9b9b 699eea38 a2bc3db6\na4e5b53d be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\na50b25a2 c336a25c 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23\na7635820 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\na850d1ea c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\na9be1db4 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\naa399519 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 78eb72bc\naa3bb1f1 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\naa81fa86 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nabd2abbd c336a25c 6d2d83f8 7d9563dd d8819b3e d7082cbf 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 50ac6619\nabd39ddc 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 078c5d3b 60e13e87 d7082cbf ac08fe53 7a4bdbbe 5dd8181b b6347304\nadf44a31 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\nae35e7d7 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\naf1edef6 e544ab57 e525ddf7 a6a66276 1623f3c8 c336a25c 50ac6619 8bbeb160 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\naf5c87f7 788b9753 99901914 1dd07f05 39d141d6 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c336a25c 3ccffa7f\nb02559d4 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\nb0b9f710 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 783734d7 b19ad128 6fee6b03 24cf7e78 1ad6d70f f37a8e24 79a5e568 90228a9b a5f83fa0 9256767e 7f6b358d\nb14934be c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nb3d4f788 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c c336a25c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7\nb3fe387c 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nb534cf53 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nb5806815 50ac6619 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 b4d3d2c4 a8a7a276 35670f88 94c8e108 e22bdb62\nb5badd9f c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\nb5e759dd 50ac6619 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 9ea124c4 8581a867 29668fe9 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524\nb6e028e0 c336a25c 788b9753 99901914 1dd07f05 39d141d6\nb74909be c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nb7caeb25 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\nb85fdd15 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\nb89fb64b 788b9753 99901914 1dd07f05 39d141d6 fbfc1639 96e597aa b2f605cd 326b5cbe 5796af1e 9ec078a2 2772a84b 42f29da2 c336a25c\nb92645a7 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 788b9753 99901914 1dd07f05 39d141d6 6d2d83f8 7d9563dd d8819b3e\nb936384d be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\nb947136f c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nb955e332 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\nbae3f0a6 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d 6fa852e3 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 c336a25c 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 6d2d83f8 7d9563dd d8819b3e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 d7082cbf 0c0bd772 d9810f60 dfbea721 ac08fe53 7a4bdbbe 5dd8181b b6347304 788b9753 99901914 1dd07f05 39d141d6 078c5d3b 60e13e87 c6819f35 4543230a edbf0131 2932144a 4441caf8 c58881d5 ea04d444 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 e144c5e3 a5f83fa0 9256767e 7f6b358d e4158f0b da1ad977 256605bd\nbaff629d 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\nbcb7db19 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\nbde66196 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nbe6d7e88 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nbe800f6b 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c efe211ca 3d733026 50ac6619\nbeb09041 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\nc086198b c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nc1470645 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nc1a624f4 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nc208c35d 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 0d3e7714 f1d8b86f d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 788b9753 99901914 1dd07f05 39d141d6 403d474a 54c63742 b538a8fd 6e6a5976 b19ad128\nc2190fca c336a25c 50ac6619 d7082cbf 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 403d474a\nc342c783 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nc4999b5a c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nc5c670cf 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nc5d2dc37 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 78eb72bc\nc743473d c336a25c 788b9753 99901914 1dd07f05 39d141d6 403d474a\nc8102937 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb d7082cbf c4c9b9ef 6fa852e3 e144c5e3 af4c7e8a 0d4e190d 308e0842 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\nc88cac8d c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 3ccffa7f\nc89adf0c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f 35ff0b52\nc93e6559 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\nc9680f06 be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87 d7082cbf 00516845 2b88eda4\nc9c82488 c336a25c 788b9753 99901914 1dd07f05 39d141d6\nca2e4080 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nca6aa021 50ac6619 a09ccd0a b19ad128 d7082cbf dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d 788b9753 99901914 1dd07f05 39d141d6 6d2d83f8 7d9563dd d8819b3e cb0453ea 9d550ad3 bbecde19 8fd2d63e c336a25c 0c0bd772 d9810f60 3b5a954f 6396946a 791943f0 91f98cec 7615f45d eeb1225e cca43d10 5a8871e3 e00857ad d648e3a3 4828beb2 8db8f9a4 13daabe6 b23ad39c ad7ddda8 fafc1456 b8ba2a04 5b7d5691 da1ad977 256605bd dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583\ncbaf7c43 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0\ncc26c744 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\ncc708c80 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\ncdb1e951 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\ncdccbaa6 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\ncee8a56a c336a25c 788b9753 99901914 1dd07f05 39d141d6\ncf77fa4b c336a25c 50ac6619 7a4bdbbe f298010f b4d3d2c4 a8a7a276 35670f88 94c8e108 e22bdb62 0d3e7714 f1d8b86f 788b9753 99901914 1dd07f05 39d141d6 403d474a 3ccffa7f 8bbeb160 20605662 2d27198c\nd03a263f 3ccffa7f c336a25c 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0\nd0584627 c336a25c 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 3ccffa7f\nd0e4a852 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nd1632c83 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nd1704f67 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nd3e4682e 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 7f7d11f7 58c2060b\nd4398a6d 50ac6619 0c0bd772 d9810f60 3b5a954f 6396946a e144c5e3 c336a25c e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a09ccd0a b19ad128 6fa852e3 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 6d2d83f8 7d9563dd d8819b3e dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 d7082cbf a5f83fa0 9256767e 7f6b358d cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 da1ad977 256605bd ead4dd3f 1e4b5baa d040a7f9 3ccffa7f af4c7e8a 0d4e190d 308e0842\nd4b864fb 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 50ac6619 7d5f40d9 ed3b9b9b 699eea38 a2bc3db6\nd55e91c6 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb 0d3e7714 f1d8b86f d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef\nd675eb10 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3 95c46304\nd6f22bc8 c41e1a93 9a21c77e f819a504 f4ed7ac2 e725d2d1 83a70c01 4f4d9f0d be76ee23 a5f83fa0 9256767e 7f6b358d a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 95c46304 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de 00516845 2b88eda4 d7082cbf e4158f0b edbf0131 2932144a 4441caf8 c58881d5 d92082f9 5f8eb478 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 c6819f35 4543230a ac08fe53 7a4bdbbe 5dd8181b b6347304 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 dfbea721 078c5d3b 60e13e87 c336a25c ea04d444 2bbcabe5 d1930672 788b9753 99901914 1dd07f05 39d141d6 8d874f55 da1ad977 256605bd 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291\nd6f2d68f 50ac6619 8bbeb160 20605662 2d27198c c336a25c 788b9753 99901914 1dd07f05 39d141d6\nd6fcdf7f 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c 50ac6619\nd7dd3d12 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nd7dde809 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\nd8434d8a 50ac6619 8bbeb160 20605662 2d27198c c336a25c 788b9753 99901914 1dd07f05 39d141d6\nd87eba03 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\nd8a779ba 82830aed 28e5dbf3 c9783998 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 3ccffa7f c3a3f66c\nd8bc4dd6 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f\nd8c9f173 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\nd9f738f7 788b9753 99901914 1dd07f05 39d141d6 b19ad128 ca4d820a 25573a25 95e73c23 c336a25c\ndb56604e 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\ndba1eefb 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f c20428c6 6d1d5cfb 788b9753 99901914 1dd07f05 39d141d6 a996fdd0\ndc9cb1a0 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\ndd35fa59 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\ndd7c491e 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\ndde69d3c 50ac6619 c336a25c 788b9753 99901914 1dd07f05 39d141d6\nde71f699 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727\ndeeeea0b 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\ne085bb63 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\ne0b3c3c2 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\ne15d6bbb 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\ne233f374 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\ne2ec99c6 788b9753 99901914 1dd07f05 39d141d6 6d2d83f8 7d9563dd d8819b3e c336a25c\ne308e8a7 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 0d3e7714 f1d8b86f\ne4055bb1 788b9753 99901914 1dd07f05 39d141d6 9a9b14c4 20605662 c336a25c b19ad128 ca4d820a 25573a25 95e73c23 8bbeb160\ne4355027 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\ne445d96c c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\ne4ff5d75 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\ne776ac13 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\ne8328961 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 279581de b812a6da\ne838cdee c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 403d474a\ne86fb7d6 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7\ne8708109 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\ne8a9014b c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\neaa49812 50ac6619 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6\neb08206f c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\neb784ac7 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7\nebc18699 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\nebcffb75 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\necbda4d6 50ac6619 788b9753 99901914 1dd07f05 39d141d6 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 98b4aaf0 3ccffa7f\ned02cc7a 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\nefb4a22e 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f f8d23bd2 faaa8598 f2ccc2f2 07da923b ef17e023\nf130eab6 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c20428c6 6d1d5cfb\nf245e76f 50ac6619 788b9753 99901914 1dd07f05 39d141d6 8bbeb160 20605662 2d27198c 98b4aaf0 c336a25c 3ccffa7f\nf259751e be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\nf32cebf7 50ac6619 dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 9a9b14c4 c336a25c 3ccffa7f d22b948c c20428c6 6d1d5cfb d7082cbf b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef\nf3ebe1ab c336a25c 788b9753 99901914 1dd07f05 39d141d6\nf45f531b be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\nf4f6e5c8 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128 e8e5d7de 7128b522 acc8adbd 1211758e e725c1b3 8ae862b0 35d44e37 2cbc16a4\nf5553215 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3 95c46304\nf615bf3d c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6 50ac6619\nf67fc09f c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nf72f7061 50ac6619 8bbeb160 20605662 2d27198c c336a25c 788b9753 99901914 1dd07f05 39d141d6\nf88ae9a1 c336a25c 50ac6619 da1ad977 256605bd 9ea124c4 8581a867 29668fe9 788b9753 99901914 1dd07f05 39d141d6 c4c9b9ef 8bbeb160 20605662 2d27198c 3ccffa7f c3a3f66c\nf96b8f11 00516845 2b88eda4 908644f2 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 40ac6a69 5ac80a00 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de d7082cbf edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 078c5d3b 60e13e87 c336a25c 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 ac08fe53 7a4bdbbe 5dd8181b b6347304 be76ee23 788b9753 99901914 1dd07f05 39d141d6 e144c5e3\nf9b833b2 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 3ccffa7f\nfa4d0a5b c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nfb36c186 d7082cbf 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 50ac6619 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\nfb771b86 c336a25c 788b9753 99901914 1dd07f05 39d141d6 a996fdd0 c4c9b9ef\nfb99fb71 c336a25c 788b9753 99901914 1dd07f05 39d141d6\nfba8eacd 50ac6619 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c 9ea124c4 8581a867 29668fe9\nfd6cdb49 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c 2279921a 4be24c7a 81ab86e7 788b9753 99901914 1dd07f05 39d141d6 c336a25c 54c63742 b538a8fd 6e6a5976 b19ad128\nfe199ea7 c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 54c63742 b538a8fd 6e6a5976 b19ad128 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c\nfea8ed8d 0178a1ae c5d4c75c 811754f0 e875b703 9e7e0524 788b9753 99901914 1dd07f05 39d141d6 c336a25c 8bbeb160 20605662 2d27198c\nfecf05c3 50ac6619 b2587fbd b6973fda 2504c72e c780ed5e 02cd2acc ba4551c7 d9085a49 0d402cf0 026539c7 3711fc62 7f0acb18 d7ffd7d1 ccd4ed7c c336a25c 788b9753 99901914 1dd07f05 39d141d6 2279921a 4be24c7a 81ab86e7 279581de b812a6da\nff14374b be76ee23 c336a25c 788b9753 99901914 1dd07f05 39d141d6 50ac6619 e3826486 f298010f 360bea65 a0ca5130 36847c8a be1fda03 acf8f4de dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 a5f83fa0 9256767e 7f6b358d da1ad977 256605bd 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 40ac6a69 5ac80a00 a4c332a8 9bbb856e b897e2d8 a1659a75 d5a66654 edbf0131 2932144a 4441caf8 c58881d5 ac08fe53 7a4bdbbe 5dd8181b b6347304 078c5d3b 60e13e87\nff18dcb2 17561da8 1fd8c429 21446f32 d8320b91 34bc3aa8 364ba71a 974988fb b0e87fae 3a32e713 5eb57d13 0d0b8ee1 5caae5e0 c336a25c 50ac6619 d056486c 23f4fac3 658fd435 6ac6c2b5 c71487e9 1c3842b6 fc83cb0e f7684901 3ccffa7f 98b4aaf0 788b9753 99901914 1dd07f05 39d141d6 67526982 31182caf\nff3cf8d8 50ac6619 0c0bd772 d9810f60 3b5a954f 6396946a e144c5e3 c336a25c e9bb563f 09c56a96 788b9753 99901914 1dd07f05 39d141d6 edbf0131 2932144a 4441caf8 c58881d5 3a2b4f15 b2205a6e 1023782c ce125651 e4d00fe1 dae681f4 6d976352 a09ccd0a b19ad128 6fa852e3 8bbeb160 3c01f356 20efbed4 d6a4a959 d49efb40 1aaa6ff0 aea15b36 8df7fe03 b3b69c52 1510fa6a 75536352 268ac291 6d2d83f8 7d9563dd d8819b3e dba62235 da68ae40 42f493f9 69a28ffa 93699a9f f4b46247 f299681b 6ed6cc5a bd5b4583 d7082cbf a5f83fa0 9256767e 7f6b358d cb0453ea 9d550ad3 bbecde19 8fd2d63e dab52fe8 0565f571 169d5ed7 82830aed cad5b537 9ddf0683 95417727 98b4aaf0 da1ad977 256605bd ead4dd3f 1e4b5baa d040a7f9 3ccffa7f af4c7e8a 0d4e190d 308e0842\nff55ea5b c336a25c 50ac6619 788b9753 99901914 1dd07f05 39d141d6 403d474a\nffbd5c9a 50ac6619 c336a25c d7082cbf 1c7a17b1 c24e6614 fb083bdd 2bbcabe5 1566585f 6d2d83f8 7d9563dd d8819b3e 788b9753 99901914 1dd07f05 39d141d6",
  fieldnames = "00516845 gi5_lza\n010ed77a opicez\n0178a1ae eb6iz2\n026539c7 kt2xzf\n02cd2acc tkf9otg\n04ec5b95 ip47m3\n0565f571 r37v08\n05c37e2c a1fzqsb\n078c5d3b i4u5ut\n07da923b wg06_ua\n09c56a96 mokabp\n09d8bef4 ewxe2e\n0c09236b caj8s4a\n0c0bd772 qk3df8\n0d0b8ee1 zma5kmb\n0d3e7714 y6ghu9\n0d402cf0 l1_kbja\n0d4e190d u7qeao\n0dc3d709 hgdy3\n0e5ec213 ehfrw0a\n0fab729a zzd397a\n0fd39f0a akxpaha\n1023782c mak9ktd\n1211758e m4rd2m\n13daabe6 nbzay1\n14d334b6 fryak5\n1510fa6a y7mssy\n1566585f z_hjiqb\n1623f3c8 x9ila1a\n169d5ed7 pxtdanc\n17561da8 dw7nd3a\n1aaa6ff0 mf2a3ma\n1ad6d70f charge\n1c28f6e8 gn6mth\n1c3842b6 hen7rb\n1c7a17b1 v_73kzm\n1dd07f05 rv5vsb\n1ddc206a tl1o1s\n1e4b5baa v0sahdg\n1fd8c429 hm0r40a\n2026b832 hxwufqa\n20605662 f2slnab\n20efbed4 pgqdzdb\n21446f32 a0vamn\n2279921a rqt6n8\n23f4fac3 bycxf\n248ff28e y1vy5g\n24cf7e78 ndatup\n2504c72e esxkb_d\n254a8599 onxn8fc\n25573a25 uu8biga\n256605bd qqo9f7a\n268ac291 ittyy7c\n2772a84b olx_3ie\n279581de qm4tcxa\n27c07e3e u_tuw4a\n28e5dbf3 ts8c_ed\n2932144a qig0n8b\n29668fe9 h4ch50\n2b88eda4 j9ky8bc\n2b8c9d76 dznj1n\n2bbcabe5 input\n2cbc16a4 hidden\n2d27198c si4jg3\n308e0842 g4ke5y\n30c58a14 bs1mbzb\n31182caf rg3owia\n3132608f jkcsuw\n31f86165 ozvglfc\n326b5cbe q96tqvb\n34bc3aa8 o7liiub\n34c576bb qg7mqab\n35670f88 fn3j3zc\n35d44e37 yh4mu2a\n35ff0b52 heat\n360bea65 achcxcb\n364ba71a ag1fh9c\n36847c8a dujmoba\n3711fc62 o3gpgla\n39d141d6 gzsi_0d\n3a2b4f15 zuedkaa\n3a32e713 jrug0k\n3b5a954f y1lw6wb\n3c01f356 nayfrv\n3ccffa7f g5g7b9d\n3d733026 yuww_2b\n403d474a ncjuaxa\n40ac6a69 jkzqsoa\n42f29da2 qeag9n\n42f493f9 uwc7xcb\n43bda2ad tqacgl\n4441caf8 m0pod6f\n4543230a fdsejbb\n47b06683 apaloda\n4828beb2 rpm\n49c250a6 if5_pz\n49de1d41 w76qvwb\n4a53b701 t6t789a\n4a893e74 q6nx6da\n4b108e47 oec5kc\n4b7fae39 wfxoobb\n4be24c7a x48rzvc\n4cbcc2a2 v7xdy8\n4f4d9f0d myanwkb\n50ac6619 of_bfv\n523f2320 na2_1bc\n54c63742 y5t4snb\n575af211 fqckqha\n5796af1e wi9pza\n58c2060b nuedvfa\n5a8871e3 yd7j5ra\n5ac80a00 j7kj_g\n5b7d5691 ep67bq\n5caae5e0 nw7rgoc\n5dd8181b l50wceb\n5e5865a0 fl7z_de\n5eb57d13 t7xe0df\n5f77d282 okq4lz\n5f8eb478 ei6_t2\n5faee212 yekfpij\n60b7f986 v_o5xzd\n60e13e87 did05ga\n60e6d501 xctvnwa\n6396946a g6k330b\n658fd435 ilm9sba\n65b0e026 drsshfd\n67526982 te9ea3\n69889752 c60sehb\n699eea38 gucfww\n69a28ffa mw4zqmb\n6ac6c2b5 d67ag4a\n6bdd349b timer\n6c6a788d score\n6d1d5cfb wm8p6fa\n6d2d83f8 ewc85we\n6d976352 iqa_l2\n6df99bd2 gt0ebnc\n6e4f5b19 jru9axa\n6e6a5976 h75vmta\n6ed6cc5a r00zbtd\n6f3ab277 h_maw9a\n6fa852e3 lnj1mv\n6fee6b03 broken\n6ff0e58a gz3n3yj\n7030c54e q1mik\n7066744c hrqm6aa\n70fc271f qmxpxw\n7128b522 ffykoxc\n7238cd66 ackfpa\n73dbc5b5 m70h_va\n75536352 dcd5rae\n7615f45d jupdjna\n76372cef j3izbla\n783734d7 yg6l7ad\n7870bb31 wq0zrma\n788b9753 n5jmvf\n78e0a237 pvr6sg\n78eb72bc k3buz3\n791943f0 nb2icya\n79a5e568 eave_5d\n7a4bdbbe wae11fa\n7cbe3dce zylg95b\n7d5f40d9 q4h2yd\n7d9563dd urk5h7a\n7f0acb18 jfqwh3\n7f6b358d kd9p3bb\n7f7d11f7 alfmmob\n811754f0 mbyoxae\n81ab86e7 bmbp3gc\n81ccef2c xkw8lja\n82830aed state\n83a70c01 s_br0qe\n83ac92c6 target\n8581a867 xmw_7nd\n87006e13 j375wxc\n88b7cf6d sadziaa\n8ae862b0 x5uwoqd\n8bbeb160 yapgpda\n8c1dfe5a ilye4na\n8c539e52 bpobjnb\n8d874f55 stance\n8da10a32 xbrnlf\n8db8f9a4 gear\n8df7fe03 nce2ueg\n8f00b7f4 j8gtnwe\n8fd2d63e xqavqoa\n90228a9b fdzcc2c\n908644f2 ismdb1e\n913af9a2 awh5q9\n91f98cec sxb9xv\n9256767e bspcc1\n92744c94 uz9ikua\n93699a9f ng8t2h\n94b551d6 mrf_3sd\n94c8e108 iegpmcb\n95417727 z53yqx\n95c46304 ww3bwxa\n95e73c23 z4p4h5a\n9611c029 aff_tl\n96e597aa eg5668\n974988fb mq6ltge\n98b4aaf0 hpinuxg\n99901914 tkuebta\n99da4321 zmlug_\n99efa19f r5y2rfa\n9a21c77e pj81yme\n9a34c336 mra3dwb\n9a9b14c4 khxx8ka\n9b738dca ih9ii3\n9bbb856e job\n9c38c179 phase\n9d550ad3 b93vtpd\n9d5d6cc7 qoi7xi\n9ddf0683 byobdbc\n9e7e0524 jo1523b\n9ea124c4 wi5o0tc\n9ec078a2 or2hz5i\na09ccd0a lhixsu\na0ca5130 sp5td6b\na1659a75 mxsqcpb\na2bc3db6 sqzqg3c\na3005e44 pu9chhc\na33df340 ggammg\na4c332a8 nkjr1ra\na5023836 v0zaf3\na5ae4500 drone\na5d1f45b b5a74a\na5f83fa0 vw8ahra\na5fb73ef o5w_lye\na6a66276 nloiewf\na74ef0d5 x97c5fa\na8a7a276 cqx1v1\na98cef24 hvkquyb\na996fdd0 oqp0j0a\nac08fe53 ak4h2w\nacb8e785 nbkn9u\nacc8adbd size_x\nacf8f4de nnofisb\nad1808d1 tga51_c\nad7ddda8 f4hx_6\naea15b36 s3s364a\naf4c7e8a ru8yat\naf97ede7 fjpn_od\nb0e87fae i4z9vic\nb19ad128 active\nb2205a6e isxcmda\nb23ad39c yxmfqgb\nb2587fbd seed\nb2f605cd e9opnca\nb3b69c52 atu93n\nb463e168 kv9qrhc\nb4d3d2c4 dys9moa\nb538a8fd bzdgzaa\nb6347304 kdu0mfc\nb6973fda b5nwp2\nb741b700 kimzuz\nb812a6da h06eqj\nb897e2d8 o_u75zc\nb8ba2a04 wiksuti\nba4551c7 mbtsw5h\nbbecde19 owrhyme\nbce36da3 kxfu5qa\nbd5b4583 g3drcia\nbdc1cb8a npqf7xc\nbe1fda03 q0875e\nbe76ee23 vmi2e_i\nc20428c6 k33u4bc\nc24e6614 g1s7ykc\nc2eb5c15 q4mb9xc\nc336a25c key\nc3a3f66c dvpupm\nc41e1a93 jitvf7\nc4c9b9ef sfct1ea\nc58881d5 gde9xi\nc5d4c75c o4x763a\nc6819f35 nvhgsb\nc6fe28e8 gp155y\nc71487e9 s2hh3jc\nc780ed5e failed\nc92b2117 nrz5xra\nc93d2240 uhagbh\nc9783998 mk4ovb\nca0ae4bd dkmpepb\nca4d820a y3ta4de\ncac86b86 h76ajee\ncad5b537 n64_1le\ncb0453ea health\ncc0b45e5 qpjmo4\ncca43d10 gc8ab\nccd4ed7c uzik3k\ncd889dbc r290mha\nce125651 fydbu0b\ncf55c86e xllcyj\nd040a7f9 npunele\nd056486c grbej4a\nd1930672 a164bed\nd22b948c owner\nd4088bd8 qrc0oe\nd49efb40 qj687ja\nd5077fc6 ryw3ge\nd5a66654 wb72fy\nd648e3a3 brake\nd6a4a959 q9dvfyc\nd6e3606a stjcfi\nd7082cbf x386md\nd7a5d63e hhrfiqc\nd7ffd7d1 aksdnb\nd8320b91 fr23vb\nd8819b3e locked\nd9085a49 p2peppa\nd92082f9 du7kbt\nd9810f60 fuel\nd9d28923 w73eyta\nda1ad977 ujwrsce\nda68ae40 cf8u65d\ndab52fe8 o2nrhyb\ndae681f4 v9v2iha\ndba62235 s2ihyg\ndc9fd59c lfoiz9\ndfbea721 lll4kda\ne00857ad wn4bd5g\ne0a79052 ouo7_o\ne144c5e3 mm9hm0\ne22bdb62 zho47q\ne3186939 enjo5k\ne34c21a2 axkb5ba\ne3826486 ja91kcc\ne4158f0b c7rrqka\ne4d00fe1 u96o1lc\ne525ddf7 bsmxt_c\ne525fa9c agg1dab\ne544ab57 l64z7hc\ne725c1b3 ayn9dub\ne725d2d1 bqdwo4b\ne7e8099d ten4bra\ne875b703 bhc1yzc\ne8e5d7de p7cno0c\ne9bb563f imagqpa\nea04d444 h1ajrla\nead4dd3f uuk7gbb\nec64918b w5kykv\ned3b9b9b zztql3b\nedbf0131 e326lmb\neeb1225e a00wd5d\neef04e89 rvanyac\nef17e023 khkalp\nefe211ca d2ad8u\nf06bf1ae qlc26mb\nf1d8b86f p2hfkg\nf298010f ecgzr3a\nf299681b romjh2\nf2ccc2f2 smxovw\nf37a8e24 o804lff\nf4b46247 uto54dc\nf4ed7ac2 wyhy_w\nf6275c53 bybgjfa\nf7684901 whhuiab\nf819a504 upkqpm\nf8d23bd2 vnbwh6a\nfa559991 m4y2rw\nfaaa8598 c4zfiq\nfafc1456 cmd561c\nfb083bdd d73m6oa\nfbfc1639 t9js94\nfc83cb0e s0be6fd",
}

end)()
local SEED = (function()
-- NarrowHUD's starting knowledge: what it learned in luka189's own play, shipped so weapons show before their
-- first shot. Merged under what a player's game learns (theirs wins). Made with tools/make_seed.py.
return {
  zoom = {   -- (a scope with zeroing: the step in the options field; luka's 2026-10-30 marks; tools/make_seed.py EXTRA)
    ["30294946"] = true,
    a4eff4fa = true,
  },
  charge2 = {
    ["17783758"] = 1.6,
    ["366d3622"] = 3,
  },
  down = {
    ["17783758"] = 31.2,
    ["3622f8dc"] = 6.4,
    ["366d3622"] = 6.8,
    ["42a6b5ba"] = 8.4,
    ["4e87d68d"] = 9.7,
    ["7dce85e3"] = 24.7,
    ["960653cb"] = 7.2,
    d496b132 = 11.4,
    feae4480 = 10,
  },
  grip = {
    ["0fe87029"] = 5,
    ["1220e497"] = 1,
    ["15ae0889"] = 10,
    ["17783758"] = 52,
    ["17b02218"] = 80,
    ["1d3b01d7"] = 36,
    ["2166c7a1"] = 70,
    ["26acc614"] = 61,
    ["2ddd091d"] = 60,
    ["2df95dfe"] = 15,
    ["30294946"] = 10,
    ["314a1bf5"] = 20,
    ["3244dc49"] = 10,
    ["3622f8dc"] = 70,
    ["362577f7"] = 1,
    ["366d3622"] = 20,
    ["36fcbd00"] = 70,
    ["3b60cae4"] = 9,
    ["3d538455"] = 20,
    ["42a6b5ba"] = 10,
    ["437d9eed"] = 5,
    ["4e64c4dc"] = 10,   -- (a tester's log, 2026-10-28; tools/make_seed.py EXTRA)
    ["4e87d68d"] = 9,
    ["521229d8"] = 10,
    ["5590232e"] = 70,
    ["56e55184"] = 70,
    ["61e573c5"] = 52,   -- (a tester's log, 2026-10-28; tools/make_seed.py EXTRA)
    ["656d507b"] = 51,
    ["6b2c3bed"] = 42,
    ["6b47e064"] = 50,
    ["6ec2a850"] = 21,
    ["7bfb2e06"] = 22,
    ["7dce85e3"] = 15,
    ["82a8d3c2"] = 10,
    ["83d1036e"] = 20,
    ["8a3c6fee"] = 20,
    ["8c0aee6e"] = 51,
    ["8fcdd35c"] = 10,
    ["9c06f074"] = 80,   -- SG-20 Halt (three testers' logs; tools/make_seed.py EXTRA)
    ["9e18f0cf"] = 51,
    ["9f16a5a2"] = 10,
    a4eff4fa = 52,
    ["ab38cade"] = 10,   -- (a tester's log, 2026-10-28; tools/make_seed.py EXTRA)
    b2bfd847 = 20,
    b3246bb7 = 50,
    ba161726 = 14,
    ["c4235b66"] = 90,   -- Liberator Legacy (a player's 2026-10-28 log; tools/make_seed.py EXTRA)
    c7dfd9eb = 36,
    c920c2d3 = 1,
    cfaa9ddc = 10,
    d100e0c8 = 20,
    d496b132 = 15,
    d724a2f9 = 20,
    e645b6ee = 10,
    f18d75e5 = 15,
    f94a73b3 = 1,
    fd585726 = 1,
    feae4480 = 1,
  },
  heat = {
    ["17783758"] = 100,
    ["366d3622"] = 100,
    ["42a6b5ba"] = 100,
    ["4e87d68d"] = 100,
    d100e0c8 = 100,
  },
  mag = {
    ["0fe87029"] = 50,
    ["104184f7"] = 100,
    ["11d8c98b"] = 43,
    ["1220e497"] = 5,
    ["15ae0889"] = 5,
    ["15f1a9f0"] = 500,
    ["16425925"] = 1,
    ["17b02218"] = 4,
    ["193ffddf"] = 8,
    ["1962a5a9"] = 24,
    ["1d3b01d7"] = 6,
    ["2166c7a1"] = 50,
    ["26acc614"] = 1,
    ["2ac9b588"] = 12,
    ["2ddd091d"] = 125,
    ["2df95dfe"] = 1,
    ["30294946"] = 10,
    ["303d2220"] = 9,
    ["30b55bbc"] = 45,
    ["314a1bf5"] = 3,
    ["3244dc49"] = 40,
    ["362577f7"] = 1,
    ["3b60cae4"] = 6,
    ["3b718900"] = 18,
    ["3bf357e5"] = 45,
    ["3d538455"] = 4,
    ["3e51c09b"] = 30,
    ["3f87a7e8"] = 1,
    ["437d9eed"] = 3,
    ["4daea8e1"] = 15,
    ["521229d8"] = 249,
    ["5590232e"] = 44,
    ["56e55184"] = 25,
    ["5e0cd6f6"] = 7,
    ["5f3517bf"] = 35,
    ["656d507b"] = 7,
    ["6876b30a"] = 11,
    ["69971ef9"] = 50,
    ["6b2c3bed"] = 1,
    ["6b47e064"] = 119,
    ["6c26a65d"] = 15,
    ["6cc38f79"] = 9,
    ["6ec2a850"] = 1,
    ["756a4e4d"] = 1,
    ["7bfb2e06"] = 10,
    ["82a8d3c2"] = 15,
    ["8583e435"] = 45,
    ["8c0aee6e"] = 10,
    ["8fcdd35c"] = 45,
    ["942a0601"] = 45,
    ["967a3fed"] = 30,
    ["96c8cffd"] = 43,
    ["9c2e7f43"] = 299,
    ["9e18f0cf"] = 99,
    ["9f16a5a2"] = 14,
    a41ddfcd = 19,
    a4eff4fa = 5,
    a6445802 = 12,
    aca565f4 = 8,
    b30f446f = 24,
    b3246bb7 = 1000,
    b697955d = 7,
    ba161726 = 15,
    bd5f17dd = 8,
    be9b793e = 25,
    c0ff5282 = 1,
    c7dfd9eb = 10,
    c920c2d3 = 13,
    cd0e4b4a = 45,
    cfaa9ddc = 49,
    d724a2f9 = 1,
    da0f356e = 4,
    def25ee4 = 150,
    e1f10066 = 6,
    e42d5902 = 45,
    e645b6ee = 174,
    eb38d34e = 5,
    f18d75e5 = 8,
    f2c595ea = 3,
    f94a73b3 = 1,
    fbc7f2e1 = 38,
    fc1ece86 = 5,
    fe760204 = 58,
  },
  modes = {
    ["0fe87029"] = "2",
    ["104184f7"] = "1",
    ["11d8c98b"] = "1,2,3",
    ["1220e497"] = "2",
    ["15ae0889"] = "2",
    ["15f1a9f0"] = "1",
    ["17783758"] = "2",
    ["17b02218"] = "1",
    ["193ffddf"] = "2",
    ["1962a5a9"] = "1,2",
    ["1d3b01d7"] = "2",
    ["26acc614"] = "5,6",
    ["2ac9b588"] = "2",
    ["2ddd091d"] = "1",
    ["2df95dfe"] = "2",
    ["30294946"] = "2",
    ["303d2220"] = "2",
    ["30b55bbc"] = "1,2,3",
    ["314a1bf5"] = "6",
    ["3244dc49"] = "1,2,3",
    ["3622f8dc"] = "1",
    ["362577f7"] = "2",
    ["366d3622"] = "2",
    ["36fcbd00"] = "2",
    ["3b60cae4"] = "2",
    ["3b718900"] = "2",
    ["3bf357e5"] = "1,2",
    ["3d538455"] = "2",
    ["3e51c09b"] = "1,2",
    ["3f87a7e8"] = "2,4",
    ["42a6b5ba"] = "1",
    ["437d9eed"] = "2,4",
    ["4daea8e1"] = "2",
    ["4e87d68d"] = "2",
    ["521229d8"] = "1",
    ["5590232e"] = "1,2,3",
    ["56e55184"] = "2,1",
    ["5e0cd6f6"] = "1",
    ["5f3517bf"] = "1,2,3",
    ["656d507b"] = "1",
    ["6876b30a"] = "1,2",
    ["69971ef9"] = "1,2,3",
    ["6b2c3bed"] = "2",
    ["6b47e064"] = "1",
    ["6c26a65d"] = "2",
    ["6cc38f79"] = "2",
    ["6ec2a850"] = "2",
    ["756a4e4d"] = "1",
    ["7bfb2e06"] = "2,1",
    ["7dce85e3"] = "1",
    ["82a8d3c2"] = "2,3",
    ["83d1036e"] = "2",
    ["8583e435"] = "1,2,3",
    ["8a3c6fee"] = "2",
    ["8c0aee6e"] = "1,2",
    ["8fcdd35c"] = "1,3",
    ["942a0601"] = "1",
    ["960653cb"] = "1",
    ["967a3fed"] = "1,2",
    ["96c8cffd"] = "2,3,1",
    ["9c2e7f43"] = "1",
    ["9e18f0cf"] = "1",
    ["9f16a5a2"] = "2",
    a41ddfcd = "1,2",
    a4eff4fa = "2",
    a6445802 = "2",
    aca565f4 = "2",
    b2bfd847 = "2",
    b30f446f = "3,2",
    b3246bb7 = "1",
    b697955d = "2",
    ba161726 = "2",
    bd5f17dd = "2",
    be9b793e = "2",
    c0ff5282 = "2",
    c7dfd9eb = "2",
    c920c2d3 = "3",
    cd0e4b4a = "1",
    cfaa9ddc = "1,4,7",
    d100e0c8 = "1",
    d496b132 = "1",
    d724a2f9 = "2",
    def25ee4 = "1",
    e1f10066 = "1,2",
    e42d5902 = "1,2,3",
    e645b6ee = "1",
    eb38d34e = "2",
    f18d75e5 = "2",
    f2c595ea = "1",
    f94a73b3 = "3",
    fbc7f2e1 = "1,2,3",
    fc1ece86 = "2",
    fd585726 = "3",
    fe760204 = "1,2",
    feae4480 = "1",
  },
  options1 = {
    ["0fe87029"] = "0",
    ["104184f7"] = "0",
    ["11d8c98b"] = "0",
    ["1220e497"] = "0",
    ["15ae0889"] = "0",
    ["15f1a9f0"] = "0",
    ["17783758"] = "0",
    ["17b02218"] = "0",
    ["193ffddf"] = "0",
    ["1962a5a9"] = "0",
    ["1d3b01d7"] = "0",
    ["26acc614"] = "0",
    ["2ac9b588"] = "0",
    ["2ddd091d"] = "0",
    ["2df95dfe"] = "0",
    ["30294946"] = "0",
    ["303d2220"] = "0",
    ["30b55bbc"] = "0",
    ["314a1bf5"] = "0",
    ["3244dc49"] = "0",
    ["3622f8dc"] = "0",
    ["362577f7"] = "0",
    ["366d3622"] = "0",
    ["36fcbd00"] = "0",
    ["3b60cae4"] = "0",
    ["3b718900"] = "0",
    ["3bf357e5"] = "0",
    ["3d538455"] = "0",
    ["3e51c09b"] = "0",
    ["3f87a7e8"] = "0",
    ["42a6b5ba"] = "0",
    ["437d9eed"] = "0",
    ["4daea8e1"] = "0",
    ["4e87d68d"] = "0",
    ["521229d8"] = "0",
    ["5590232e"] = "0",
    ["56e55184"] = "0",
    ["5e0cd6f6"] = "0",
    ["5f3517bf"] = "0",
    ["656d507b"] = "0,1",
    ["6876b30a"] = "0",
    ["69971ef9"] = "0",
    ["6b2c3bed"] = "0",
    ["6b47e064"] = "0",
    ["6c26a65d"] = "0",
    ["6cc38f79"] = "0",
    ["6ec2a850"] = "0",
    ["756a4e4d"] = "0",
    ["7bfb2e06"] = "0,1",
    ["7dce85e3"] = "0",
    ["82a8d3c2"] = "0",
    ["83d1036e"] = "0",
    ["8583e435"] = "0",
    ["8a3c6fee"] = "0,1",
    ["8c0aee6e"] = "0",
    ["8fcdd35c"] = "0",
    ["942a0601"] = "0",
    ["960653cb"] = "0",
    ["967a3fed"] = "0",
    ["96c8cffd"] = "0",
    ["9c2e7f43"] = "0",
    ["9e18f0cf"] = "0",
    ["9f16a5a2"] = "0",
    a41ddfcd = "0",
    a4eff4fa = "0",
    a6445802 = "0",
    aca565f4 = "0",
    b2bfd847 = "0,1",
    b30f446f = "0",
    b3246bb7 = "0",
    b697955d = "0",
    ba161726 = "0",
    bd5f17dd = "0",
    be9b793e = "0",
    c0ff5282 = "0",
    c7dfd9eb = "0",
    cd0e4b4a = "0",
    cfaa9ddc = "0",
    d100e0c8 = "0",
    d496b132 = "0",
    d724a2f9 = "0",
    def25ee4 = "0",
    e1f10066 = "0",
    e42d5902 = "0",
    e645b6ee = "0",
    eb38d34e = "0",
    f18d75e5 = "0",
    f2c595ea = "0",
    f94a73b3 = "0",
    fbc7f2e1 = "0",
    fc1ece86 = "0",
    fd585726 = "1,0",
    fe760204 = "0",
    feae4480 = "0",
  },
  pack = {
    ["07170cd0"] = 4,
    ["139293f3"] = 120,
    ["32fd58bf"] = 1000,
    ["42eb8b5a"] = 6,
    ["447380d4"] = 4,
    ["66d03a73"] = 6,
    ["6c17c3b1"] = 500,
    ["764f37a0"] = 5,
    ["816a11e0"] = 5,
    ["9f9ef431"] = 5,
    a42ace6a = 6,
    b32572a6 = 4,
    b5b092f9 = 4,
    b9ea8c7e = 10,
    ee341a1b = 8,
  },
  packres = {
    ["656d507b"] = true,
    ["6b2c3bed"] = true,
    ["7bfb2e06"] = true,
    ["83d1036e"] = true,
    ["8a3c6fee"] = true,
    a4eff4fa = true,
    b2bfd847 = true,
  },
  packshow = {
    ["07170cd0"] = true,
    ["32fd58bf"] = true,
    ["6c17c3b1"] = true,
  },
  poses = {
    ["0fe87029"] = "5,30,36",
    ["104184f7"] = "10",
    ["11d8c98b"] = "70,30,36",
    ["1220e497"] = "1,36,30",
    ["193ffddf"] = "80",
    ["1962a5a9"] = "10",
    ["1d3b01d7"] = "36,70,30",
    ["2ac9b588"] = "1,30,36",
    ["303d2220"] = "80",
    ["30b55bbc"] = "10",
    ["3622f8dc"] = "70,30,36",
    ["362577f7"] = "1,30,36",
    ["36fcbd00"] = "70,30,36",
    ["3b60cae4"] = "9,30,36",
    ["3b718900"] = "10",
    ["3bf357e5"] = "10",
    ["3e51c09b"] = "1,30,36",
    ["3f87a7e8"] = "10",
    ["437d9eed"] = "5,30,36",
    ["4daea8e1"] = "1,30,36",
    ["4e87d68d"] = "9,36,30",
    ["5590232e"] = "70,30,36",
    ["56e55184"] = "70,30,36",
    ["5e0cd6f6"] = "15",
    ["5f3517bf"] = "90",
    ["6876b30a"] = "10",
    ["69971ef9"] = "70,36,30",
    ["6b47e064"] = "50",
    ["6c26a65d"] = "10",
    ["6cc38f79"] = "10",
    ["756a4e4d"] = "50",
    ["8583e435"] = "90",
    ["942a0601"] = "70,36,30",
    ["960653cb"] = "15",
    ["967a3fed"] = "10",
    ["96c8cffd"] = "90",
    ["9c2e7f43"] = "10",
    a41ddfcd = "14",
    a6445802 = "10",
    aca565f4 = "80",
    b30f446f = "10",
    b697955d = "52",
    bd5f17dd = "80",
    be9b793e = "10",
    c0ff5282 = "20",
    c7dfd9eb = "1,30,36",
    c920c2d3 = "1,36,30",
    cd0e4b4a = "70,30,36",
    def25ee4 = "60",
    e1f10066 = "51",
    e42d5902 = "90",
    eb38d34e = "70,36,30",
    f2c595ea = "51",
    f94a73b3 = "1,30,36",
    fbc7f2e1 = "10",
    fc1ece86 = "15",
    fd585726 = "1,30,36",
    fe760204 = "90",
    feae4480 = "1,36,30",
  },
  resmax = {
    ["0fe87029"] = 4,
    ["30294946"] = 8,
    b2bfd847 = 5,
  },
  rest2 = {
    ["17783758"] = 4.7,
    ["3622f8dc"] = 0.2,
    ["366d3622"] = 5.8,
    ["4e87d68d"] = 0.4,
    ["960653cb"] = 6.6,
    d100e0c8 = 0,
    d496b132 = 3.9,
    feae4480 = 0,
  },
  rpmadj = {
    ["521229d8"] = true,
    ["6b47e064"] = true,
    ["9e18f0cf"] = true,
    cfaa9ddc = true,
    e645b6ee = true,
  },
  rpmbase = {
    ["521229d8"] = "700,850,1150",
    ["6b47e064"] = "160,240,320",
    ["9e18f0cf"] = "450,600,750",
    cfaa9ddc = "300,550,750",
    e645b6ee = "630,760,900",
  },
  rpms = {
    ["15ae0889"] = "29",
    ["17783758"] = "30",
    ["1d3b01d7"] = "99",
    ["26acc614"] = "60,54",
    ["2ac9b588"] = "750",
    ["2df95dfe"] = "54",
    ["314a1bf5"] = "600",
    ["3244dc49"] = "650",
    ["3622f8dc"] = "600",
    ["362577f7"] = "810",
    ["366d3622"] = "10,9",
    ["36fcbd00"] = "810",
    ["3b60cae4"] = "180,200",
    ["3bf357e5"] = "600",
    ["3d538455"] = "216",
    ["3e51c09b"] = "1100",
    ["437d9eed"] = "650",
    ["4daea8e1"] = "900",
    ["521229d8"] = "700,850,1150",
    ["5590232e"] = "475",
    ["56e55184"] = "400",
    ["5f3517bf"] = "600,850",
    ["656d507b"] = "450",
    ["6b47e064"] = "144,216,288",
    ["6ec2a850"] = "600",
    ["7bfb2e06"] = "190",
    ["82a8d3c2"] = "225",
    ["83d1036e"] = "216",
    ["8583e435"] = "640",
    ["8a3c6fee"] = "600",
    ["8c0aee6e"] = "160",
    ["8fcdd35c"] = "1200",
    ["96c8cffd"] = "920",
    ["9c2e7f43"] = "1300",
    ["9e18f0cf"] = "675,405,540",
    b2bfd847 = "600",
    b3246bb7 = "1350",
    b697955d = "400",
    ba161726 = "900",
    c0ff5282 = "600",
    c7dfd9eb = "450",
    c920c2d3 = "450",
    cfaa9ddc = "270,495,675",
    d724a2f9 = "600",
    e1f10066 = "200",
    e42d5902 = "640",
    e645b6ee = "760,900,630",
    fbc7f2e1 = "700",
    fd585726 = "60",
    fe760204 = "400",
  },
  slot = {
    ["0fe87029"] = 2,
    ["104184f7"] = 1,
    ["15ae0889"] = 1,
    ["15f1a9f0"] = 3,
    ["17783758"] = 3,
    ["17b02218"] = 1,
    ["193ffddf"] = 1,
    ["1d3b01d7"] = 2,
    ["2ac9b588"] = 2,
    ["30294946"] = 1,
    ["303d2220"] = 1,
    ["314a1bf5"] = 3,
    ["3622f8dc"] = 1,
    ["362577f7"] = 2,
    ["366d3622"] = 3,
    ["3b60cae4"] = 2,
    ["3d538455"] = 3,
    ["3e51c09b"] = 2,
    ["437d9eed"] = 2,
    ["4e87d68d"] = 2,
    ["6b2c3bed"] = 3,
    ["6b47e064"] = 3,
    ["6cc38f79"] = 1,
    ["7bfb2e06"] = 3,
    ["83d1036e"] = 3,
    ["8a3c6fee"] = 3,
    ["8c0aee6e"] = 3,
    ["8fcdd35c"] = 1,
    ["960653cb"] = 1,
    a4eff4fa = 3,
    aca565f4 = 1,
    b2bfd847 = 3,
    bd5f17dd = 1,
    c7dfd9eb = 2,
    c920c2d3 = 2,
    d100e0c8 = 3,
    e1f10066 = 3,
    eb38d34e = 1,
    f2c595ea = 3,
    f94a73b3 = 2,
    fd585726 = 2,
    feae4480 = 2,
  },
  up = {
    ["17783758"] = 59.8,
    ["3622f8dc"] = 13,
    ["366d3622"] = 32.4,
    ["42a6b5ba"] = 11.6,
    ["7dce85e3"] = 28.6,
    ["960653cb"] = 31.1,
    d496b132 = 12,
    feae4480 = 14.9,
  },
}

end)()

local M={version="2.0.0"}
local log=chef.log
local N={}
;(function() -- 01_core
-- NarrowHUD, core: game data (types, roles), guarded engine reads, the game version check.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)

------------------------------------------------------------------------------------------------ game data
local ROLE = {}            -- role -> { letter, id, name }
for role, r in pairs(DATA.roles) do ROLE[role] = r end
local LETTER = {}          -- letter -> role
for role, r in pairs(ROLE) do LETTER[r.letter] = role end

local TYPES = {}           -- list of { id, name, has = { role = true }, pack = bool }
local function add_types(text, pack)
  for line in string.gmatch(text, '[^\n]+') do
    local id, name, letters = string.match(line, '^(%x+) (%S+) ?(%a*)$')
    if id then
      local has = {}
      for c in string.gmatch(letters, '.') do if LETTER[c] then has[LETTER[c]] = true end end
      -- fed: a weapon with no ammo of its own (it fires straight from its backpack)
      -- (and a reload stage: the types without one ride along with other equipment, seen 2026-10-24)
      local fed = not pack and not (has.rounds or has.slot0 or has.heat) and has.reload_stage == true
      local noammo = not pack and not (has.rounds or has.slot0 or has.heat) and not fed and has.held == true
      TYPES[#TYPES + 1] = { id = id, name = name, has = has, pack = pack, fed = fed, noammo = noammo }
    end
  end
end
-- the player and avatar first (one of each), then backpacks, then weapons
TYPES[1] = { id = DATA.player.id, name = DATA.player.name, has = {}, player = true }
TYPES[2] = { id = DATA.avatar.id, name = DATA.avatar.name, has = {}, avatar = true }
add_types(DATA.backpacks, true)
add_types(DATA.weapons, false)
-- In a hand: only types with an owner field. Every weapon learned in testing has one (59 types); a player's log as host
-- (1.0.1) had two without it (e45066e4, b747653b: objects a host owns, fired as the player fired) learned to the
-- rifles' pose and shown in place of the player's own weapon.
-- (1.5.39) never in a hand: the guard dogs' guns (the AX/AR-23, the Rover's laser, the Hot Dog, the K-9, the Dog
-- Breath and their mounts), weapons of yours that fire by themselves from your backpack; the ids as HUDdle 0.5.11
-- lists them (named through HD2Runtime), an idea taken from its guard-dog fix (docs/RESEARCH.md). The learning
-- rules below catch them too (they fire with their trigger never held, they aim by themselves); this is first.
local NOHAND = {}
for id in string.gmatch('1f3765c1 60cac78a 530e19df 5ada6b71 76120872 86709cb9 53dc48fe', '%x+') do NOHAND[id] = true end
local HANDHELD = {}
for _, t in ipairs(TYPES) do if t.has.owner and not NOHAND[t.id] then HANDHELD[t.id] = true end end
log('NarrowHUD %s: %d types (game build %s)', M.version, #TYPES, tostring(DATA.build))

local AVATAR_RESOURCE = '4d1c334d294dfa97'   -- the third-person Helldiver unit
local GRIP_VARIABLE = 'weapon_selected'      -- the avatar's hand pose (0: nothing in hand)
local NO_OBJECT = 32767
local THROWABLE = { [40] = true, [41] = true }   -- (42 is the C4 detonator's, and the underhand throw's: 12_throw)

------------------------------------------------------------------------------------------------ engine reads
-- (1.5.34) "Testing: reads" (F9, with the research log): which of the mod's engine reads are made, for the disconnect
-- bisection on a machine that drops with R1 (reads everything, draws nothing): 2 no host objects (04_objects's scan),
-- 3 no field reads, 4 no object reads at all (the scan neither), 5 no Unit calls (the hand pose), 6 no floor /
-- underbarrel reads (field(), below: the 1.5.13 reads). N.read_level.
local OFF = 'off (Testing: reads)'
local function call(kind, name, ...)
  local lv = N.read_level
  if lv and lv > 1 then
    if (lv == 3 or lv == 4) and (name == 'GameSession.game_object_field' or name == 'GameSession.game_object_field_batched') then return nil, OFF end
    if lv == 4 and (name == 'GameSession.game_object_exists' or name == 'GameSession.game_object_is_type' or name == 'GameSession.objects_owned_by') then return nil, OFF end
    if lv == 5 and string.sub(name, 1, 5) == 'Unit.' then return nil, OFF end
  end
  return chef.call_kind(name, kind, ...)
end
-- a field or type id as lower-case hex without leading zeros (Network.object_info's ids come without them)
local function norm_id(id)
  if type(id) == 'number' then id = string.format('%x', id) end
  if type(id) ~= 'string' then id = id ~= nil and tostring(id) or nil end
  return id and (string.gsub(string.lower(id), '^0+', '')) or nil
end
local function live_fields(name)
  local ok, info = pcall(call, 'objinfo', 'Network.object_info', name)
  if not ok or type(info) ~= 'table' or type(info.fields) ~= 'table' then return nil end
  local set = {}
  for _, f in ipairs(info.fields) do
    local id = type(f) == 'table' and norm_id(f.id)
    if id then set[id] = true end
  end
  return set
end
-- Chef 1.1 refuses the calls NarrowHUD reads your weapons with: said on screen for the first 25 s of a mission
local blocked = { n = 0, said = false, since = nil }
-- An object can go between two reads (an expendable weapon is dropped and destroyed the moment it's used, and its id
-- can come back as another type); reading a gone object's field can end the game. So before an object's fields are
-- read, once a frame: it still exists and is still that type. A gone one is forgotten until the next scan.
N.frame, N.checked = 0, {}
N.forget = nil                                   -- set below (the objects list)
local function alive(s, goid, t)
  local c = N.checked[goid]
  if c and c.frame == N.frame and c.t == t then return c.ok end
  local ok = call('exists', 'GameSession.game_object_exists', s, goid) == true
  if ok and t then ok = call(t.id, 'GameSession.game_object_is_type', s, goid, t.name) == true end
  N.checked[goid] = { frame = N.frame, t = t, ok = ok }
  if not ok and N.forget then N.forget(goid) end
  return ok
end
local function field(s, goid, t, role)
  if not (t and t.has[role]) then return nil end
  -- (Testing: reads 6: the two object-reference fields 1.5.18 began reading every tenth of a second, floor and
  -- underbarrel, left unread: the one read-side difference between 1.5.13 and 1.5.26)
  if N.read_level == 6 and (role == 'floor' or role == 'underbarrel') then return nil end
  if not alive(s, goid, t) then return nil end
  return call(t.id .. '.' .. role, 'GameSession.game_object_field', s, goid, ROLE[role].name)
end

------------------------------------------------------------------------------------------------ the game's version
-- NarrowHUD's data (types and fields, by hash) is taken from one game build's network config. A patch can rename or
-- move fields, and reading a field a type doesn't declare can end the game, so on a game version NarrowHUD wasn't
-- made for it stays off (with a message) unless the player turns on "Run on a game version it wasn't made for".
-- Application.build_identifier per Steam build (the engine's own string):
local BUILDS = {
  ['stingray:46659 e176252a3ac4eb5436b25e7cef665a8c71afa243'] = '26088801',   -- 2026-10-22 (7.2.1)
  ['stingray:46805 437a3d445f9df7662b60086ac8ae3c65b5c95da6'] = '26251122',   -- 2026-10-29 (7.2.2: one new type, no field moved)
}
local game_build = { id = nil, known = nil }
do
  local id = chef.call and chef.call('Application.build_identifier')
  game_build.id = type(id) == 'string' and id or nil
  if game_build.id == nil then
    game_build.known = nil
    log('game version: unknown (no build identifier): running')
  elseif BUILDS[game_build.id] == DATA.build then
    game_build.known = true
    log('game version: %s (Steam build %s, as NarrowHUD\'s data)', game_build.id, DATA.build)
  else
    game_build.known = false
    log('game version: %s, not the one NarrowHUD\'s data is from (Steam build %s): off unless "Run on a game version it wasn\'t made for" is on', game_build.id, DATA.build)
  end
end


N.ROLE, N.TYPES, N.HANDHELD, N.AVATAR_RESOURCE, N.GRIP_VARIABLE, N.NO_OBJECT = ROLE, TYPES, HANDHELD, AVATAR_RESOURCE, GRIP_VARIABLE, NO_OBJECT
N.NOHAND = NOHAND
-- Chef 1.4.0 or newer (its players event is the mark): chef.bitmap no longer strobes beside other mods' bitmaps and
-- chef.line's lines go by themselves, so the two workarounds for 1.3 (the uv call for textures, a line of nothing
-- after the last drop line) aren't needed; and the players event is there for the disconnect logs
N.CHEF14 = chef.has ~= nil and chef.has('players_event') == true
-- (1.5.36) the two object-reference reads 1.5.18 began making every tenth of a second (floor, underbarrel: the one
-- read-side difference between 1.5.13 and 1.5.26, docs/DEVLOG.md) can be built out: tools/build.py --no-ref-reads
-- sets M.ref_reads = false, and then floor is never read and underbarrel only while the fire mode selects it, as
-- 1.5.13 read them. An interim public build while the disconnect reports are open; nothing else changes.
N.REF_READS = M.ref_reads ~= false
if not N.REF_READS then log('reads: floor never, underbarrel only while selected (as 1.5.13; this build, for the disconnect reports)') end
N.THROWABLE, N.call, N.norm_id, N.live_fields, N.blocked, N.alive = THROWABLE, call, norm_id, live_fields, blocked, alive
N.field, N.game_build = field, game_build
end)()

N.cfg={research=false,fire=1,wheel=1,any_build=false}
N.MOUSE_BUTTONS={"left","right","middle","extra_1","extra_2"}
N.KNOWN_FIELDS={}
N.read_level=2
;(function() -- 03_learned
-- NarrowHUD, learned: what NarrowHUD learns (the learned file, the shipped seed, forgetting), key bindings, hand poses per type.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local HANDHELD, cfg = N.HANDHELD, N.cfg

local learned = { grip = {}, mag = {}, heat = {}, rest = {}, charge2 = {}, up = {}, down = {}, modes = {}, rpms = {},
                  pack = {}, options1 = {}, packres = {}, rest2 = {}, poses = {},
                  packshow = {}, rpmadj = {}, rpmbase = {}, slot = {}, resmax = {}, reload_t = {}, reload_e = {},
                  stim = {}, shot = {}, zoom = {} }
-- The learned file: what each kind holds per type id (8 hex digits), and the file's version (_v). Entries that don't
-- fit (a damaged or hand-edited file) are dropped and counted in the log; a file from a newer NarrowHUD is read for
-- what fits.
local LEARNED_VERSION = 1
local LEARNED_SHAPE = { grip = 'number', mag = 'number', heat = 'number', rest = 'number', charge2 = 'number',
  up = 'number', down = 'number', modes = 'string', rpms = 'string', pack = 'number', options1 = 'string',
  packres = 'boolean', rest2 = 'number', poses = 'string', packshow = 'boolean', rpmadj = 'boolean',
  rpmbase = 'string', slot = 'number', resmax = 'number', reload_t = 'number', reload_e = 'number', stim = 'number', shot = 'number',
  zoom = 'boolean' }
local function read_learned(t)
  local kept, dropped = 0, 0
  for kind, want in pairs(LEARNED_SHAPE) do
    local src = t[kind]
    if type(src) == 'table' then
      local out = {}
      for id, v in pairs(src) do
        local ok = type(id) == 'string' and string.find(id, '^%x%x%x%x%x%x%x%x$') ~= nil and type(v) == want
        if ok and want == 'number' then ok = v == v and v > -1e9 and v < 1e9 end
        if ok then out[id], kept = v, kept + 1 else dropped = dropped + 1 end
      end
      learned[kind] = out
    elseif src ~= nil then
      dropped = dropped + 1
    end
  end
  return kept, dropped
end
do
  -- (load_table's second value says why there's no table: called on its own, an 'and' would drop it)
  local ok, t, why = true, nil, nil
  if chef.load_table then ok, t, why = pcall(chef.load_table, 'learned') end
  if not ok then
    log('learned file: could not be read (%s): starting from the shipped knowledge', tostring(t))
  elseif type(t) == 'table' and type(t.elements) == 'table' then
    -- (1.2.1: a layout pasted into this file instead of the layout file, a player's report: NarrowHUD rewrites this
    -- file as it learns, so the paste looked "overwritten". It's moved to the layout file, and said on screen)
    local moved = false
    if chef.save_table then
      local okc, done = pcall(chef.save_table, 'layout', t)
      moved = okc and done ~= false
    end
    log('learned file: it holds a layout (the layout editor\'s file): %s; the learned file starts from the shipped knowledge',
      moved and 'moved to the layout file (chef_data_luka189_2fnarrowhud__layout.lua)' or 'could not be moved to the layout file')
    N.startup_flash = moved and 'NarrowHUD: your layout was in the learned file: moved to the layout file'
      or 'NarrowHUD: your layout is in the learned file: paste it into the file ending in __layout.lua'
    N.learned_rewrite = true                         -- (the learned file written back as learned knowledge)
  elseif type(t) == 'table' then
    local kept, dropped = read_learned(t)
    local v = tonumber(t._v) or 0
    if v > LEARNED_VERSION then log('learned file: from a newer NarrowHUD (version %d): read what fits', v) end
    if dropped > 0 then log('learned file: %d entries kept, %d that didn\'t fit dropped', kept, dropped) end
  elseif why and not string.find(tostring(why), 'none saved') and not string.find(tostring(why), 'no such file')
      and not string.find(tostring(why), 'missing') then
    log('learned file: not read (%s): starting from the shipped knowledge', tostring(why))
  end
end
local function save_learned()
  if not chef.save_table then return end
  local t = { _v = LEARNED_VERSION }
  for k, v in pairs(learned) do t[k] = v end
  local ok, done, why = pcall(chef.save_table, 'learned', t)
  if not ok or done == false then log('learned file: not saved (%s)', tostring(ok and why or done)) end
end
-- hand poses measured in our own research rounds (2026-10-24);
-- anything else is learned on its first shot
local SEED_GRIPS = { ['8fcdd35c'] = 10, ['30294946'] = 10, ['17b02218'] = 80, ['a4eff4fa'] = 52, ['17783758'] = 52,
                     ['56e55184'] = 70, ['f94a73b3'] = 1 }
-- the shipped starting knowledge (src/learned_seed.lua): under what this game learned, theirs wins
local function apply_seed(only)
  for id, g in pairs(SEED_GRIPS) do if (only == nil or only == id) and learned.grip[id] == nil then learned.grip[id] = g end end
  for kind, tbl in pairs(SEED or {}) do
    if type(tbl) == 'table' and learned[kind] then
      for id, v in pairs(tbl) do
        if (only == nil or only == id) and learned[kind][id] == nil then learned[kind][id] = v end
      end
    end
  end
end
apply_seed()
-- Heat weapons whose heat goes past 100 (the player, 2026-10-25): the Double-Edge Sickle heats to 200, hurts you from
-- 50, more from 100, a lot from 180. Marks (heat, colour: 1 yellow, 2 orange, 3 red). Not a charge weapon (its first
-- shots were once taken for a charge).
local HEAT_RANGE = { ['960653cb'] = { top = 200, marks = { { 50, 1 }, { 100, 2 }, { 180, 3 } } } }
-- Charge weapons (the heat jumps once a charge is held to full): only these. Learning which weapons charge took
-- lasers for them (the Double-Edge Sickle, the Dagger: a burst seen in one read looks like a charge's jump), so the
-- list is fixed; the time is still refined from play. The Nova 1.6 s (timed in game), the Quasar 3 s (learned).
local CHARGE_WEAPONS = { ['17783758'] = 1.6, ['366d3622'] = 3 }
for id in pairs(learned.charge2) do if not CHARGE_WEAPONS[id] then learned.charge2[id] = nil end end
for id, secs in pairs(CHARGE_WEAPONS) do if learned.charge2[id] == nil then learned.charge2[id] = secs end end
if learned.rest2['17783758'] == nil then learned.rest2['17783758'] = 5 end       -- and it cools to about 5 (seen)
-- A rate of fire setting learned from one rate and that rate 0.9 (Extreme Cold), or from one rate only: dropped (1.0.6:
-- the Sightliner, rates 40 and 36 on two planets, showed 40 RPM). Shipped ones stay.
for id in pairs(learned.rpmadj) do
  if not (SEED and SEED.rpmadj and SEED.rpmadj[id]) then
    local vals = {}
    for v in string.gmatch(learned.rpmbase[id] or '', '[^,]+') do
      local n = tonumber(v)
      local same = false
      for _, u in ipairs(vals) do
        if n and (math.abs(n - u) <= 1.5 or math.abs(n - u * 0.9) <= 1.5 or math.abs(u - n * 0.9) <= 1.5) then same = true end
      end
      if n and not same then vals[#vals + 1] = n end
    end
    if #vals <= 1 then learned.rpmadj[id], learned.rpmbase[id] = nil, nil end
  end
end
-- An overheat point under 30 was a misread (1.0.7: the Scythe "overheats at 0", its heat read 0 as it overheated)
for id, v in pairs(learned.heat) do if v < 30 then learned.heat[id] = nil end end
N.dirty_at = nil
if N.learned_rewrite then N.dirty_at = chef.time() + 5 end
local function learn(kind, id, value)
  if learned[kind][id] == value then return end
  learned[kind][id] = value
  N.dirty_at = N.dirty_at or (chef.time() + 5)
end
-- Forgetting (two keys in the F9 menu, none set by default): the weapon in hand, or everything (pressed twice within
-- 3 s). What's forgotten falls back to the shipped knowledge.
local function forget_type(id)
  for kind in pairs(learned) do learned[kind][id] = nil end
  apply_seed(id)
  N.dirty_at = chef.time()
end
local function forget_all()
  for kind in pairs(learned) do learned[kind] = {} end
  apply_seed()
  N.dirty_at = chef.time()
end
local keys = {}
local tested = false
if chef.bind and chef.has and chef.has('bind') then
  pcall(function()
    -- (as bound in the game: NarrowHUD can't read the game's own key settings). The fire button's row, then the key
    -- it can be (used only when the row says so: shown as none otherwise)
    -- (1.5.82: the Keys heading on the first row; a key row's label through N.menu_label, as chef.bind takes no spec)
    if N.menu_group then N.menu_group('Keys', 'Keys: ') end
    local function kl(l) return N.menu_label and N.menu_label(l) or l end
    local fire_spec = { type = 'choice', label = 'Keys: fire button', choices = { 'Left mouse', 'Right mouse', 'Middle mouse', 'Mouse button 4', 'Mouse button 5', 'Key (next row)' }, default = 1 }
    if N.menu_spec then fire_spec = N.menu_spec('Fire button', 'As bound in the game: a shot counts as yours only within a moment of this button. A keyboard key: the next row.', fire_spec) end
    cfg.fire = chef.option('fire', fire_spec) or 1
    chef.on_change('fire', function(v) cfg.fire = v or 1 end)
    keys.fire = (chef.bind('fire_key', 'off', kl('   Fire key')))
    -- (each in parentheses: chef.bind gives the binding and its menu row, and a call last in a table would add both)
    local sw = { (chef.bind('swap_primary', '1', kl('Swap to primary'))),
                 (chef.bind('swap_secondary', '2', kl('Swap to secondary'))),
                 (chef.bind('swap_support', '3', kl('Swap to support'))) }
    if sw[1] and sw[2] and sw[3] then keys.swap = sw end
    -- the mouse wheel: the game swaps weapons with it by default; one bound to something else in the game (zoom, a
    -- fire mode ...) mustn't swap the HUD (a player's report, 1.0.5)
    local wheel_spec = { type = 'choice', label = 'Keys: wheel swaps weapons', choices = { 'Up and down', 'Up only', 'Down only', 'No' }, default = 1 }
    if N.menu_spec then wheel_spec = N.menu_spec('Wheel swaps weapons', 'As in the game. If your wheel doesn\'t swap weapons there, set No, or a scroll can switch the HUD to the wrong weapon.', wheel_spec) end
    cfg.wheel = chef.option('swap_wheel', wheel_spec) or 1
    chef.on_change('swap_wheel', function(v) cfg.wheel = v or 1 end)
    -- held, the game's weapon options key (R, reload's) makes the wheel change the scope's zoom (up) or the light
    -- (down): no swap then (a player's report, the AMR's scope, 1.0.5)
    keys.weapon_menu = (chef.bind('weapon_menu', 'r', kl('Weapon options (held)')))
    -- (1.2.4: the HUD out of the way while the stratagem key is held; a controller's left shoulder button too)
    -- (no key until set: Left Ctrl, the game's default, is many players' crouch key, and the HUD hid while they crouched)
    keys.strat = (chef.bind('strat_key', 'off', kl('Stratagem key (yours)')))
    if N.settings_hide then N.settings_hide() end
    keys.reload_layout = (chef.bind('reload_layout', 'off', kl('Reload layout file')))
    -- (the Testing rows: 02's toggles first, so the heading sits on them, then the keys)
    if N.settings_testing then N.settings_testing() tested = true end
    keys.forget_weapon = (chef.bind('forget_weapon', 'off', kl('Forget this weapon')))
    keys.forget_all = (chef.bind('forget_all', 'off', kl('Forget all (twice)')))
    keys.log_mark = (chef.bind('log_mark', 'off', kl('A mark in the log')))
  end)
elseif N.settings_hide then N.settings_hide()
end
if not tested and N.settings_testing then N.settings_testing() end

-- A weapon can have several hand poses (with a shield in the other hand: the Verdict at 1, 30 and 36): a set per type
-- ("10,30"), next to the single pose older versions kept (learned.grip).
local distrust = {}                                 -- types with an object that fired without your fire button
-- A type learned for 4 or more hand poses that didn't ship with NarrowHUD isn't one weapon's set: every real one
-- has 1 to 3 (the Verdict's 3, with a shield). As host, SEAF soldiers' guns got learned for every pose you fired at
-- (a 2026-10-25 log: five types, up to 7 poses each), and 1.0.6 learned swaps wrong (a player's Liberator Legacy
-- got the grenade pistol's pose and two more within a second, and was never shown again: a 2026-10-28 report).
-- Until 1.5.14 such a type was never shown again; now its poses are forgotten and it's learned again from your next
-- shot (whether a gun is yours is the aim field's and the trigger's call since 1.2.5).
local function many_poses(id)
  local l = learned.poses[id]
  if not l or (SEED and ((SEED.poses and SEED.poses[id]) or (SEED.grip and SEED.grip[id]))) or SEED_GRIPS[id] then return false end
  local n = 1
  for _ in string.gmatch(l, ',') do n = n + 1 end
  if n < 4 then return false end
  log('type %s: learned for %d hand poses (%s): not one weapon\'s set (an older version learned swaps wrong?): forgotten, learned again from your next shot', id, n, l)
  learn('grip', id, nil)
  learn('poses', id, nil)
  return false
end
local function has_pose(id, grip)
  if not HANDHELD[id] or many_poses(id) then return false end
  if learned.grip[id] == grip then return true end
  local l = learned.poses[id]
  return l ~= nil and string.find(',' .. l .. ',', ',' .. grip .. ',', 1, true) ~= nil
end
local function add_pose(id, grip)
  if has_pose(id, grip) or not HANDHELD[id] or many_poses(id) then return end
  local l = learned.poses[id]
  if learned.grip[id] and not l then l = tostring(learned.grip[id]) end
  learn('poses', id, l and (l .. ',' .. grip) or tostring(grip))
end
local function forget_poses(id)
  learn('grip', id, nil)
  learn('poses', id, nil)
end
-- a fed weapon's pose forgotten as shared with a weapon of its own ammo (05_hand): not learned again this session
-- (1.5.28: a pack going down while the other weapon was held re-learned it every read, 800 log lines a mission)
N.pose_shared = {}
-- one pose taken back (learned from a gun that proved someone else's)
local function remove_pose(id, grip)
  if learned.grip[id] == grip and not learned.poses[id] then learn('grip', id, nil) return end
  local l = learned.poses[id]
  if not l then return end
  local keep = {}
  for g in string.gmatch(l, '[^,]+') do if tonumber(g) ~= grip then keep[#keep + 1] = g end end
  learn('poses', id, #keep > 0 and table.concat(keep, ',') or nil)
  if learned.grip[id] == grip then learn('grip', id, nil) end
end


N.learned, N.save_learned, N.HEAT_RANGE, N.CHARGE_WEAPONS, N.learn, N.forget_type = learned, save_learned, HEAT_RANGE, CHARGE_WEAPONS, learn, forget_type
N.forget_all, N.keys, N.distrust, N.many_poses, N.has_pose, N.add_pose = forget_all, keys, distrust, many_poses, has_pose, add_pose
N.forget_poses, N.remove_pose = forget_poses, remove_pose
end)()

;(function() -- 04_objects
-- NarrowHUD, objects: your objects: the session scan, sorting them into types, whose is whose, your player and Helldiver.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local TYPES, HANDHELD, NO_OBJECT, call, blocked, alive = N.TYPES, N.HANDHELD, N.NO_OBJECT, N.call, N.blocked, N.alive
local field, cfg, learned, forget_poses = N.field, N.cfg, N.learned, N.forget_poses

------------------------------------------------------------------------------------------------ your objects
local objs, queue = {}, {}       -- goid -> { t = index | false, next = n }; goids to type
local me = { player = nil, avatar = nil }
local BUDGET = 1000              -- type tests a frame
N.forget = function(goid) objs[goid] = nil N.checked[goid] = nil end

-- The order types are tried in: as host you own every soldier's and enemy's objects (thousands in a big mission), and
-- each object that's nothing of ours is tried against every type, so ours come first: the player and Helldiver, the
-- weapons known to have a hand pose, backpacks and special packs, the other weapons; the other carried things (research
-- log only) in a second pass, after every object has had its first. (A 46 s mission ended before the weapons were
-- reached when every object went through all 775 types in one pass.)
local ORDER_A, ORDER_2, ORDER_B = nil, nil, nil
local queue_2, queue_b = {}, {}
local function orders()
  if ORDER_A then return end
  local groups = { {}, {}, {}, {}, {} }
  for i, t in ipairs(TYPES) do
    local g
    if t.player or t.avatar then g = 1
    elseif not t.pack and not t.other and (learned.grip[t.id] or learned.poses[t.id]) then g = 2
    elseif t.pack or t.special then g = 3
    elseif not t.other then g = 4
    else g = 5 end
    local l = groups[g]
    l[#l + 1] = i
  end
  -- three passes: what's likely ours (player, Helldiver, weapons with a known pose, packs), the other weapons, the rest
  ORDER_A, ORDER_2, ORDER_B = {}, groups[4], groups[5]
  for g = 1, 3 do for _, i in ipairs(groups[g]) do ORDER_A[#ORDER_A + 1] = i end end
end
local classify_said = {}
local function classify_list(s, list, order, budget, on_miss)
  while budget > 0 and #list > 0 do
    local goid = list[#list]
    local o = objs[goid]
    if o == nil or o.t ~= nil then
      list[#list] = nil
    else
      o.next = o.next or 1
      if o.next == 1 and order == ORDER_A and not alive(s, goid, nil) then o.t = false o.next = #order + 1 budget = budget - 1 end
      while o.next <= #order and budget > 0 do
        local t = TYPES[order[o.next]]
        budget = budget - 1
        local r = not t.gone and call(t.id, 'GameSession.game_object_is_type', s, goid, t.name) or false
        N.type_tests = (N.type_tests or 0) + 1
        if r == true then
          o.t = order[o.next] blocked.yes = true
          -- (research: a weapon that turns up later in the mission: a pick-up, a resupply, or a SEAF reinforcement's)
          local wt = TYPES[o.t]
          if cfg.research and HANDHELD[wt.id] and not wt.pack and not wt.player and not wt.avatar and not wt.other and blocked.since
             and o.seen_at and o.seen_at - blocked.since > 30 and (blocked.new_said or 0) < 300 then
            blocked.new_said = (blocked.new_said or 0) + 1
            log('research: new weapon object %s, type %s, %.0f s into the mission: carry=%s owner=%s held=%s%s', tostring(goid), wt.id,
              o.seen_at - blocked.since, tostring(wt.has.carry and field(s, goid, wt, 'carry')),
              tostring(wt.has.owner and field(s, goid, wt, 'owner')), tostring(wt.has.held and field(s, goid, wt, 'held')),
              o.host and ' (the host\'s)' or '')
          end
          break
        end
        if r == nil then blocked.types = (blocked.types or 0) + 1 end
        o.next = o.next + 1
      end
      if o.t == nil and o.next > #order then
        list[#list] = nil
        if on_miss then on_miss(goid, o) else o.t = false end
      elseif o.t ~= nil then
        list[#list] = nil
      end
    end
  end
  return budget
end
local function classify(s)
  orders()
  local w = chef.world_id and chef.world_id()
  if w ~= classify_said.wid then classify_said.wid, classify_said.t0 = w, chef.time() end
  local budget = classify_list(s, queue, ORDER_A, BUDGET, function(goid, o) o.next = 1 queue_2[#queue_2 + 1] = goid end)
  if #queue == 0 and budget > 0 then
    budget = classify_list(s, queue_2, ORDER_2, budget, function(goid, o)
      if #ORDER_B > 0 then o.next = 1 queue_b[#queue_b + 1] = goid else o.t = false end
    end)
  end
  if #queue == 0 and #queue_2 == 0 and next(objs) ~= nil then
    local wid = chef.world_id and chef.world_id()
    if wid and not classify_said[wid] and chef.in_mission() then
      classify_said[wid] = true
      local n, known = 0, 0
      for _, o in pairs(objs) do n = n + 1 if o.t then known = known + 1 end end
      log('objects sorted: %d of yours, %d of them known types (%.1f s into this world)', n, known, chef.time() - (classify_said.t0 or 0))
      -- (1.5.16 research: what tells one map from another in the log, for the icon strobe: the world id and where you
      -- landed; chef_loader.log's world line has the unit and level counts)
      if cfg.research and chef.camera then
        local cam = chef.camera()
        if cam then log('research: this world: id %s, landed near %.0f,%.0f,%.0f (chef_loader.log has its unit and level counts)', tostring(wid), cam.x, cam.y, cam.z) end
      end
    end
    if budget > 0 then classify_list(s, queue_b, ORDER_B, budget) end
  end
end

-- an owner field's value as a peer id: lower-case hex without leading zeros (its format is still being checked)
local function as_peer(v)
  if type(v) == 'string' then return (string.gsub(string.lower(v), '^0+', '')) end
  return nil
end
local session = { host = nil, peer = nil, mine = 0, hosts = 0, churn = 0, scans = 0 }
local function scan(s, peer)
  if N.read_level == 4 then session.mine, session.hosts = 0, 0 return end   -- (Testing: reads 4: no object reads at all)
  local ids, why = call('owned', 'GameSession.objects_owned_by', s, peer)
  if type(ids) ~= 'table' then
    blocked.n = blocked.n + 1
    if blocked.n == 5 and not blocked.said then
      blocked.said = true
      log('GameSession.objects_owned_by refused (%s): your weapons can\'t be read with this Chef version', tostring(why))
    end
    return
  end
  blocked.n = 0
  -- in someone else's game the host may own your weapons: theirs too, kept only where the owner field says you
  -- (1.5.38: not any more by default. Listing, sorting and reading the host's 600-odd objects on a client ended in
  -- the client losing its host 12 to 17 min into every mission; without them, two missions of 16 and 28 min clean
  -- (the 2026-10-29 bisection, docs/DEVLOG.md). Your own weapons, the ones from your hellpods too, are yours
  -- (owner = you) on 7.2.2. Testing: reads 1 brings the host's objects back for a mission.)
  local host = call('host', 'GameSession.game_session_host', s)
  session.host, session.peer = host, peer
  local hids = (host ~= nil and host ~= peer and N.read_level == 1) and call('owned_host', 'GameSession.objects_owned_by', s, host) or nil
  local now = {}
  -- (1.5.29) churn: objects that came or went since the last scan, for the vitals (a live mission always has some:
  -- none for seconds means the host's objects stopped reaching this client, the freeze the disconnect reports describe)
  local churn = 0
  session.mine, session.hosts = 0, 0
  for _, goid in pairs(ids) do
    now[goid] = true
    session.mine = session.mine + 1
    if objs[goid] == nil then objs[goid] = { seen_at = chef.time() }; queue[#queue + 1] = goid; churn = churn + 1 end
  end
  if type(hids) == 'table' then
    for _, goid in pairs(hids) do
      if not now[goid] then
        now[goid] = true
        session.hosts = session.hosts + 1
        if objs[goid] == nil then objs[goid] = { host = true, seen_at = chef.time() }; queue[#queue + 1] = goid; churn = churn + 1 end
      end
    end
  end
  for goid in pairs(objs) do if not now[goid] then objs[goid] = nil; N.checked[goid] = nil; churn = churn + 1 end end
  session.churn, session.scans = churn, session.scans + 1
  -- your player: the one you own. In someone else's game the host's objects are in the list too, the host's own
  -- player among them; taking that one showed the host's grenades and stims, flicking between theirs and yours (a
  -- 2026-10-25 log). One of the host's only when no player of yours is there and it's the only one.
  me.player = nil
  local host_player, host_players = nil, 0
  for goid, o in pairs(objs) do
    if o.t == 1 then
      if o.host then host_player, host_players = goid, host_players + 1 else me.player = goid end
    end
  end
  if me.player == nil and host_players == 1 then me.player = host_player end
  session.host_player = (host_players == 1 and me.player ~= host_player) and host_player or nil   -- (the vitals: the host's Helldiver)
  if me.player and alive(s, me.player, TYPES[1]) then
    local a = call('player.avatar', 'GameSession.game_object_field', s, me.player, DATA.player.avatar)
    me.avatar = (type(a) == 'number' and a ~= NO_OBJECT) and a or nil
  else
    me.avatar = nil
  end
  -- which weapons and backpacks are on you (types with a carry field: carried when it's a multiple of 4)
  for goid, o in pairs(objs) do
    local t = o.t and TYPES[o.t]
    if t and (t.pack or (not t.player and not t.avatar)) then
      if t.has.carry then
        local c = field(s, goid, t, 'carry')
        o.on = type(c) == 'number' and c % 4 == 0
        -- (onto your body during the mission: picked up from its hellpod or the ground. Until it fires, it's the one
        -- in your hand among the weapons held the same way, not one of them at random)
        if o.on and o.on_was == false and not t.pack and not o.host then
          -- (1.5.51: a type with no owner field isn't a hand weapon but can be a mounted gun's, the Grenadier
          -- Battlement's 17db8107: its pick-up time is kept too, the seat rule in 05_hand wants it)
          if HANDHELD[t.id] then o.chosen_at = chef.time() end
          o.picked_at = chef.time()
          if cfg.research then log('research: weapon %s (object %s) picked up%s', t.id, tostring(goid), HANDHELD[t.id] and '' or ' (not a hand weapon: a mounted gun?)') end
        end
        o.on_was = o.on
        -- A backpack's carry field (the 2026-10-25 log): 0 worn, 1 in its hellpod, 2 dropped. One that isn't yours
        -- (a mission objective's, a soldier's: as host you own those) can read 0 too. A called backpack can't be
        -- worn in a mission's first 10 s (the call-in alone takes 10 s, after landing), so one already at 0 then
        -- isn't yours, until it's seen at another value (dropped, then picked up) or proves yours. The same for the
        -- jump and warp packs (a jump pack of the map's showed a recharge bar with none on your back: the 1.2.7 log).
        if (t.pack or t.special) and type(c) == 'number' then
          if o.first_c == nil then
            o.first_c = c
            o.map_pack = c == 0 and blocked.since ~= nil and chef.time() - blocked.since < 10
            if o.map_pack and cfg.research then log('research: pack %s (object %s) there from the start: not yours until used', t.id, tostring(goid)) end
          elseif c ~= o.first_c then
            o.map_pack = false
          end
        end
        -- (research: a backpack's carry value and ammo as they change, to tell one on your back from one in its pod
        -- or on the ground)
        if cfg.research and t.pack and c ~= o.carry_said then
          o.carry_said = c
          log('research: backpack %s (object %s): carry=%s remaining=%s owner=%s', t.id, tostring(goid), tostring(c),
            tostring(t.has.remaining and field(s, goid, t, 'remaining')), tostring(t.has.owner and field(s, goid, t, 'owner')))
        end
      else
        o.on = true
      end
      if o.host then
        local ow = t.has.owner and as_peer(field(s, goid, t, 'owner'))
        o.on = o.on and ow ~= nil and ow == as_peer(peer)
      end
    end
  end
  -- underbarrels (the Stoker's flamethrower, the Arbitrator's shotgun): their own objects, on your body too, but shown
  -- only through their rifle (when its fire mode selects them), never picked or learned as a weapon of their own
  for _, o in pairs(objs) do o.ub = nil end
  for goid, o in pairs(objs) do
    local t = o.t and TYPES[o.t]
    if t and o.on and t.has.underbarrel and not t.pack then
      local ub = field(s, goid, t, 'underbarrel')
      local uo = type(ub) == 'number' and ub ~= NO_OBJECT and objs[ub]
      if uo then
        uo.ub = true
        local ut = uo.t and TYPES[uo.t]
        if ut and (learned.grip[ut.id] ~= nil or learned.poses[ut.id] ~= nil) then
          log('type %s is an underbarrel: its hand pose forgotten', ut.id)
          forget_poses(ut.id)
        end
      end
    end
  end
end


N.objs, N.queue, N.me, N.queue_2, N.queue_b, N.classify = objs, queue, me, queue_2, queue_b, classify
N.as_peer, N.session, N.scan = as_peer, session, scan
end)()

;(function() -- 05_hand
-- NarrowHUD, hand: the weapon in your hand: hand pose, the fire button and controllers, the Helldiver's fields, backpack ammo, swap keys, picking the weapon shown.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local TYPES, HANDHELD, AVATAR_RESOURCE, GRIP_VARIABLE, THROWABLE, call = N.TYPES, N.HANDHELD, N.AVATAR_RESOURCE, N.GRIP_VARIABLE, N.THROWABLE, N.call
local NOHAND = N.NOHAND
local blocked, alive, field, cfg, MOUSE_BUTTONS, learned, NO_OBJECT = N.blocked, N.alive, N.field, N.cfg, N.MOUSE_BUTTONS, N.learned, N.NO_OBJECT
local CHARGE_WEAPONS, learn, keys, distrust, has_pose, forget_poses = N.CHARGE_WEAPONS, N.learn, N.keys, N.distrust, N.has_pose, N.forget_poses
local objs, me, as_peer, session = N.objs, N.me, N.as_peer, N.session

------------------------------------------------------------------------------------------------ your hand pose
local watch = chef.watch and chef.watch({ [AVATAR_RESOURCE] = true }, 2) or nil
N.mates_watch = watch                          -- (the vitals: the teammates' positions)
local grip_index = setmetatable({}, { __mode = 'k' })
local function nearest_unit()
  if not watch or not watch.items or #watch.items == 0 then return nil end
  if #watch.items == 1 then return watch.items[1].unit end
  local cam = chef.camera()
  if not cam then return nil end
  local best, bd = nil, nil
  for _, it in ipairs(watch.items) do
    local dx, dy, dz = it.x - cam.x, it.y - cam.y, it.z - cam.z
    local d = dx * dx + dy * dy + dz * dz
    if bd == nil or d < bd then best, bd = it.unit, d end
  end
  return best
end
-- Your Helldiver: the Helldiver unit nearest the camera. (1.0.7 to 1.2.5 asked the session's unit synchronizer for
-- your avatar object's unit first: Helldivers 2 keeps none, it answered nil in every game, hosted or joined.)
local function my_unit(s) return chef.player_unit() end
N.my_unit = my_unit
-- Your fire button (the left mouse button), read every frame: as host you own every soldier's objects too (SEAF
-- troops' rifles ...), and their shots look like yours. A shot counts as yours only within 0.4 s of your fire button;
-- an object that fires three times without it is someone else's for the rest of the session. (0.3.5 tried the
-- weapons' position field instead: it isn't where a carried weapon is.)
-- A controller's right trigger counts too: R2 on a PlayStation pad.
--
-- The controllers: every pad the engine has (Pad1 to Pad8) that's active or connected, its buttons found by the names
-- the pad lists itself (num_buttons, button_name), so no button name a pad doesn't know is asked about. Looked for
-- every 2 s until one turns up, and again when one goes. A pad that doesn't list its buttons: the Xbox names on Pad1,
-- as before 1.0.2.
local PAD_FIRE = { 'right_trigger', 'r2', 'trigger_right', 'rt' }
local PAD_SWAP = { 'y', 'triangle' }
local PAD_STRAT = { 'left_shoulder', 'l1', 'lb' }      -- (1.2.4: the stratagem button, the game's default)
local PAD_AIM = { 'left_trigger', 'l2', 'lt' }         -- (1.4.6: aiming, the game's default)
local pads = { list = nil, look_at = -100, said = false }
local function pad_list(now)
  if pads.list and now < pads.look_at then return pads.list end
  pads.look_at = now + 2
  local list = {}
  for n = 1, 8 do
    local p = 'Pad' .. n
    if call('pad', p .. '.active') == true or call('pad', p .. '.connected') == true then
      local count, by = call('pad', p .. '.num_buttons'), {}
      if type(count) == 'number' and count > 0 and count <= 64 then
        for i = 0, count - 1 do
          local nm = call('pad', p .. '.button_name', i)
          if type(nm) == 'string' and nm ~= '' then by[nm:lower()] = i end
        end
      end
      local e = { name = p, listed = next(by) ~= nil }
      for _, c in ipairs(PAD_FIRE) do if by[c] then e.fire = by[c] break end end
      for _, c in ipairs(PAD_SWAP) do if by[c] then e.swap = by[c] break end end
      for _, c in ipairs(PAD_STRAT) do if by[c] then e.strat = by[c] break end end
      for _, c in ipairs(PAD_AIM) do if by[c] then e.aim = by[c] break end end
      if e.fire or e.swap then list[#list + 1] = e end
    end
  end
  if #list == 0 then
    -- (no pad listed its buttons: the Xbox names on the first one)
    local f, y = call('pad', 'Pad1.button_index', 'right_trigger'), call('pad', 'Pad1.button_index', 'y')
    local l1, l2 = call('pad', 'Pad1.button_index', 'left_shoulder'), call('pad', 'Pad1.button_index', 'left_trigger')
    if type(f) == 'number' or type(y) == 'number' then
      list[1] = { name = 'Pad1', fire = type(f) == 'number' and f or nil, swap = type(y) == 'number' and y or nil,
                  strat = type(l1) == 'number' and l1 or nil, aim = type(l2) == 'number' and l2 or nil }
    end
  end
  for _, e in ipairs(list) do e.button, e.pressed = e.name .. '.button', e.name .. '.pressed' end
  if #list > 0 and not pads.said then
    pads.said = true
    local d = {}
    for _, e in ipairs(list) do d[#d + 1] = string.format('%s (fire %s, swap %s%s)', e.name, tostring(e.fire), tostring(e.swap), e.listed and '' or ', not listed') end
    log('controller: %s', table.concat(d, '; '))
  end
  -- (still there: looked at again in 10 s, for one plugged in or swapped)
  if #list > 0 then pads.look_at = now + 10 end
  pads.list = list
  return list
end
local input = { ok = nil, last = -100, pad_said = false }
local function read_fire_button(now)
  if input.ok == false then return end
  local v = nil
  if cfg.fire == 6 then
    v = keys.fire and keys.fire.down and (keys.fire.down() == true and 1 or 0) or nil
  else
    local name = MOUSE_BUTTONS[cfg.fire] or 'left'
    if input.idx_name ~= name then
      input.idx_name, input.idx = name, call('mouse', 'Mouse.button_index', name)
      if type(input.idx) ~= 'number' then log('fire button: mouse button %s not known to the game', name) end
    end
    v = type(input.idx) == 'number' and call('mouse', 'Mouse.button', input.idx) or nil
  end
  local pv = nil
  for _, p in ipairs(pad_list(now)) do
    if p.fire then
      local x = call('pad', p.button, p.fire)
      if x == true then x = 1 end
      if type(x) == 'number' and (pv == nil or x > pv) then pv = x end
    end
  end
  if type(v) ~= 'number' and type(pv) ~= 'number' then
    if input.ok == nil then input.ok = false log('fire button: not readable (%s), shots aren\'t checked against it', tostring(v)) end
    return
  end
  if input.ok == nil then input.ok = true end
  if type(v) == 'number' and v > 0.5 then input.last, input.ever = now, true end
  -- (anything at all on the fire button or a trigger: a weapon's trigger field held with none of this isn't yours)
  if (type(v) == 'number' and v > 0) or (type(pv) == 'number' and pv > 0.02) then input.any_last = now end
  if type(pv) == 'number' and pv > 0.3 then
    input.last, input.ever = now, true
    if not input.pad_said then input.pad_said = true log('fire button: a controller\'s right trigger seen') end
  end
  -- (1.2.7: each press counted, for the heat of a laser that fires shots: the Talon's 15 a shot)
  local down = (type(v) == 'number' and v > 0.5) or (type(pv) == 'number' and pv > 0.3)
  if down and not input.down then input.presses = (input.presses or 0) + 1 end
  input.down = down
end
-- the aim button (the right mouse button, a controller's left trigger), for the drop line's "while aiming" (1.4.6:
-- the weapon stance field 95c46304 reads 4 only around a shot, not while you aim)
local function read_aim_button(now)
  if not input.aim_idx then input.aim_idx = call('mouse', 'Mouse.button_index', 'right') or false end
  local v = input.aim_idx and call('mouse', 'Mouse.button', input.aim_idx) or nil
  local aim = type(v) == 'number' and v > 0.5
  if not aim then
    for _, p in ipairs(pad_list(now)) do
      if p.aim then
        local x = call('pad', p.button, p.aim)
        if x == true or (type(x) == 'number' and x > 0.3) then aim = true break end
      end
    end
  end
  input.aiming = aim
end
N.read_aim_button = read_aim_button
-- (blind: your weapon in hand keeps firing and no fire input of any kind has been seen for a while: a controller
-- NarrowHUD can't read. Shots aren't checked from then on, as when nothing can be read)
local function pressed_recently(now) return input.ok ~= true or input.blind or now - input.last <= 0.4 end
-- (1.5.16 research: why the hand pose can't be read, once per world and step: a player with a transmog mod had no
-- hand pose in any mission with it on and every one without it; this says which step fails, and how many Helldiver
-- units the watch lists)
local pose_said = {}
local function pose_fail(why)
  if not cfg.research then return nil end
  local wid = chef.world_id and chef.world_id() or 0
  if pose_said[wid .. why] then return nil end
  pose_said[wid .. why] = true
  local n = watch and watch.items and #watch.items or 0
  log('research: hand pose not read: %s (%d Helldiver units listed%s)', why, n, n > 0 and string.format(', the nearest %s', tostring(watch.items[1].kind)) or '')
  return nil
end
local function hand_pose(s)
  local u = my_unit(s)
  if u == nil then return pose_fail('no Helldiver unit') end
  if chef.unit_alive(u) ~= true then return pose_fail('the Helldiver unit is not alive') end
  local idx = grip_index[u]
  if idx == nil then
    if call('asm', 'Unit.has_animation_state_machine', u) ~= true then return pose_fail('the unit has no animation state machine') end
    if call('hasvar', 'Unit.animation_has_variable', u, GRIP_VARIABLE) ~= true then return pose_fail('the unit has no hand pose variable') end
    idx = call('findvar', 'Unit.animation_find_variable', u, GRIP_VARIABLE)
    if type(idx) ~= 'number' then return pose_fail('the hand pose variable has no index') end
    grip_index[u] = idx
  end
  local v = call('getvar', 'Unit.animation_get_variable', u, idx)
  if type(v) ~= 'number' then return pose_fail('the hand pose variable reads ' .. type(v)) end
  return math.floor(v + 0.5)
end

------------------------------------------------------------------------------------------------ the weapon in hand
-- read a weapon's state; o.prev keeps the last one, to see it fire. lite: only what tells a shot, the trigger and a
-- reload (every weapon object but the one shown, ten times a second: as host, every SEAF soldier's gun too)
local ROLES_FULL = { 'rounds', 'magazines', 'slot0', 'slot1', 'selected', 'chamber', 'spare', 'heat',
                     'overheated', 'charging', 'reload_stage', 'fire_mode', 'rpm', 'options', 'held', 'guide' }
local ROLES_LITE = { 'rounds', 'slot0', 'slot1', 'chamber', 'heat', 'overheated', 'charging', 'held' }
N.reads = 0                                          -- (fields read, for the research log's timing line)
local function read_weapon(s, goid, t, lite)
  local w = { t = t, lite = lite or nil }
  if not alive(s, goid, t) then w.gone = true return w end
  for _, role in ipairs(lite and ROLES_LITE or ROLES_FULL) do
    if t.has[role] then w[role] = field(s, goid, t, role) N.reads = N.reads + 1 end
  end
  return w
end
-- the weapon can't fire now: overheated, or a charge weapon cooling from its shot (the Nova about 3 s, the Quasar 15):
-- your fire button held then isn't the shown one doing nothing
local function cooling_of(o, t)
  return o and o.prev and (o.prev.overheated == true or (t and CHARGE_WEAPONS[t.id] and type(o.prev.heat) == 'number'
    and o.prev.heat > (learned.rest2[t.id] or 0) + 5)) or false
end
N.cooling = cooling_of
-- (switching: the weapon's ammo, fire mode or options just changed. The Halt swaps its two slots' counts on a
-- mode switch (slot0 6>7, slot1 8>7 as it went to stun, back again on the way back: a player's 2026-10-28 log),
-- which read as a shot each time, and three "shots without your fire button" hid it for the session)
local function fired(prev, w, switching)
  if prev == nil then return false end
  local function down(k) return type(prev[k]) == 'number' and type(w[k]) == 'number' and w[k] < prev[k] end
  if down('rounds') then return true end
  if not switching and (down('slot0') or down('slot1')) then return true end
  if not switching and prev.chamber == false and w.chamber == true then return true end   -- the chambered one left (a single shell, a C4)
  if type(prev.heat) == 'number' and type(w.heat) == 'number' and w.heat > prev.heat + 0.5 then return true end
  if w.charging == true and prev.charging ~= true then return true end
  return false
end

-- your backpack's ammo (the first one on you that has it)
-- your backpack: as host you own the SEAF troops' backpacks too, so the one proven yours (it went down with your
-- reload or your fire), else the only one there is
-- The Helldiver (avatar) has six fields that hold another object's id (research log only). In the 2026-10-25 log none
-- held the backpack: cf55c86e holds your player, 20efbed4 what you're looking at or near (it flicks between nearby
-- objects), 913af9a2 and 0c09236b two objects not among yours, the other two nothing.
local AV_REFS = {}
for id, name in string.gmatch(DATA.avatar.refs or '', '(%x+):(%S+)') do AV_REFS[#AV_REFS + 1] = { id = id, name = name } end
-- (1.5.51) the seat field b2205a6e (#64, a 31-bit object reference, as DRIVER HUD reads it) isn't among the refs
-- (another kind) and the all-fields list leaves field 64 out: read by its name, research only
local SEAT_FIELD = 'b2205a6e'
do
  local name = string.match(DATA.fieldnames or '', SEAT_FIELD .. ' (%S+)')
  if name then AV_REFS[#AV_REFS + 1] = { id = SEAT_FIELD, name = name, research = true } end
end
local av_refs = {}                                   -- the fields' values, read with the grenades and stims
local av_said = {}                                   -- (research lines per field this world: at most 60)
local function read_av_refs(s)
  for _, r in ipairs(AV_REFS) do
    local v = (not r.research or cfg.research) and call('avatar.' .. r.id, 'GameSession.game_object_field', s, me.avatar, r.name) or nil
    if cfg.research and v ~= av_refs[r.id] and (av_said[r.id] or 0) < 60 then
      av_said[r.id] = (av_said[r.id] or 0) + 1
      local o = type(v) == 'number' and objs[v]
      log('research: avatar field %s holds %s (%s)', r.id, tostring(v),
        o and o.t and (TYPES[o.t].id .. (TYPES[o.t].pack and ', a backpack' or '') .. (o.on and ', on you' or '')) or 'nothing of yours')
    end
    av_refs[r.id] = v
  end
end
local function pack_ammo(s)
  local only, n, mine = nil, 0, nil
  local me_peer = as_peer(session.peer)
  for pgoid, o in pairs(objs) do
    local pt = o.t and TYPES[o.t]
    -- (a pack's owner field, where it can be read, must be you: other players' and soldiers' packs aren't)
    local ow = pt and pt.pack and o.on and pt.has.owner and me_peer and as_peer(field(s, pgoid, pt, 'owner'))
    -- (and not one worn by something since the mission started, unless it proved yours or you've moved it)
    if pt and pt.pack and o.on and pt.has.remaining and (ow == nil or ow == me_peer)
       and not (o.map_pack and not o.mine) then
      if o.mine then mine = pgoid end
      only, n = pgoid, n + 1
    end
  end
  local pgoid = mine or (n == 1 and only) or nil
  -- (gone in the meantime: an owner read found it gone and forgot it)
  if not pgoid or not objs[pgoid] or not objs[pgoid].t then return nil end
  local pt = TYPES[objs[pgoid].t]
  local r = field(s, pgoid, pt, 'remaining')
  if type(r) == 'number' then return r, pgoid end
  return nil
end
-- every pack's ammo, to tell which one went down
local function packs_now(s)
  local l = {}
  for pgoid, o in pairs(objs) do
    local pt = o.t and TYPES[o.t]
    if pt and pt.pack and o.on and pt.has.remaining then l[pgoid] = field(s, pgoid, pt, 'remaining') end   -- (all, to watch)
  end
  return l
end

local hand = { goid = nil, grip = nil, said = nil }
-- With a shield the hand pose is the shield's (30, 36) whichever one-handed weapon is out, so the pose can't tell two of
-- them apart. The swap keys can: 1, 2 and 3 (the game's default binds for primary, secondary and support) and the
-- mouse wheel. Which key a weapon is on is learned when the key brings it out where the pose does tell (learned.slot).
local SWAP_KEYS = { '1', '2', '3' }
local swap = { key = nil, at = -100, used = true, from = nil }
local function read_swap(now)
  local key = nil
  if keys.swap then
    for i, b in ipairs(keys.swap) do
      if type(b) == 'table' and b.pressed and b.pressed() == true then key = i end
      local name = type(b) == 'table' and b.key and b.key()
      if type(name) == 'string' then SWAP_KEYS[i] = name end
    end
  elseif chef.key_pressed then
    for i, k in ipairs(SWAP_KEYS) do if chef.key_pressed(k) == true then key = i end end
  end
  -- (the weapon options held, or let go a moment ago: the wheel is the scope's zoom or the light, not a swap)
  local menu = keys.weapon_menu
  if menu and menu.down and menu.down() == true then swap.menu_at = now end
  if key == nil and chef.wheel and now - (swap.menu_at or -100) > 0.2 then
    local w = chef.wheel()
    -- (up: a positive wheel value)
    local m = cfg.wheel or 1
    if type(w) == 'number' and w ~= 0 and (m == 1 or (m == 2 and w > 0) or (m == 3 and w < 0)) then key = 'wheel' end
  end
  -- a controller's weapon swap (Y, triangle on a PlayStation pad: the game's default): the other weapon, like the wheel
  if key == nil then
    for _, p in ipairs(pad_list(now)) do
      if p.swap and call('pad', p.pressed, p.swap) == true then key = 'wheel' end
    end
  end
  if key ~= nil then swap.prev_at, swap.key, swap.at, swap.used, swap.from = swap.at, key, now, false, hand.goid end
end
-- (research: the HUD going from one object to another on the same hand pose: both, to see how a soldier's gun gets in)
local switch_said = 0
local function research_switch(s, from, to, grip, now)
  if switch_said >= 200 then return end
  switch_said = switch_said + 1
  local function about(goid)
    local o = objs[goid]
    local t = o and o.t and TYPES[o.t]
    if not t then return tostring(goid) .. ' (gone)' end
    local refs = {}
    for id, v in pairs(av_refs) do if v == goid then refs[#refs + 1] = id end end
    return string.format('%s (object %s, first seen %s s in%s): carry=%s owner=%s held=%s, %d / %d shots with / without your fire button, fired %.1f s ago, avatar fields: %s',
      t.id, tostring(goid), o.seen_at and blocked.since and string.format('%.0f', o.seen_at - blocked.since) or '?', o.host and ', the host\'s' or '',
      tostring(t.has.carry and field(s, goid, t, 'carry')), tostring(t.has.owner and field(s, goid, t, 'owner')),
      tostring(t.has.held and field(s, goid, t, 'held')), o.pressed or 0, o.unpressed or 0, now - (o.fired_at or 0),
      #refs > 0 and table.concat(refs, ',') or 'none')
  end
  log('research: hand pose %d switched from %s to %s (fire button %.1f s ago, swap %.1f s ago)', grip, about(from), about(to),
    now - (input.last or -100), now - (swap.at or -100))
end
local HOLD_FIRST = { ['26acc614'] = true, ['314a1bf5'] = true }   -- (the Railgun, the Epoch: charged first)
N.HOLD_FIRST = HOLD_FIRST
-- (1.5.18) a support weapon lying on the ground keeps a link to its pickup there (the floor field, a goid; none
-- while it's in a hand: every held one in 22 logs, every one on the ground with a goid). One of yours from an
-- earlier life, far away, was shown at drop-in as the weapon in hand for its learned pose until the first shot.
local floor_said = {}
local function on_floor(s, goid, t)
  if not t.has.floor or not N.REF_READS then return false end
  local v = field(s, goid, t, 'floor')
  local yes = type(v) == 'number' and v ~= NO_OBJECT
  if yes and cfg.research and not floor_said[goid] then floor_said[goid] = true log('research: weapon %s (object %s) lies on the ground (pickup %s): not in your hand', t.id, tostring(goid), tostring(v)) end
  return yes
end
-- (1.5.51) A mounted gun: an emplacement's gun is a weapon object that goes onto your body as you sit (its carry
-- field, as a pick-up) while the hand pose reads 0 (the HMG and AT emplacements) or 51 (the Grenadier Battlement,
-- the FRV's turret), luka's 2026-10-30 logs. Your Helldiver's 20efbed4 ("what you're at") holds the emplacement
-- while you sit — the HMG's seat object, the gun 3-5 ids on; the AT's gun itself once, none the next time; the
-- Grenadier's seat, its gun the id before — so it helps but isn't relied on. Shown while seated: a weapon of yours
-- with rounds that is the object 20efbed4 holds, or went onto your body within 5 s of the pose or the field
-- (nearest to the field's object by id when there is one), or is of a type with no owner field (not a hand weapon:
-- the Grenadier's 17db8107, which isn't "picked up" the hand weapons' way but is on you while you sit). The FRV's
-- turret gun 0df6deff fires on your fire button and gets learned as pose 51's weapon on its own. The tank and the
-- exosuit show their own ammo in the game: no reading of those.
local SEAT_POSES = { [0] = true, [51] = true }
local seat = { goid = nil, since = nil, gun = nil, pose_since = nil }
N.seat = seat
local function seat_gun(s, grip, now)
  if not SEAT_POSES[grip] then
    seat.goid, seat.gun, seat.pose_since = nil, nil, nil
    return nil
  end
  seat.pose_since = seat.pose_since or now
  local ref = av_refs['20efbed4']
  if type(ref) ~= 'number' or ref == 32767 then ref = nil end
  if ref and seat.goid ~= ref then
    seat.goid, seat.since = ref, now
    if cfg.research then
      local near = {}
      for goid, o in pairs(objs) do
        if type(goid) == 'number' and math.abs(goid - ref) <= 12 then
          local t = o.t and TYPES[o.t]
          near[#near + 1] = string.format('%d %s%s%s%s', goid, t and t.id or 'unknown type', o.on and ', on you' or '',
            o.picked_at and string.format(', picked up %.1f s ago', now - o.picked_at) or '', o.notmine and ', not yours' or '')
        end
      end
      table.sort(near)
      log('research: seat: hand pose %d, your Helldiver\'s 20efbed4 holds %d; objects near it by id: %s', grip, ref, #near > 0 and table.concat(near, '; ') or 'none')
    end
  end
  -- (1.5.56: judged every frame while seated, so the gun picked up half a second after the pose turned 0 takes
  -- over from a guess (luka's log: the AT's gun came 0.6 s after the pose, the HMG's 0.6 s after the field). The
  -- fallback for a type with no owner field needs a carry field (a real pick-up signal): a type with neither reads
  -- as "on you" always, and two such objects were shown as mounted guns during dives)
  local start = math.max(seat.pose_since, ref and seat.since or 0)
  local best, bd, how = nil, 1e9, nil
  for goid, o in pairs(objs) do
    local t = o.t and TYPES[o.t]
    if t and o.on and t.has.rounds and not t.pack and not t.player and not t.avatar and not t.other and not NOHAND[t.id]
       and not o.host and type(goid) == 'number' then
      local d = ref and math.abs(goid - ref) or 50
      local why = nil
      if ref and goid == ref then why, d = 'the object you\'re at', 0
      elseif o.picked_at and math.abs(o.picked_at - start) <= 5 then why = 'onto you as you sat'   -- (1.5.58: any id: the field held the next emplacement's object once while luka sat the AT)
      elseif not HANDHELD[t.id] and t.has.carry and grip == 51 then why = 'not a hand weapon' d = d + 200 end   -- (1.5.57: the Grenadier's pose only: its gun stays "on you" after you leave, and showed at every dive's pose 0)
      if why and d < bd then best, bd, how = goid, d, why end
    end
  end
  local g = seat.gun and objs[seat.gun]
  if best == nil and g and g.on then return seat.gun end
  if best and best ~= seat.gun then
    seat.gun = best
    log('mounted gun: %s (object %d, %s%s)', TYPES[objs[best].t].id, best, how, ref and string.format(', %d ids from %d', math.abs(best - ref), ref) or '')
  end
  return seat.gun
end
N.seat_gun = seat_gun
local function pick(s, grip, now)
  now = now or chef.time()
  if grip == nil or THROWABLE[grip] then return nil end   -- grenades and stratagems: no weapon
  local mounted = seat_gun(s, grip, now)
  if mounted then return mounted end
  if grip == 0 then return nil end
  local same, unknown, last = {}, {}, nil
  for goid, o in pairs(objs) do
    local t = o.t and TYPES[o.t]
    if t and HANDHELD[t.id] and not t.pack and not t.player and not t.avatar and not t.other and o.on and not o.ub
       and not o.notmine and not on_floor(s, goid, t) then
      if has_pose(t.id, grip) then same[#same + 1] = goid
      elseif learned.grip[t.id] == nil and learned.poses[t.id] == nil then unknown[#unknown + 1] = goid end
    end
  end
  -- the one fired or swapped to last; none yet (a mission's start): the lowest swap key, the primary first
  local function newest(list)
    local best, bt, bk = list[1], -1, 99
    for _, goid in ipairs(list) do
      local f = math.max(objs[goid].fired_at or 0, objs[goid].chosen_at or 0)
      local key = learned.slot[TYPES[objs[goid].t].id] or 9
      if f > bt or (f == bt and key < bk) then best, bt, bk = goid, f, key end
    end
    return best
  end
  if #same > 1 then
    -- a weapon fed from the backpack sharing a pose with a weapon of its own ammo: the fed one was learned wrongly
    -- (a backpack reload taken for its shot); its pose is forgotten
    local own = {}
    for _, goid in ipairs(same) do
      local t = TYPES[objs[goid].t]
      if not t.fed then own[#own + 1] = goid end
    end
    if #own > 0 and #own < #same then
      for _, goid in ipairs(same) do
        local t = TYPES[objs[goid].t]
        if t.fed then
          local key = t.id .. ':' .. grip
          if not N.pose_shared[key] then
            log('type %s: its hand pose %d forgotten (shared with a weapon of its own; not learned again this session)', t.id, grip)
          end
          N.pose_shared[key] = true
          forget_poses(t.id)
        end
      end
      same = own
    end
  end
  local alone = #same == 1                    -- (the pose is one weapon's: a key that brings it out can be learned)
  if #same > 1 then
    -- of a type someone else's has fired this session (a soldier's), only the one proven yours; the rest stay (two
    -- of your weapons on one pose: 0.4.13 kept only the one fired more, so swapping between them changed nothing)
    local keep = {}
    for _, goid in ipairs(same) do
      local o = objs[goid]
      if o.mine or not distrust[TYPES[o.t].id] then keep[#keep + 1] = goid end
    end
    if #keep > 0 then same = keep end
  end
  local recent = not swap.used and now - swap.at < 3
  if #same == 1 and alone and recent and type(swap.key) == 'number' and same[1] ~= swap.from then
    -- the key brought out a weapon the pose tells apart: that weapon is on that key
    -- (not after two keys in quick succession: the weapon may be the first key's; a weapon already on another key
    -- moves only when seen twice on the new one)
    local id = TYPES[objs[same[1]].t].id
    local k = learned.slot[id]
    if k ~= nil and k ~= swap.key then
      -- another key brought this weapon's pose up: something with the same pose NarrowHUD doesn't know is in hand
      -- (the Solo Silo's remote: held like a pistol, on key 3, the Warrant's pose). It isn't shown until the pose
      -- changes or it fires (then it is on that key after all)
      hand.mask = { goid = same[1], grip = grip, at = now, key = swap.key }
      if cfg.research then log('research: key %s brought up hand pose %d, %s\'s (on key %s): something else in hand', SWAP_KEYS[swap.key], grip, id, SWAP_KEYS[k]) end
    elseif k == nil and swap.at - (swap.prev_at or -100) >= 1.5 then
      log('learned: type %s is on swap key %s', id, SWAP_KEYS[swap.key])
      learn('slot', id, swap.key)
      objs[same[1]].taught_slot = swap.key
    end
    swap.used = true
  elseif #same > 1 and recent and now - swap.at >= 0.5 then
    -- several of your weapons share this pose (a shield's): the swap key or the wheel says which came out. Only half
    -- a second after the key: the hand pose changes about 0.4 s after a key, so a key bringing out a weapon on another
    -- pose found the old pose still up and chose a weapon on it (key 3 showed a Stalwart lying on the map, on the
    -- Sightliner's pose, for 0.4 s on the way to the AMR: a 2026-10-26 log)
    local cur = hand.goid
    local chosen = nil
    if type(swap.key) == 'number' then
      for _, goid in ipairs(same) do
        if learned.slot[TYPES[objs[goid].t].id] == swap.key then chosen = goid end
      end
      if chosen == nil and #same == 2 then
        -- not learned yet: the one not in hand, unless that one is known to be on another key
        for _, goid in ipairs(same) do
          local k = learned.slot[TYPES[objs[goid].t].id]
          if goid ~= cur and (k == nil or k == swap.key) then chosen = goid end
        end
      end
    elseif #same == 2 then
      for _, goid in ipairs(same) do if goid ~= cur then chosen = goid end end
    end
    if chosen then
      objs[chosen].chosen_at = now
      swap.chosen, swap.chosen_at = chosen, now
      if cfg.research then
        log('research: swap %s at hand pose %d (%d weapons share it): %s', type(swap.key) == 'number' and ('key ' .. SWAP_KEYS[swap.key]) or 'wheel',
          grip, #same, TYPES[objs[chosen].t].id)
      end
    end
    swap.used = true
  end
  -- (a weapon masked by a key not its: hidden while its pose stays up and it hasn't fired since)
  local m = hand.mask
  if m then
    local mo = objs[m.goid]
    -- (gone with the pose, a shot from it, or its own key pressed since)
    local own_key = mo and mo.t and swap.at > m.at and learned.slot[TYPES[mo.t].id] == swap.key
    if grip ~= m.grip or not mo or (mo.fired_at or 0) > m.at or own_key then
      hand.mask = nil
    else
      for i = #same, 1, -1 do if same[i] == m.goid then table.remove(same, i) end end
    end
  end
  -- Sticky: while you fire, the weapon in your hand fires (or its trigger reads held). Another object on the same pose
  -- (as host: a SEAF soldier's gun of the same kind, firing as you fire) takes the HUD over only when the pose
  -- changed, a swap key or the wheel was used, the shown one is gone, or it showed nothing for half a second of
  -- your firing (a swap or pick-up NarrowHUD didn't see). Not while your fire button can't be read.
  local cur = hand.goid
  local co = cur and objs[cur]
  local dtp = math.min(0.5, math.max(0, now - (hand.pick_t or now)))
  hand.pick_t = now
  if cur ~= hand.unlock_goid then hand.unlock, hand.unlock_goid = 0, cur end
  -- (the shown one active: fired in the last 0.4 s, reloading, or for a weapon that's held before it fires (a charge,
  -- a lock-on, the Arc Thrower) its trigger held)
  local ct = co and co.t and TYPES[co.t]
  local holds = ct and (HOLD_FIRST[ct.id] or CHARGE_WEAPONS[ct.id] or ct.has.charging or ct.has.lock or ct.has.heat)
  local cooling = cooling_of(co, ct)
  local active = co and ((co.fired_at and now - co.fired_at <= 0.4) or (holds and co.held_t and now - co.held_t <= 0.4)
    or (holds and co.charging_t and now - co.charging_t <= 0.6)
    or (co.prev and (tonumber(co.prev.reload_stage) or 0) ~= 0) or cooling)
  if co and input.ok == true and not input.blind and now - input.last <= 0.15 then
    hand.unlock = active and 0 or (hand.unlock or 0) + dtp
  end
  if #same > 0 then
    local best = newest(same)
    -- (or the other one fired twice with your fire button while the shown one did nothing)
    local bo = best ~= cur and objs[best]
    if bo and bo.fired_at and bo.fired_at ~= hand.ch_at then
      hand.ch_at = bo.fired_at
      if hand.ch_goid ~= best then hand.ch_goid, hand.ch_n = best, 0 end
      if active or now - input.last > 0.5 then hand.ch_n = 0 else hand.ch_n = (hand.ch_n or 0) + 1 end
    end
    local proven = hand.ch_goid == best and (hand.ch_n or 0) >= 2
    -- (not for a shown type with no ammo of its own or fed from the backpack: those ride along with other weapons)
    if best ~= cur and co and ct and not ct.noammo and not ct.fed and grip == hand.grip and now - (swap.at or -100) >= 3
       and input.ok == true and not input.blind
       and (hand.unlock or 0) < 0.5 and not proven then
      for _, g in ipairs(same) do
        if g == cur then
          if cfg.research and hand.kept_from ~= best and (hand.kept_n or 0) < 100 then
            hand.kept_from, hand.kept_n = best, (hand.kept_n or 0) + 1
            local bo = objs[best]
            log('research: kept the weapon in hand %s (object %s) over %s (object %s, fired %.1f s ago, %d / %d shots with / without your fire button, first seen %s s into the mission): yours is firing',
              TYPES[co.t].id, tostring(cur), TYPES[bo.t].id, tostring(best), now - (bo.fired_at or 0), bo.pressed or 0, bo.unpressed or 0,
              bo.seen_at and blocked.since and string.format('%.0f', bo.seen_at - blocked.since) or '?')
          end
          return cur
        end
      end
    end
    return best
  end
  return nil   -- not learned yet: shown from its first shot
end

-- every on-body weapon, often: a weapon whose ammo or heat moves while a pose is up is the one in hand
-- Heat rates (per second, in the heat field's units, the game's degrees) of weapons that heat while firing, from the
-- Helldivers 2 wiki (helldivers.wiki.gg: LAS-5 Scythe, LAS-98 Laser Cannon; standard heatsink, neutral planet).
-- Others are learned from the field (which changes only every few seconds, so learned rates are rougher).

N.input, N.read_fire_button, N.pressed_recently, N.hand_pose, N.read_weapon, N.fired = input, read_fire_button, pressed_recently, hand_pose, read_weapon, fired
N.av_refs, N.av_said, N.read_av_refs, N.pack_ammo, N.packs_now, N.hand = av_refs, av_said, read_av_refs, pack_ammo, packs_now, hand
N.SWAP_KEYS, N.swap, N.read_swap, N.research_switch, N.pick = SWAP_KEYS, swap, read_swap, research_switch, pick
N.pad_list = pad_list
end)()

;(function() -- 06_learning
-- NarrowHUD, learning: watching every weapon: shots, heat (the model and the planet), reloads, learning poses and keys, the SEAF guards.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local TYPES, HANDHELD, THROWABLE, cfg, learned, CHARGE_WEAPONS = N.TYPES, N.HANDHELD, N.THROWABLE, N.cfg, N.learned, N.CHARGE_WEAPONS
local call = N.call
local learn, distrust, many_poses, has_pose, add_pose, objs = N.learn, N.distrust, N.many_poses, N.has_pose, N.add_pose, N.objs
local input, pressed_recently, read_weapon, fired, pack_ammo, packs_now = N.input, N.pressed_recently, N.read_weapon, N.fired, N.pack_ammo, N.packs_now
local hand, SWAP_KEYS, swap = N.hand, N.SWAP_KEYS, N.swap

-- (the Talon: 15 heat a shot, semi-automatic; cools 10 a second, 15 on Extreme Cold, 7.5 on Intense Heat)
local WIKI_HEAT = {
  ['4e87d68d'] = { down = 10, shot = 15 },   -- LAS-58 Talon
  ['42a6b5ba'] = { up = 12.5, down = 8.5 },   -- LAS-5 Scythe
  d100e0c8 = { up = 8, down = 5 },            -- LAS-98 Laser Cannon
}
-- The planet changes how fast heat weapons cool (the wiki: Extreme Cold about x1.5, Intense Heat about x0.75). It isn't
-- read anywhere known, so it's measured: while cooling, the field's fall over the model's neutral rate, per world
-- (a mission), from the weapons with a wiki rate, the middle of the last five, snapped to 0.75 / 1 / 1.5 when within 12 %.
local planet = { wid = nil, factor = 1, samples = {} }
local function planet_factor()
  local wid = chef.world_id and chef.world_id()
  if wid ~= planet.wid then planet.wid, planet.factor, planet.samples = wid, 1, {} end
  return planet.factor
end
local function planet_sample(ratio)
  planet_factor()
  local l = planet.samples
  l[#l + 1] = ratio
  if #l > 5 then table.remove(l, 1) end
  if #l < 2 then return end
  local sorted = {}
  for i = 1, #l do sorted[i] = l[i] end
  table.sort(sorted)
  local f = sorted[math.floor((#sorted + 1) / 2)]
  for _, snap in ipairs({ 0.75, 1, 1.5 }) do
    if math.abs(f / snap - 1) < 0.12 then f = snap break end
  end
  f = math.floor(f * 100 + 0.5) / 100
  if f ~= planet.factor then
    log('planet cooling x%.2f%s', f, f == 1.5 and ' (cold)' or (f == 0.75 and ' (hot)' or (f == 1 and '' or ' (measured)')))
    planet.factor = f
  end
end
-- neutral rates: the wiki's, else learned (learned cooling is kept neutral: divided by the planet factor)
local function base_rate(kind, id)
  local w = WIKI_HEAT[id]
  return (w and w[kind]) or learned[kind][id]
end
local function heat_rate(kind, id)
  local r = base_rate(kind, id)
  if r and kind == 'down' then r = r * planet_factor() end
  return r
end
-- the trigger held, for heat: a charge weapon's "charging"; else the trigger-held field (else "charging")
local function firing_of(t, w)
  if learned.charge2[t.id] == nil and t.has.held then return w.held == true end
  return w.charging == true
end

local function loaded(w)
  local n = tonumber(w.rounds) or tonumber(w.slot0) or 0
  if w.slot1 then n = n + (tonumber(w.slot1) or 0) end
  if w.chamber == false then n = n + 1 end
  return n
end

N.pack_prev, N.pack_vals = nil, {}
local recent = { reload_t = -100, reload_t_type = nil, pack_drop_t = -100 }
local pending_learn = {}
local busy_said = 0
local watch_n = 0
-- an object proven someone else's (as host: a SEAF soldier's gun): never shown or learned from again this mission, its
-- type distrusted (another of its kind must prove itself yours), and what it taught this mission taken back
local function not_yours(goid, o, t, why)
  if o.notmine then return end
  o.notmine = true
  distrust[t.id] = true
  if cfg.research then log('research: an object of type %s %s: not yours', t.id, why) end
  for _, g in ipairs(o.taught or {}) do
    if has_pose(t.id, g) then
      log('type %s: hand pose %d forgotten (learned from a gun that isn\'t yours)', t.id, g)
      N.remove_pose(t.id, g)
    end
  end
  if o.taught_slot and learned.slot[t.id] == o.taught_slot then
    log('type %s: swap key %s forgotten (learned from a gun that isn\'t yours)', t.id, SWAP_KEYS[o.taught_slot])
    learn('slot', t.id, nil)
  end
  if hand.goid == goid then hand.goid = nil end
end
N.not_yours = not_yours
-- (1.2.5) A weapon that aims by itself isn't in your hands. Weapon types carry a field 6f3ab277 (-0.5 to 1.58, an
-- angle in radians: the aim's pitch) that reads 0 on every weapon a Helldiver holds (your own, across ten logged
-- missions: the avatar carries the player's aim) and moves on a SEAF soldier's rifle, a turret's gun, a Guard Dog's
-- or a tank's while it aims (the 2026-10-27 logs: 1,955 changes on soldiers' rifles, none on a weapon of yours). An
-- object read off 0 twice is someone else's for the rest of the session. Read with the others, once a type's field
-- list says it has the field.
local AIM_FIELD = '6f3ab277'
local aim_name = nil
for id, name in string.gmatch(DATA.fieldnames or '', '(%x+) (%S+)') do if id == AIM_FIELD then aim_name = name end end
local aim_types = {}                                  -- type id -> true / false: declares the aim field
local function has_aim(t)
  local v = aim_types[t.id]
  if v == nil then
    v = false
    if aim_name then
      for line in string.gmatch(DATA.fields or '', '[^\n]+') do
        if string.sub(line, 1, 8) == t.id then v = string.find(line, AIM_FIELD, 9, true) ~= nil break end
      end
      if v and t.live and not t.live[AIM_FIELD] then v = false end
    end
    aim_types[t.id] = v
  end
  return v
end
local function watch_fire(s, grip)
  -- last read's learning (see below): dropped for an object that fired while the weapon shown in hand did too
  if #pending_learn > 0 then
    local so = hand.goid and objs[hand.goid]
    local st = so and so.t and TYPES[so.t]
    for _, e in ipairs(pending_learn) do
      -- (the shown one busy: it fired, or it's one held before it fires (a charge, a lock-on: the Nova, in that log) and its
      -- trigger was held or it was charging at the time)
      -- (heat weapons too: the heat field moves only now and then (the Laser Cannon about every 3 s). Or it can't fire:
      -- overheated, or a charge weapon cooling from its shot: a SEAF gun firing as you held fire then was learned
      -- (as host, a 2026-10-26 log: the Scythe overheated, the Nova cooling), the same as the pick's check)
      local holds = st and (N.HOLD_FIRST[st.id] or CHARGE_WEAPONS[st.id] or st.has.charging or st.has.lock or st.has.heat)
      local active = so and ((so.fired_at and math.abs(so.fired_at - e.at) <= 0.4)
        or (holds and ((so.held_t and math.abs(so.held_t - e.at) <= 0.4) or (so.prev and so.prev.charging == true)
          or (so.charging_t and math.abs(so.charging_t - e.at) <= 0.6)))
        or N.cooling(so, st))
      local busy = st and hand.goid ~= e.goid and active and has_pose(st.id, e.grip) and objs[e.goid] ~= nil
      if busy then
        if cfg.research and busy_said < 200 then
          busy_said = busy_said + 1
          log('research: not learned from %s (object %s) at hand pose %d: it fired as the weapon in hand (%s) did', e.t.id, tostring(e.goid), e.grip, st.id)
        end
      elseif objs[e.goid] then
        e.fn()
      end
    end
    pending_learn = {}
  end
  local any_fired = false
  local reloaded = {}
  N.watched = 0
  watch_n = watch_n + 1
  for goid, o in pairs(objs) do
    local t = o.t and TYPES[o.t]
    -- (one proven someone else's isn't read again: as host, a SEAF squad's guns were most of the reads; the others
    -- but the one shown every other read, half each time: a shot still shows, as its ammo or heat moved since)
    if t and not t.pack and not t.player and not t.avatar and not t.other and o.on and not o.notmine
       and (goid == hand.goid or (goid + watch_n) % 2 == 0) then
      local w = read_weapon(s, goid, t, goid ~= hand.goid)
      if w.gone then break end                 -- forgotten (gone): the rest wait for the next read
      N.watched = N.watched + 1
      local now = chef.time()
      -- (1.2.4: the last read charging: the Nova's charge, also one let go before it fired, and the Scythe's beam,
      -- which reads charging while it fires: rapid clicks with it showed no shots between the heat field's updates)
      if w.charging == true then o.charging_t = now end
      -- its trigger held with nothing on your fire button or trigger for over half a second, three reads: someone
      -- else's (a SEAF soldier's gun of a kind you carry, held=true while you weren't firing, in a 2026-10-26 log).
      -- Only once a press has been seen (a controller NarrowHUD can't read never shows one), and never for one that
      -- fired with your fire button 10 times and never without it.
      -- (1.2.3: held without a break, 0.8 s at least: the count added up separate moments before, and the Halt reads
      -- held for a moment as its ammo is switched with the quick weapon wheel: three switches hid it for the rest of
      -- the mission, a player's report. Nor while its fire mode, ammo or options just changed, or it's reloading)
      local proven = (o.unpressed or 0) == 0 and (o.pressed or 0) >= 10
      local pw = o.prev
      if pw and not w.lite and not pw.lite and (w.selected ~= pw.selected or w.fire_mode ~= pw.fire_mode or w.options ~= pw.options) then
        o.mode_t = now
      end
      -- (1.5.47) a scope with zeroing: its step is the options field's bits 16 and 32 (luka's 2026-10-30 marks on the
      -- R-40 and the AMW-20: 80 > 96 > 64 > 80, nothing else on the weapon moving); learned for the type the first
      -- time those two bits change on their own (the named options use bits 4 and 8, the C4's 256)
      if pw and not w.lite and not pw.lite and type(w.options) == 'number' and type(pw.options) == 'number' and w.options ~= pw.options
         and w.fire_mode == pw.fire_mode and w.selected == pw.selected and not learned.zoom[t.id]
         and math.floor(w.options / 16) % 4 ~= math.floor(pw.options / 16) % 4
         and (w.options - math.floor(w.options / 16) % 4 * 16) == (pw.options - math.floor(pw.options / 16) % 4 * 16) then
        log('learned: type %s has a scope with zeroing (its options %d > %d: the zoom step %d > %d)', t.id, pw.options, w.options,
          math.floor(pw.options / 16) % 4, math.floor(w.options / 16) % 4)
        learn('zoom', t.id, true)
      end
      local switching = (o.mode_t and now - o.mode_t < 1.5) or ((tonumber(w.reload_stage) or 0) ~= 0)
      if w.held == true and input.ok == true and input.ever and not input.blind and not proven and not switching
         and now - (input.any_last or -100) > 0.6 then
        o.held_since = o.held_since or now
        o.held_alone = (o.held_alone or 0) + 1
        if o.held_alone >= 3 and now - o.held_since >= 0.8 then not_yours(goid, o, t, 'holds its trigger without your fire button') end
      else
        o.held_alone, o.held_since = 0, nil
      end
      -- (aims by itself: someone else's, see AIM_FIELD above. The field must move: a support weapon out of its
      -- hellpod kept a stray 0.012 in it as you held it (the 1.2.7 log: a weapon of yours hidden for it), while a
      -- soldier's rifle or a turret's gun changes its aim every read or two)
      if has_aim(t) and not o.notmine then
        local a = tonumber((call(t.id .. '.aim', 'GameSession.game_object_field', s, goid, aim_name)))
        if a and a ~= 0 then
          if o.aim_last ~= nil and o.aim_last ~= 0 and a ~= o.aim_last then o.aim_n = (o.aim_n or 0) + 1 end
          o.aim_last = a
          if (o.aim_n or 0) >= 2 then
            local shipped = SEED and ((SEED.poses and SEED.poses[t.id]) or (SEED.grip and SEED.grip[t.id]))
            not_yours(goid, o, t, string.format('aims by itself (its aim field reads %.3f: a soldier\'s, a turret\'s)%s', a,
              shipped and '; A TYPE PLAYERS CARRY: if this was your own weapon, report it' or ''))
            -- (a pose or key the type taught, from any object of it, when none of its objects is proven yours: a
            -- soldier's gun's, most likely; your own of that type teaches it again on its first shot)
            local mine = false
            for g2, o2 in pairs(objs) do if o2.t == o.t and o2.mine then mine = true end end
            if not mine then
              local had = learned.poses[t.id] or learned.grip[t.id] or learned.slot[t.id]
              if had and not (SEED and ((SEED.poses and SEED.poses[t.id]) or (SEED.grip and SEED.grip[t.id]))) then
                log('type %s: what was learned of its hand poses and key forgotten (its objects aim by themselves)', t.id)
                N.forget_poses(t.id)
                learn('slot', t.id, nil)
              end
            end
          end
        else
          o.aim_n, o.aim_last = 0, a
        end
      end
      -- Heat: the field changes only now and then (the Quasar a few times a second, the Laser Cannon about every 3 s).
      -- The rates it rises at while the trigger is held ("charging") and falls at otherwise are learned per type, so
      -- the bar can run on between changes. A segment starts at the last change or at the trigger's last press or
      -- release, whichever came later.
      if type(w.heat) == 'number' then
        local firing = firing_of(t, w)
        if firing ~= o.firing then o.firing, o.state_t = firing, now end
        if w.heat ~= o.h_last then
          if o.h_last then
            local from = math.max(o.h_last_t or 0, o.state_t or 0)
            local r = (w.heat - o.h_last) / math.max(0.05, now - from)
            local up = w.heat > o.h_last
            if math.abs(r) < 200 and now - from > 0.15 then
              local kind = (up and firing) and 'up' or ((not up and not firing) and 'down' or nil)
              -- (a laser that fires shots: a shot can hide inside the field's dead band (the Talon's 12 in a band
              -- of 15.6), so only an interval with no press of your fire button in it is cooling alone; the 1.2.7 log
              -- measured the planet at x0.52 from one with shots in it, and the bar ran 20 ahead)
              local shots_in = t.has.rpm and not CHARGE_WEAPONS[t.id]
                and (input.ok ~= true or input.blind or (input.presses or 0) ~= (o.h_presses or 0))
              if kind == 'down' and o.h_last_t >= (o.state_t or 0) and o.h_fell_before and not shots_in then
                -- a whole interval of cooling: measures the planet (against the neutral rate) ...
                -- (only weapons whose neutral rate is known from the wiki, and not near where it rests)
                local base = WIKI_HEAT[t.id] and WIKI_HEAT[t.id].down
                if base and w.heat > (learned.rest2[t.id] or 0) + 2 then planet_sample(math.abs(r) / base) end
              end
              if kind and not (WIKI_HEAT[t.id] and WIKI_HEAT[t.id][kind]) then
                -- ... and the weapon's own rate, when the wiki has none (cooling kept neutral)
                local v = math.abs(r)
                if kind == 'down' then v = v / planet_factor() end
                local old = learned[kind][t.id]
                if old then v = old * 0.7 + v * 0.3 end
                learn(kind, t.id, math.floor(v * 10 + 0.5) / 10)
              end
            end
          end
          o.h_fell_before = o.h_last ~= nil and w.heat < o.h_last and not firing
          o.h_last, o.h_last_t, o.h_presses = w.heat, now, input.presses or 0
        end
      end
      -- a charge (the Nova, the Quasar): the trigger held while the heat stays put, then the heat jumps (the shot).
      -- Weapons that heat up while firing (the Laser Cannon) are never charge weapons.
      if w.charging == true and (o.prev == nil or o.prev.charging ~= true) then o.charge_t0, o.charge_h0 = now, w.heat end
      if o.charge_t0 and o.prev and type(w.heat) == 'number' and type(o.prev.heat) == 'number'
         and w.heat > o.prev.heat + 5 then
        local took = now - o.charge_t0
        -- (a charged shot fills it, near the overheat point; a laser's heat seen late only steps part of the way)
        local full = w.overheated == true or w.heat >= (learned.heat[t.id] or 100) * 0.9
        if full and o.prev.heat == o.charge_h0 and took > 0.3 and took < 6 and CHARGE_WEAPONS[t.id] then
          learn('charge2', t.id, math.floor(took * 10 + 0.5) / 10)
        end
        o.charge_t0 = nil
      end
      if o.charge_t0 and type(w.heat) == 'number' and w.heat ~= o.charge_h0 and w.heat <= (o.prev and o.prev.heat or w.heat) + 5 then
        o.charge_t0 = nil                                  -- rising bit by bit while held: firing, not charging
      end
      -- the shot's heat can land a read or two after charging ends: forget the charge half a second after it ended
      if w.charging == true then o.charge_end = nil
      elseif o.charge_t0 then
        o.charge_end = o.charge_end or now
        if now - o.charge_end > 0.5 then o.charge_t0, o.charge_end = nil, nil end
      end
      -- where the heat comes to rest: after cooling it stayed put for 4.5 s (the field can sit unchanged for a few
      -- seconds mid-cooldown), low, not overheated or charging
      if type(w.heat) == 'number' and o.prev and o.prev.heat == w.heat then o.still = o.still or now else o.still = nil end
      if o.still and now - o.still >= 4.5 and o.cooling and w.overheated ~= true and w.charging ~= true
         and w.heat > 0 and w.heat < 15 then
        local r = math.floor(w.heat * 10) / 10
        -- (only ever lowered: a pause before cooling starts, or between the game's updates, can look like a rest)
        if learned.rest2[t.id] == nil or r < learned.rest2[t.id] then
          log('learned: type %s cools down to %.1f', t.id, r) learn('rest2', t.id, r)
        end
        o.cooling = false
      end
      if type(w.heat) == 'number' and o.prev and type(o.prev.heat) == 'number' then
        if w.heat < o.prev.heat then o.cooling = true elseif w.heat > o.prev.heat then o.cooling = false end
      end
      if o.prev and not w.gone and loaded(w) > loaded(o.prev) and goid == hand.goid then   -- (yours: the one in hand)
        reloaded[#reloaded + 1] = t
        recent.reload_t, recent.reload_t_type = now, t
        -- its own magazines or spare rounds went down: it reloads from those, never from the backpack (the Railgun
        -- reloading just as the Guard Dog reloaded from its backpack was learned as a backpack weapon, and showed the
        -- dog's magazines). Only
        -- sure when the last read had them too (a lite read doesn't).
        local function down(k) return type(w[k]) == 'number' and type(o.prev[k]) == 'number' and w[k] < o.prev[k] end
        local own = down('magazines') or down('spare')
        recent.reload_sure = not o.prev.lite and not own
        if own and learned.packres[t.id] then
          log('type %s reloads from its own magazines, not the backpack (learned wrongly before)', t.id)
          learn('packres', t.id, nil)
        end
        if cfg.research and objs[hand.goid or -1] == o then
          log('reload %s: rounds=%s magazines=%s slot0=%s slot1=%s selected=%s chamber=%s spare=%s', t.id,
            tostring(w.rounds), tostring(w.magazines), tostring(w.slot0), tostring(w.slot1), tostring(w.selected),
            tostring(w.chamber), tostring(w.spare))
        end
      end
      if (tonumber(w.reload_stage) or 0) ~= 0 and goid == hand.goid then recent.reload_t = now end
      -- the trigger: seen held within the last 0.6 s (for types whose trigger field has ever been seen held)
      if w.held == true then o.held_t, o.held_ever = now, true end
      local by_you = not t.has.held or not o.held_ever or (o.held_t and now - o.held_t <= 0.6)
      -- (1.5.39 tried and dropped: "three shots with the trigger never seen held: not yours", HUDdle 0.5.11's rule.
      -- A tap on a semi-auto weapon holds the trigger for less than the 0.1 s between reads, so three quick taps
      -- of your own could never be seen held and your own weapon would be put out of your hands; the dogs' guns
      -- are kept out by name (NOHAND) and turrets and soldiers by their aim instead. docs/RESEARCH.md)
      -- (a weapon whose trigger was never seen held can't take the hands from one whose trigger has been: the shown
      -- weapon keeps them while a dog's fires)
      if fired(o.prev, w, switching) then
        -- the weapon in hand firing with no fire input seen in the last 20 s, twice: the fire input can't be read
        -- (never once a press was seen: then it can be read, and the weapon shown firing alone is someone else's: a
        -- SEAF soldier's gun, shown by mistake, set this off in a 1.0.2 log)
        if goid == hand.goid and not pressed_recently(now) and not input.ever and now - input.last > 20 then
          input.blind_shots = (input.blind_shots or 0) + 1
          if input.blind_shots >= 2 and not input.blind then
            input.blind = true
            log('fire button: your weapon fires with no fire button or trigger seen (a controller NarrowHUD can\'t read?): shots aren\'t checked from now on')
            o.unpressed, o.notmine, distrust[t.id] = 0, nil, nil
          end
        end
        -- (counted both ways: someone else's can fire just as you press. Not while the weapon shown in hand is itself
        -- firing or charging (1.2.5): a soldier's gun firing as you hold the Scythe's beam counted a shot "with your
        -- fire button" each time, and two of those made it "proven yours")
        local so = hand.goid and hand.goid ~= goid and objs[hand.goid]
        local st = so and so.t and TYPES[so.t]
        local so_busy = so and ((so.fired_at and now - so.fired_at <= 0.4) or (so.held_t and now - so.held_t <= 0.4)
          or (so.charging_t and now - so.charging_t <= 0.6) or (st and st.has.heat and so.prev and so.prev.charging == true))
        if pressed_recently(now) then
          if not so_busy then o.pressed = (o.pressed or 0) + 1 end
        else o.unpressed = (o.unpressed or 0) + 1 end
        local p, u = o.pressed or 0, o.unpressed or 0
        o.mine = p >= 2 and p > u
        -- (three shots without it, and a quarter or more of all its shots: a soldier firing while you fire too got 10
        -- with and 6 without, and took the HUD; your own weapons fire without it never)
        if u >= 3 and u * 4 >= p then not_yours(goid, o, t, 'fires without your fire button') end
      end
      local shown_o = hand.goid and objs[hand.goid]
      local steals = shown_o and shown_o ~= o and shown_o.held_ever and not o.held_ever
      -- yours: fired with your fire button and never without it; once any object of its type fired without it this
      -- session (someone else's of the same kind), it must have fired with it twice and more than without
      local yours = (o.unpressed or 0) == 0 or o.mine
      if distrust[t.id] then yours = o.mine end
      if grip and grip ~= 0 and not THROWABLE[grip] and HANDHELD[t.id] and fired(o.prev, w, switching) and not o.ub and by_you
         and not steals
         and not o.notmine and pressed_recently(now) and yours then
        any_fired = true
        o.fired_at = chef.time()
        -- fired while hidden for a key not its: that key is its after all (a rebind)
        if hand.mask and hand.mask.goid == goid then
          log('learned: type %s is on swap key %s (it fired after the key)', t.id, SWAP_KEYS[hand.mask.key])
          learn('slot', t.id, hand.mask.key)
          hand.mask = nil
        end
        -- (what's learned from this shot waits a moment: if the weapon shown in hand fired at the same time, this one
        -- isn't in your hand: as host, a SEAF soldier's gun firing as you fire)
        pending_learn[#pending_learn + 1] = { goid = goid, t = t, grip = grip, at = chef.time(), fn = function()
          -- a key's guess proved wrong (the other weapon on the pose fired just after): that key is this weapon's
          if swap.chosen and swap.chosen ~= goid and objs[swap.chosen] and objs[swap.chosen].t
             and now - (swap.chosen_at or -100) < 4 and type(swap.key) == 'number' then
            local wrong = TYPES[objs[swap.chosen].t].id
            if learned.slot[wrong] == swap.key then learn('slot', wrong, nil) end
            if learned.slot[t.id] ~= swap.key then
              log('learned: type %s is on swap key %s (it fired after the key; %s isn\'t)', t.id, SWAP_KEYS[swap.key], wrong)
              learn('slot', t.id, swap.key)
              if objs[goid] then objs[goid].taught_slot = swap.key end
            end
            swap.chosen = nil
          end
          if (not has_pose(t.id, grip) and not many_poses(t.id)) then
            log('learned: type %s goes with hand pose %d', t.id, grip)
            add_pose(t.id, grip)
            local lo = objs[goid]
            if lo then lo.taught = lo.taught or {} lo.taught[#lo.taught + 1] = grip end
          end
        end }
      end
      -- a weapon with no ammo of its own (the Arc Thrower): learned when its trigger is held at a pose nothing else has
      if grip and grip ~= 0 and not THROWABLE[grip] and t.noammo and not o.ub and not o.notmine
         and w.held == true and (o.prev == nil or o.prev.held ~= true) and HANDHELD[t.id] and (not has_pose(t.id, grip) and not many_poses(t.id)) then
        -- (a pose another weapon of yours has is taken, unless that one's trigger field reads not held now: the
        -- Solo Silo's remote held like the Warrant)
        local taken = false
        for g2, o2 in pairs(objs) do
          local t2 = o2.t and TYPES[o2.t]
          if g2 ~= goid and t2 and o2.on and not t2.pack and not t2.other and has_pose(t2.id, grip)
             and not (t2.has.held and o2.prev and o2.prev.held == false) then taken = true break end
        end
        if not taken then
          log('learned: type %s (no ammo of its own) goes with hand pose %d', t.id, grip)
          add_pose(t.id, grip)
        end
      end
      o.prev = w
    end
  end
  -- a weapon fed from the backpack: the pack's ammo went down while no weapon's own ammo moved, and it's the one fed
  -- weapon on you
  local now = chef.time()
  -- which backpack is yours: the one that went down with your reload, or while you fired with nothing else firing
  local cur = packs_now(s)
  for pg, v in pairs(cur) do
    local was = N.pack_vals[pg]
    if type(v) == 'number' and type(was) == 'number' and v < was and objs[pg] then
      -- proven yours: it went down with your reload, while you fired a weapon fed from it, or while you threw something
      local shown_o = hand.goid and objs[hand.goid]
      local fed_fire = shown_o and shown_o.t and TYPES[shown_o.t].fed and pressed_recently(now)
      if now - recent.reload_t <= 1 or fed_fire or (grip and THROWABLE[grip]) then
        local pt = TYPES[objs[pg].t]
        if not objs[pg].mine and cfg.research then log('research: backpack type %s is yours', pt.id) end
        objs[pg].mine = true
      end
    end
  end
  N.pack_vals = cur
  local r = pack_ammo(s)
  -- a weapon that reloads from the backpack: it got more loaded within a second of the pack going down (either first)
  if r and N.pack_prev and r < N.pack_prev then recent.pack_drop_t = now end
  local rt = recent.reload_t_type
  if rt and math.abs(recent.pack_drop_t - recent.reload_t) <= 1 and not learned.packres[rt.id] and not rt.fed
     and recent.reload_sure then
    log('learned: type %s reloads from the backpack', rt.id)
    learn('packres', rt.id, true)
  end
  -- (a pack going down near a reload is the reload, never a fed weapon firing)
  local reloading = now - recent.reload_t <= 1.5
  if r and N.pack_prev and r < N.pack_prev and not any_fired and not reloading and grip and grip ~= 0 and not THROWABLE[grip] then
    local only, n = nil, 0
    for goid, o in pairs(objs) do
      local t = o.t and TYPES[o.t]
      if t and t.fed and o.on and not o.ub and not o.notmine then only, n = goid, n + 1 end
    end
    if n ~= 1 and cfg.research and hand.fed_said ~= grip then
      hand.fed_said = grip
      local l = {}
      for _, o in pairs(objs) do
        local t = o.t and TYPES[o.t]
        if t and t.fed and o.on then l[#l + 1] = t.id .. (o.ub and '(ub)' or '') end
      end
      log('research: the backpack went down at hand pose %d with %d fed weapons on you: %s', grip, n, table.concat(l, ' '))
    end
    if n == 1 then
      local t = TYPES[objs[only].t]
      objs[only].fired_at = chef.time()
      if HANDHELD[t.id] and not has_pose(t.id, grip) and not many_poses(t.id) and not N.pose_shared[t.id .. ':' .. grip] then
        log('learned: type %s (fed from the backpack) goes with hand pose %d', t.id, grip)
        add_pose(t.id, grip)
      end
    end
  end
  N.pack_prev = r
end

-- Fire modes and rates of fire: shown once a weapon has been seen with two of them (learned, so from then on at once).
-- The fire mode field's value 8 selects an underbarrel (seen: the Arbitrator); 1, 2, 3 are auto, semi, burst (seen in
-- the research log against the game's own display). Other values show as MODE <n> until named.

N.planet, N.heat_rate, N.watch_fire, N.WIKI_HEAT = planet, heat_rate, watch_fire, WIKI_HEAT
end)()

;(function() -- 07_weapon
-- NarrowHUD, weapon: a weapon's state as shown (d): fire and weapon modes, rate of fire, charge, magazine size, spare magazines.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local TYPES, NO_OBJECT, blocked, field, learned, HEAT_RANGE = N.TYPES, N.NO_OBJECT, N.blocked, N.field, N.learned, N.HEAT_RANGE
local learn, objs, read_weapon, pack_ammo, planet = N.learn, N.objs, N.read_weapon, N.pack_ammo, N.planet

local MODE_NAMES = { [1] = 'AUTO', [2] = 'SEMI', [3] = 'BURST', [4] = 'VOLLEY', [5] = 'SAFE', [6] = 'UNSAFE', [7] = 'TOTAL' }
-- (1.5.18) the game's own HUD icons: sprites on its texture-atlas pages (docs/ICONS.md; the records read from the
-- installed game by tools/atlas_sprites.py, 2026-10-28: a sprite is named by the murmur64 of its path, e.g.
-- content/ui/mission/hud/weapon_function/firemode_single is 3efff09cd12fb89a). Each entry: the page texture's id
-- and the sprite's uv rectangle on it; drawn with chef.bitmap_uv, nothing shipped. The rectangles move when
-- Arrowhead repacks an atlas: rerun the tool after a patch and compare.
N.ATLAS = {
  -- weapon_function/* (128 px) on the mission atlas page f9a3f2 (4096x2048 BC1, 13 mips), the page 10a081
  -- (2048x1024 BC1, 4 mips) and 7b1eef (256x256); the sixth value is the sprite's id (the path's murmur64), which
  -- also names the game's own icon material for it (the mask shader: black is empty, R and G the icon's white, B
  -- its shadow; HD2Runtime's finding). Drawn in game 2026-10-28: every one of these, through that material.
  AUTO     = { 'f9a3f22a93eedcbd', 0.223388671875, 0.2265625, 0.254638671875, 0.2890625, '6115051c9558c50e' },
  SEMI     = { 'f9a3f22a93eedcbd', 0.943115234375, 0.1640625, 0.974365234375, 0.2265625, '3efff09cd12fb89a' },
  BURST    = { 'f9a3f22a93eedcbd', 0.786865234375, 0.1640625, 0.818115234375, 0.2265625, '131742904d846798' },
  VOLLEY   = { 'f9a3f22a93eedcbd', 0.634521484375, 0.0078125, 0.665771484375, 0.0703125, '16413ee2e6725687' },
  UNDERBARREL = { 'f9a3f22a93eedcbd', 0.301513671875, 0.2265625, 0.332763671875, 0.2890625, 'b019df1ca8b6d4a2' },
  UNDERBARREL_SHOTGUN = { 'f9a3f22a93eedcbd', 0.947021484375, 0.0859375, 0.978271484375, 0.1484375, '067bb0962f896bbb' },
  UNDERBARREL_FLAMER = { 'f9a3f22a93eedcbd', 0.340576171875, 0.2265625, 0.371826171875, 0.2890625, 'cd87fdddec2a6bfc' },
  APHET    = { 'f9a3f22a93eedcbd', 0.379638671875, 0.1484375, 0.410888671875, 0.2109375, 'f8ede5f922c05cb6' },
  FLAK     = { 'f9a3f22a93eedcbd', 0.457763671875, 0.1484375, 0.489013671875, 0.2109375, '9dcc0312a14e11e6' },
  FRAG     = { 'f9a3f22a93eedcbd', 0.496826171875, 0.1484375, 0.528076171875, 0.2109375, '8dc0ec9ce217ab7f' },
  HEAT     = { 'f9a3f22a93eedcbd', 0.630615234375, 0.1640625, 0.661865234375, 0.2265625, '4b867645db9f364e' },
  HE       = { 'f9a3f22a93eedcbd', 0.535888671875, 0.1484375, 0.567138671875, 0.2109375, '081dcaf42dc2ecbb' },
  FLECHETTE = { 'f9a3f22a93eedcbd', 0.712646484375, 0.0859375, 0.743896484375, 0.1484375, '3b975896bc689499' },
  STUN     = { 'f9a3f22a93eedcbd', 0.708740234375, 0.1640625, 0.739990234375, 0.2265625, '2d9268907fb9420e' },
  LASER    = { 'f9a3f22a93eedcbd', 0.829833984375, 0.0078125, 0.861083984375, 0.0703125, 'c1028550c62fc4fa' },
  NO_LASER = { 'f9a3f22a93eedcbd', 0.790771484375, 0.0078125, 0.822021484375, 0.0703125, 'a9f9bf81827c51e5' },
  GUIDED   = { '10a0814c0fad8650', 0.6328125, 0.578125, 0.6953125, 0.703125, '7db70e669d8034c9' },
  UNGUIDED = { '10a0814c0fad8650', 0.7109375, 0.578125, 0.7734375, 0.703125, 'bc7975e05284cf57' },
  DEPLOY   = { '10a0814c0fad8650', 0.8671875, 0.578125, 0.9296875, 0.703125, '38adabc6a32af014' },
  DETONATE = { '10a0814c0fad8650', 0.7890625, 0.578125, 0.8515625, 0.703125, '55374383474193f8' },
  AIRSTRIKE = { '10a0814c0fad8650', 0.2421875, 0.578125, 0.3046875, 0.703125, 'f83f6f461ed94e4b' },
  BURST_FIRE = { '7b1eef337fc5f1bf', 0.0625, 0.0625, 0.5625, 0.5625, '62d0512daebb0be0' },
  -- (1.5.47) a scope's zeroing step (weapon_function/zeroing_low, _medium, _high on the mission HUD page)
  ZEROING_LOW    = { 'f9a3f22a93eedcbd', 0.223388671875, 0.1484375, 0.254638671875, 0.2109375, '6be28cced767bb52' },
  ZEROING_MEDIUM = { 'f9a3f22a93eedcbd', 0.262451171875, 0.1484375, 0.293701171875, 0.2109375, '46271d0b4ce4136c' },
  ZEROING_HIGH   = { 'f9a3f22a93eedcbd', 0.591552734375, 0.09375, 0.622802734375, 0.15625, 'a2ab43e85546f79a' },
  -- unnamed sprites that look like the HUD's stim, stims and grenade icons (the stim page isn't loaded in a mission)
  stim     = { '18edbed388a3d706', 0.155517578125, 0.89208984375, 0.171142578125, 0.92333984375, 'a0e91aa5aab7b94d' },   -- 64 px
  stims    = { '1667261d881bd08a', 0.94921875, 0.4169921875, 0.98046875, 0.4482421875, '55decfa1c7de5d20' },             -- 128 px
  grenade  = { 'f9a3f22a93eedcbd', 0.095947265625, 0.76171875, 0.111572265625, 0.79296875, 'e1ebfa9b2ca0963c' },         -- 64 px
}
-- the words of what's shown -> the sprite the game's HUD uses for them (the fire modes; the weapon's own modes: the
-- WASP's BURST is burst_fire, its ARTILLERY the airstrike, the Airburst's CLUSTER the frag; the Railgun's SAFE the
-- single, UNSAFE the burst; seen against the HUD 2026-10-28)
local FIRE_SPRITES = { AUTO = 'AUTO', SEMI = 'SEMI', BURST = 'BURST', VOLLEY = 'VOLLEY', SAFE = 'SEMI', UNSAFE = 'BURST' }
local OPTION_SPRITES = { APHET = 'APHET', FLAK = 'FLAK', HEAT = 'HEAT', HE = 'HE', FLECHETTE = 'FLECHETTE', STUN = 'STUN',
  LASER = 'LASER', ['NO LASER'] = 'NO_LASER', GUIDED = 'GUIDED', UNGUIDED = 'UNGUIDED', DEPLOY = 'DEPLOY', DETONATE = 'DETONATE',
  CLUSTER = 'FRAG', ARTILLERY = 'AIRSTRIKE', BURST = 'BURST_FIRE' }
-- the underbarrel selected, by its type: the grenade launcher's icon, the shotgun's, the flamer's (the Arbitrator's
-- shotgun: to be learned from the research log, "underbarrel type")
-- (luka's logs, 2026-10-28: the One-Two's launcher 16425925, the Arbitrator's shotgun da0f356e, the Stoker's flamer 2166c7a1)
local UNDERBARREL_SPRITES = { ['16425925'] = 'UNDERBARREL', da0f356e = 'UNDERBARREL_SHOTGUN', ['2166c7a1'] = 'UNDERBARREL_FLAMER' }
local ub_said = {}
-- a sprite entry with the word it stands for (the icon takes the word's colour, as the text does); made once per
-- sprite and word
local worded = {}
local function with_word(e, word)
  local key = e[6] .. word
  local w = worded[key]
  if not w then
    w = { e[1], e[2], e[3], e[4], e[5], e[6], word = word }
    worded[key] = w
  end
  return w
end
N.FIRE_WORD = function(word) return word == 'ZOOM' or FIRE_SPRITES[word] ~= nil end   -- (1.5.57: the icons apart)
N.mode_icons = function()
  local d = N.shown_d
  if not d then return nil end
  local out = {}
  if d.mode then
    local rest = d.mode
    while rest and rest ~= '' do
      local word, more = string.match(rest, '^(.-)  (.*)$')
      word = word or rest
      rest = more
      local e = OPTION_SPRITES[word] and N.ATLAS[OPTION_SPRITES[word]]
      if e then out[#out + 1] = with_word(e, word) end
    end
  end
  -- (1.5.47) the scope's zeroing step, for a weapon learned to have one: the game's low / medium / high icon
  if d.zoom then
    local name = ({ [0] = 'ZEROING_LOW', 'ZEROING_MEDIUM', 'ZEROING_HIGH' })[d.zoom]
    if name then out[#out + 1] = with_word(N.ATLAS[name], 'ZOOM') end
  end
  if d.underbarrel then
    local name = UNDERBARREL_SPRITES[d.tid]
    if not name and not ub_said[d.tid] then ub_said[d.tid] = true log('research: underbarrel type %s: no sprite known for it (the generic underbarrel icon)', tostring(d.tid)) end
    out[#out + 1] = with_word(N.ATLAS[name or 'UNDERBARREL'], d.ub_label or 'UB')
  else
    -- (a weapon with an underbarrel shows its fire mode's icon even with one mode: the switch is to the underbarrel,
    -- as the game's HUD shows it; the text keeps its two-modes rule)
    local fm = d.fmode or d.fmode_ub
    if fm and FIRE_SPRITES[fm] then out[#out + 1] = with_word(N.ATLAS[FIRE_SPRITES[fm]], fm) end
  end
  return out[1] and out or nil
end
-- (seen against the game's own display, 2026-10-24: Pummeler, Autocannon, Bushwhacker, Railgun)
local function seen(kind, id, value)
  local list = learned[kind][id] or ''
  local key = ',' .. tostring(value) .. ','
  if not string.find(',' .. list .. ',', key, 1, true) then
    list = list == '' and tostring(value) or (list .. ',' .. tostring(value))
    learn(kind, id, list)
  end
  return string.find(list, ',', 1, true) ~= nil      -- two or more seen
end
-- the fire mode (on the left of the bar, with the weapon's own mode)
local function fire_mode_label(t, w)
  local fm = tonumber(w.fire_mode)
  if fm and math.floor(fm / 8) % 2 == 0 and seen('modes', t.id, fm % 8) then
    return MODE_NAMES[fm % 8] or ('MODE ' .. (fm % 8))
  end
  return nil
end
-- the rate of fire (small, under the count)
-- The rate field is the rate in effect: Extreme Cold lowers every weapon's by 10 % (the Helldivers 2 wiki), while the
-- game's menu shows the setting. So the setting is shown: each weapon's settings are learned (not while it's cold), a
-- reading 0.9 of a known setting is that setting and means it's cold (for every weapon, until a reading matches a
-- setting again), and the planet's measured cooling (x1.5) says so too.
local cold = { wid = nil, on = false }
local function is_cold()
  local wid = chef.world_id and chef.world_id()
  if wid ~= cold.wid then cold.wid, cold.on = wid, false end
  return cold.on or planet.factor == 1.5
end
local function in_list(list, v)
  for x in string.gmatch(list or '', '[^,]+') do
    local n = tonumber(x)
    if n and math.abs(n - v) <= 1.5 then return n end
  end
  return nil
end
local function rpm_setting(id, v)
  local base = learned.rpmbase[id]
  local exact = in_list(base, v)
  if exact then cold.on = false return exact end
  local warm = in_list(base, v / 0.9)
  if warm then cold.on = true return warm end
  if is_cold() then return math.floor(v / 0.9 + 0.5) end
  learn('rpmbase', id, base and (base .. ',' .. v) or tostring(v))
  return v
end
local rpm_last = {}
local function setting_label(t, w)
  local parts = {}
  local rpm = tonumber(w.rpm)
  if rpm and rpm > 0 and not t.has.heat then                  -- (heat weapons: the field isn't a rate of fire)
    -- (another rate in the same fire mode: a rate of fire setting. Not across missions, and not one 0.9 of the other:
    -- Extreme Cold's 10 %, the Sightliner's 40 and 36 on two planets taught it a setting it doesn't have)
    local wid = chef.world_id and chef.world_id()
    local last = rpm_last[t.id]
    if last and last.wid ~= wid then last = nil end
    local cold_pair = last and (math.abs(rpm - last.rpm * 0.9) <= 1.5 or math.abs(last.rpm - rpm * 0.9) <= 1.5)
    if last and last.fm == w.fire_mode and last.rpm ~= rpm and last.rpm > 0 and not cold_pair and not learned.rpmadj[t.id] then
      log('learned: type %s has a rate of fire setting', t.id)
      learn('rpmadj', t.id, true)
    end
    rpm_last[t.id] = { fm = w.fire_mode, rpm = rpm, wid = wid }
    if learned.rpmadj[t.id] then parts[#parts + 1] = rpm_setting(t.id, math.floor(rpm + 0.5)) .. ' RPM' end
  end
  return #parts > 0 and table.concat(parts, '  ') or nil
end

-- A weapon's own mode is in its options field, two bits per setting (seen in the research log, 2026-10-24): the bits at
-- 4 are the ammo type or guidance (the Warrant 80 / 84, the Autocannon, Recoilless, Airburst and missile pistol the
-- same), the bits at 256 the C4's deploy / detonate (80 / 336), the bits at 4096 the fire mode (shown under the count
-- instead), the rest fixed. Named weapons show their mode at once; others show OPT <n> once the bits at 4 have been
-- seen with two values.
local OPTION_NAMES = {
  c920c2d3 = { at = 4, [0] = 'GUIDED', [1] = 'UNGUIDED' },     -- the Warrant
  fd585726 = { at = 4, [0] = 'GUIDED', [1] = 'UNGUIDED' },     -- the missile pistol
  ['7bfb2e06'] = { at = 4, [0] = 'APHET', [1] = 'FLAK' },      -- the Autocannon
  b2bfd847 = { at = 4, [0] = 'HEAT', [1] = 'HE' },             -- the Recoilless Rifle
  ['8a3c6fee'] = { at = 4, [0] = 'FLAK', [1] = 'CLUSTER' },    -- the Airburst Rocket Launcher
  ['6b2c3bed'] = { at = 256, [0] = 'DEPLOY', [1] = 'DETONATE' }, -- the C4
  ['656d507b'] = { at = 4, [0] = 'BURST', [1] = 'ARTILLERY' },  -- the WASP
}
-- Weapons with two loaded ammo types, chosen by the selected field (slot0 / slot1): the Halt's flechette and stun rounds
-- (a player's log, 2026-10-26: selected 0 on flechette, 1 on stun)
local SELECTED_NAMES = { ['9c06f074'] = { [0] = 'FLECHETTE', [1] = 'STUN' } }
-- (the game's HUD names for a weapon's two fires; luka, 2026-10-28)
local UB_NAMES = {
  cd0e4b4a = { main = '12MM', ub = 'FLAME' },          -- the Stoker
  ['8fcdd35c'] = { main = '4MM', ub = '10G' },         -- the Arbitrator (its underbarrel shotgun)
  ['3244dc49'] = { main = '8MM', ub = '40MM HE' },     -- the One-Two (its underbarrel launcher)
}
local function option_mode(t, w)
  local v = tonumber(w.options)
  if not v then return nil end
  local names = OPTION_NAMES[t.id]
  if names then return names[math.floor(v / names.at) % 4] end
  local m = math.floor(v / 4) % 4
  if not seen('options1', t.id, m) then return nil end
  return 'OPT ' .. m
end

-- charge meters (seconds to the end of the meter, and a mark), from the Helldivers 2 wiki
local CHARGE_METER = {
  ['26acc614'] = { secs = 3, mark = 2.5 },      -- RS-422 Railgun (unsafe: 90 % at 2.5 s, explodes at 3 s)
  ['314a1bf5'] = { secs = 3.25, mark = 2.6 },   -- PLAS-45 Epoch (full charge at 2.6 s, explodes at 3.25 s)
}

-- what to show for a weapon state
local function shown(s, goid, t, w, o)
  local d = { kind = nil }
  d.setting = setting_label(t, w)
  d.fmode = fire_mode_label(t, w)
  -- (most weapon types declare the underbarrel field; one is fitted only when it holds an object)
  local ub_bit = type(w.fire_mode) == 'number' and math.floor(w.fire_mode / 8) % 2 == 1
  local ub = t.has.underbarrel and (N.REF_READS or ub_bit) and field(s, goid, t, 'underbarrel')
  d.has_ub = type(ub) == 'number' and ub ~= NO_OBJECT
  if not d.fmode and d.has_ub and type(w.fire_mode) == 'number' and math.floor(w.fire_mode / 8) % 2 == 0 then
    d.fmode_ub = MODE_NAMES[w.fire_mode % 8]
  end
  -- the names the game's HUD gives a weapon's two fires (the Stoker: 12MM and FLAME; luka, 2026-10-28)
  local un = UB_NAMES[t.id]
  if un then d.ub_label = un.ub end
  d.t0, d.goid0 = t, goid                                        -- (the weapon itself, for its charge meter)
  -- (1.5.47) the scope's zeroing step (0 the lowest, 2 the highest) for a weapon learned to have one
  if learned.zoom[t.id] and type(w.options) == 'number' then d.zoom = math.floor(w.options / 16) % 4 end
  -- (1.5.54) the zeroing as text, an F9 row: 50 / 100 / 200 m for the low / medium / high step
  if d.zoom then d.zoom_word = ({ [0] = '50 M', '100 M', '200 M' })[d.zoom] end   -- (the layouts' zoom part shows it)
  d.mode = option_mode(t, w)
  if un and un.main and not d.mode then d.mode = un.main end
  local sn = SELECTED_NAMES[t.id]
  if sn and t.has.selected then
    local m = sn[tonumber(w.selected) or 0]
    if m then d.mode = d.mode and (m .. '  ' .. d.mode) or m end
  end
  -- laser guidance on / off (the Commando: a field of its own, seen in the research log 2026-10-24)
  if t.has.guide and w.guide ~= nil then
    local g = w.guide == true and 'LASER' or 'NO LASER'
    d.mode = d.mode and (d.mode .. '  ' .. g) or g
  end
  -- the underbarrel, when the fire mode selects it
  if d.has_ub and type(w.fire_mode) == 'number' and math.floor(w.fire_mode / 8) % 2 == 1 then
    local o = objs[ub]
    local ut = o and o.t and TYPES[o.t]
    if ut then
      t, w, goid = ut, read_weapon(s, ub, ut), ub
      d.underbarrel = true
    end
  end
  d.tid = t.id                                                   -- (the weapon shown: the underbarrel when selected)
  if t.has.heat and not t.has.rounds then
    d.kind = 'heat'
    local h = tonumber(w.heat) or 0
    -- Where it overheats: per weapon object, as attachments change it (the LAS-5 Scythe: 60, 100 or 150 with its heat
    -- sinks, a player's report). The type keeps the last one seen, for the next mission's start. While overheated:
    -- the highest heat read is the point (a read can land a moment after it, a little lower: within 8 % below the
    -- one known, that one stays). Heat past the known point means it's higher.
    -- The heat can read 0 already in the first overheated read (the Scythe, a 2026-10-26 log: "overheats at 0"), so
    -- the heat just before counts too, and a point under 30 never does (no weapon overheats that low). A lower point is
    -- taken only from an overheat seen starting (not one already under way when the weapon was first shown: its heat
    -- had cooled some).
    local top = learned.heat[t.id] or 100
    local ho = (not d.underbarrel) and o or nil
    local now = chef.time()
    if ho and type(w.heat) == 'number' then
      top = ho.heat_top or top
      if w.overheated == true then
        if ho.oh_peak == nil then
          ho.oh_seen = ho.h_before_t ~= nil and now - ho.h_before_t <= 0.5
          ho.oh_peak = ho.oh_seen and ho.h_before or 0
        end
        if h > ho.oh_peak then ho.oh_peak, ho.oh_read = h, true end
        local p = math.floor(ho.oh_peak + 0.5)
        -- (a value read while overheated is the heat at its top. The one from just before has the field's dead band
        -- (12_heat) over it: the heat went on up to anywhere within the band of that value before overheating, so
        -- the known point stays when it's within that, and a lower one is the band's top; the 1.2.7 log read the
        -- Talon's 84.8 just before and took its point for 85)
        local tol = ho.oh_read and 0 or (N.heat_tol and N.heat_tol(t) or 15.6)
        local lower = ho.oh_seen and p + tol < top * 0.92
        if lower then p = math.floor(p + tol + 0.5) end
        if p >= 30 and (p > top or lower) then ho.heat_top, top = p, p end
      else
        if ho.oh_peak then
          ho.oh_peak, ho.oh_read = nil, nil
          local k = learned.heat[t.id]
          if top >= 30 and (k == nil or top > k or top < k * 0.92) then
            if k then log('learned: type %s overheats at %d (was %d: an attachment?)', t.id, top, k) end
            learn('heat', t.id, top)
          end
        end
        ho.h_before, ho.h_before_t = h, now
      end
      if h > top then ho.heat_top, top = math.ceil(h), math.ceil(h) end
    elseif w.overheated == true and h > top and h >= 30 then
      learn('heat', t.id, math.floor(h + 0.5))
      top = math.floor(h + 0.5)
    end
    local range = HEAT_RANGE[t.id]
    if range then top = range.top end
    local rest = learned.rest2[t.id] or 0
    -- a charge weapon while charging: the heat field stays put until the shot, so the bar rises over the charge time
    local secs = learned.charge2[t.id]
    if secs and w.charging == true and o and o.charge_t0 then
      d.charge_anim, d.charge_secs, d.charge_from = true, secs, h   -- (run every frame, below)
      h = h + (top - h) * math.min(1, (chef.time() - o.charge_t0) / secs)
    end
    d.top_raw, d.tid, d.t, d.goid = top, t.id, t, goid
    d.top = top - rest
    d.value = math.max(0, h - rest)
    d.overheated, d.charging = w.overheated == true, w.charging == true
    d.rest, d.o = rest, o
    -- (past 100: the bar runs to its top, the % reads the heat as it is, the mark where it starts to hurt)
    if range then
      d.heat_marks, d.pct_top = {}, top
      for _, m in ipairs(range.marks) do d.heat_marks[#d.heat_marks + 1] = { (m[1] - rest) / (top - rest), m[2] } end
    end
  elseif t.has.rounds then
    d.kind = 'ammo'
    local n = tonumber(w.rounds) or 0
    d.mag = n                                                     -- the magazine alone (its size is learned from it)
    if t.has.chamber and w.chamber == false then n = n + 1 end   -- a round in the chamber
    d.value = n
  elseif t.has.slot0 then
    d.kind = 'ammo'
    local sel = tonumber(w.selected) or 0
    local n = tonumber(sel == 1 and w.slot1 or w.slot0) or 0
    if t.has.chamber and w.chamber == false then n = n + 1 end   -- a shell in the chamber (single-shot launchers)
    d.value, d.mag = n, n                                         -- (the chamber is part of what it holds)
  elseif t.noammo then
    d.kind = 'none'                                               -- (only its modes and charge meter)
  elseif t.fed then
    local r, pg = pack_ammo(s)
    if r == nil then return d end                                -- no pack on you: nothing to show
    d.kind, d.value, d.mag, d.fed = 'ammo', r, r, true
    -- (its bar is the pack's: the most that pack type was seen holding, not the weapon's: the Maxigun's and the
    -- Cremator's share a hand pose)
    local pt = TYPES[objs[pg].t]
    if r > (learned.pack[pt.id] or 0) then learn('pack', pt.id, r) end
    d.pack_top = learned.pack[pt.id]
  end
  if d.kind == 'ammo' then
    -- the bar is the magazine: a tactical reload's extra round in the chamber shows in the count, not as a bigger
    -- magazine
    if d.pack_top then
      d.top = d.pack_top
    else
      if d.mag > (learned.mag[t.id] or 0) then learn('mag', t.id, d.mag) end
      -- The magazine's size is this weapon's in this mission: attachments change it (the Liberator Penetrator's
      -- shortened magazine: 30 instead of 45), and they're set for the whole mission. The most this object has held
      -- is its size, once it's known to have been full: it was there in the mission's first 30 s (you drop with
      -- full magazines), held as much as the most learned, or was reloaded. Until then, the most learned.
      local top = learned.mag[t.id] or d.mag
      local o = objs[goid]                                         -- (the underbarrel's own object when it's selected)
      -- (two loaded ammo types, the Halt's: each its own magazine, kept apart, so a switch isn't taken for a reload)
      if o and t.has.slot1 and t.has.selected and SELECTED_NAMES[t.id] then
        local sel = tonumber(w.selected) or 0
        o.per_sel = o.per_sel or {}
        o.per_sel[sel] = o.per_sel[sel] or {}
        o = o.per_sel[sel]
      end
      if o then
        if o.mag_max == nil then
          o.mag_max = d.mag
          o.mag_full = (blocked.since ~= nil and chef.time() - blocked.since < 30) or d.mag >= (learned.mag[t.id] or 0)
        elseif d.mag > o.mag_max then
          o.mag_max, o.mag_full = d.mag, true
        elseif o.mag_prev and d.mag > o.mag_prev then
          o.mag_full = true
        end
        o.mag_prev = d.mag
        if o.mag_full then top = o.mag_max end
      end
      d.top = math.max(1, top)                                     -- (a single-shot weapon's magazine is always 0)
    end
  end
  d.reloading = (tonumber(w.reload_stage) or 0) ~= 0 and d.kind == 'ammo'
  d.reload_stage = tonumber(w.reload_stage)
  -- the reserve: magazines, else spare rounds, else your backpack's
  if learned.packres[t.id] then
    d.reserve = pack_ammo(s)                                    -- (reloads from its backpack: the C4's charges ...)
  elseif d.fed then
    -- (the pack is the ammo)
  -- (a heat weapon's magazines are heat sinks: shown once it has carried some, 0 too when they're used up; a charge
  -- weapon's field never means anything)
  elseif t.has.magazines and tonumber(w.magazines) and (not t.has.heat or (not N.CHARGE_WEAPONS[t.id]
         and (w.magazines > 0 or (learned.resmax[t.id] or 0) > 0)))
         and not (N.seat and N.seat.gun == goid and w.magazines == 0) then
    d.reserve = w.magazines
    if t.has.heat and w.magazines > (learned.resmax[t.id] or 0) then learn('resmax', t.id, w.magazines) end
  elseif t.has.spare then d.reserve = tonumber(w.spare)
  elseif d.kind == 'ammo' and N.seat and N.seat.gun == goid then
    -- (1.5.51: a mounted gun with no magazines (the emplacements' belts) shows its rounds alone, not "x0")
  elseif d.kind == 'ammo' then
    -- (not for a heat weapon: the Nova and the Scythe showed the Guard Dog's magazines as theirs)
    for pgoid, o in pairs(objs) do
      local pt = o.t and TYPES[o.t]
      if pt and pt.pack and o.on and pt.has.remaining then
        local r = field(s, pgoid, pt, 'remaining')
        if type(r) == 'number' then d.reserve = r break end
      end
    end
  end
  return d
end


N.CHARGE_METER, N.shown = CHARGE_METER, shown
end)()

;(function() -- 12_heat
-- NarrowHUD, heat: the heat bar between the field's values: a beam's rate while its trigger is held, a shot laser's
-- heat a shot, cooling, and the field's dead band.
-- (tools/build.py puts src/narrowhud.lua and these modules together, each module in a function of its own; N holds
-- what they share: imported as locals below when set once, used as N.x when it changes later)
local field, learned, learn, cfg, call = N.field, N.learned, N.learn, N.cfg, N.call
local heat_rate, input, CHARGE_WEAPONS = N.heat_rate, N.input, N.CHARGE_WEAPONS

-- The heat field moves in steps (the Scythe's 15.66, 31.34, 47 ...: a dead band of 15.6, Network.object_info's
-- tolerance for it), and lands a read late. So the bar runs its own model between values:
-- - a beam (the Scythe, the Laser Cannon, the Dagger: no rate of fire): up at the weapon's rate while the trigger
--   is held, down at its cooling otherwise (the rates: the wiki's or learned, 06_learning);
-- - a laser that fires shots (1.2.7; a rate of fire: the Talon, the Sickles, the Sai): each press of your fire
--   button a shot (two at most a frame), an automatic one firing on at its rate while the button is held, a burst
--   three; the heat a shot the wiki's (the Talon: 15) or learned from the field's rises over the shots counted; it
--   cools all along but for 0.3 s after a shot. A press is yours alone (the trigger field reads held for a soldier's
--   gun too), so with no fire button to read (a controller NarrowHUD can't see) the trigger field stands in.
-- A new value from the field is the heat as it was sent (a read late; a shot of the last 0.12 s may not be in it):
-- the difference is folded in over a quarter second, never jumped to. Between values the heat stays within the
-- band round the last one (the game would have sent a new one), so a model that runs past it is held at its edge.
local DELAY = 0.3
local tol_of = {}
local function heat_tol(t)
  local v = tol_of[t.id]
  if v ~= nil then return v or nil end
  v = false
  local ok, info = pcall(call, 'objinfo', 'Network.object_info', t.name)
  if ok and type(info) == 'table' and type(info.fields) == 'table' then
    for _, f in ipairs(info.fields) do
      if type(f) == 'table' and N.norm_id(f.id) == 'a5023836' and type(f.tolerance) == 'number' and f.tolerance > 0 then v = f.tolerance end
    end
  end
  if v == false then v = 15.6 end                 -- (every heat weapon seen so far)
  tol_of[t.id] = v
  return v
end
-- (the wiki's heat a shot is the start; the field's rises refine it (the 1.2.7 log: the Talon's 15 by the wiki,
-- about 12 by every rise read: 0 to 23.9 in two shots, 42.5 to 69.7 in three), so the bar doesn't run ahead)
local function shot_heat(id)
  local w = N.WIKI_HEAT and N.WIKI_HEAT[id]
  local wiki = w and w.shot or nil
  return learned.shot[id] or wiki, wiki
end
-- the model, every frame the weapon is shown (d: what's shown, o: its object)
local function heat_model(s, d, now)
  local o = d.o
  local by_shot = d.t.has.rpm == true and not CHARGE_WEAPONS[d.tid]
  -- (a shot laser's heat a shot not known yet: the beam model, up at the learned rate while the trigger is held,
  -- until the first rows teach it)
  local model_shots = by_shot and shot_heat(d.tid) ~= nil
  local trig
  if d.t.has.held and learned.charge2[d.tid] == nil then trig = field(s, d.goid, d.t, 'held') == true
  else trig = o.firing == true end
  local gap = now - (o.sim_t or -100)
  o.sim_t = now
  local top, rest = d.top_raw, d.rest or 0
  local tol = heat_tol(d.t)
  local cool = heat_rate('down', d.tid) or 0
  -- presses: your fire button's; when it can't be read, the trigger field going on
  local presses = input.presses or 0
  if input.ok ~= true or input.blind then
    if trig and not o.trig_was then o.trig_n = (o.trig_n or 0) + 1 end
    presses = o.trig_n or 0
  end
  o.trig_was = trig
  if o.sim == nil or gap > 0.5 then
    -- (first shown, or shown again: the field's last value, less what it has cooled since, within its band)
    local v = o.h_last
    if o.h_last_t and not trig then v = math.max(v - tol, v - cool * math.max(0, now - o.h_last_t - DELAY)) end
    o.sim, o.err, o.sim_seen, o.presses, o.shots, o.next_auto, o.burst_left = v, 0, o.h_last_t, presses, {}, nil, 0
    o.row = nil
    o.sim = math.max(0, math.min(top, o.sim))
    d.value = math.max(0, o.sim - rest)
    return
  end
  local dt = math.min(0.1, gap)
  local w = o.prev or {}
  local can = d.overheated ~= true and not d.reloading
  if by_shot then
    -- the shots this frame: presses (two at most), an automatic one's at its rate while the button is held, a
    -- burst's three
    local p = shot_heat(d.tid) or 0
    local rpm = tonumber(w.rpm)
    local every = (rpm and rpm > 0) and 60 / rpm or 0.1
    local mode = tonumber(w.fire_mode) and (w.fire_mode % 8) or 2
    local n = presses - (o.presses or presses)
    local fired = 0
    if n > 0 and can then
      fired = math.min(n, 2)
      o.next_auto, o.burst_left = now + every, mode == 3 and 2 or 0
    end
    local down = (input.ok == true and not input.blind) and input.down == true or trig
    if mode == 1 and can and down and o.next_auto then
      local k = 0
      while now >= o.next_auto and k < 4 do fired, o.next_auto, k = fired + 1, o.next_auto + every, k + 1 end
    elseif mode == 1 and not down then
      o.next_auto = nil
    end
    while (o.burst_left or 0) > 0 and can and o.next_auto and now >= o.next_auto do
      fired, o.burst_left, o.next_auto = fired + 1, o.burst_left - 1, o.next_auto + every
    end
    if fired > 0 then
      if model_shots then o.sim = o.sim + p * fired end
      o.shots = o.shots or {}
      table.insert(o.shots, 1, now)
      for k = #o.shots, 9, -1 do o.shots[k] = nil end
      if o.row then o.row.n = o.row.n + fired end
    end
    local cooling = not (o.shots and o.shots[1] and now - o.shots[1] < DELAY)
    if model_shots then
      if cooling then o.sim = o.sim - cool * dt end
    elseif trig then
      o.sim = o.sim + (heat_rate('up', d.tid) or 0) * dt
    else
      o.sim = o.sim - cool * dt
    end
    if cooling and o.row then o.row.tcool = o.row.tcool + dt end
  elseif trig then
    o.sim = o.sim + (heat_rate('up', d.tid) or 0) * dt
  else
    o.sim = o.sim - cool * dt
  end
  if o.sim_seen ~= o.h_last_t then                       -- a new value from the field
    o.sim_seen = o.h_last_t
    local v = o.h_last
    local e = v - o.sim
    -- (research: each value against the model's, 300 lines a weapon at most)
    if cfg.research and (o.hm_said or 0) < 300 then
      o.hm_said = (o.hm_said or 0) + 1
      log('research: %s heat %.1f, the bar had %.1f (%s; a shot %s, cooling %.1f a second)', d.tid, v, o.sim,
        model_shots and 'by shots' or (by_shot and 'beam model until its shot is learned' or 'beam'),
        tostring(shot_heat(d.tid)), cool)
    end
    -- (a value from just before the last shots: those aren't in it yet)
    if by_shot and e < 0 and o.shots then
      local recent = 0
      for _, ts in ipairs(o.shots) do if now - ts < 0.12 then recent = recent + 1 end end
      if recent > 0 then e = math.min(0, e + (shot_heat(d.tid) or 0) * recent) end
    end
    o.err, o.edge_t = e, nil
    -- (a shot laser's heat a shot learned from the rise between two values over the shots between them, the cooling
    -- in between put back; the wiki's kept where it has one)
    local r = o.row
    if by_shot and r and r.n > 0 and now - r.t <= 2 and can and r.v > rest + 1 and v < top * 0.95 then
      local est = (v - r.v + cool * r.tcool) / r.n
      local old, wiki = shot_heat(d.tid)
      -- (a rise within half of the wiki's number, where it has one; else anything a laser could heat a shot)
      local fits = wiki and (est >= wiki * 0.5 and est <= wiki * 1.5) or (not wiki and est >= 1 and est <= 60)
      if fits then
        local nv = math.floor((old and (old * 0.7 + est * 0.3) or est) * 100 + 0.5) / 100
        if cfg.research then log('research: %s heats %.1f a shot (%d shots, %.1f > %.1f, cooled %.2f s)', d.tid, est, r.n, r.v, v, r.tcool) end
        if learned.shot[d.tid] == nil then log('learned: type %s heats %.1f a shot%s', d.tid, nv, wiki and string.format(' (the wiki: %s)', tostring(wiki)) or '') end
        learn('shot', d.tid, nv)
      end
    end
    o.row = { v = v, t = now, n = 0, tcool = 0 }
  end
  local take = (o.err or 0) * math.min(1, dt / 0.25)
  o.sim, o.err = o.sim + take, (o.err or 0) - take
  o.presses = presses
  -- (the band: past its edge for a moment first, as a value may be on its way)
  if o.h_last_t and now - o.h_last_t > 0.3 then
    local lo, hi = o.h_last - tol - 1, o.h_last + tol + 1
    if o.sim < lo or o.sim > hi then
      o.edge_t = o.edge_t or now
      if now - o.edge_t > 0.35 then o.sim = math.max(lo, math.min(hi, o.sim)) end
    else
      o.edge_t = nil
    end
  end
  o.sim = math.max(0, math.min(top, o.sim))
  d.value = math.max(0, o.sim - rest)
end
N.heat_model, N.heat_tol = heat_model, heat_tol
end)()

-- Integrated HUD frame coordinator. NarrowHUD's picker/normaliser remain above.
local next_scan,next_read,shown,world_seen=0,0,nil,nil
local check_i,checked=1,false
if chef.weapon_menu_down then N.keys.weapon_menu={down=chef.weapon_menu_down}end
local function wipe(t)for k in pairs(t)do t[k]=nil end end
local function reset_world()
 for _,t in ipairs({N.objs,N.queue,N.queue_2,N.queue_b,N.checked,N.pack_vals,N.distrust,N.av_refs,N.av_said})do wipe(t)end
 N.me.player,N.me.avatar=nil,nil
 wipe(N.hand);N.swap.used,N.swap.from=true,nil
 N.seat.goid,N.seat.gun,N.seat.pose_since=nil,nil,nil
 N.pack_prev=nil;shown=nil;next_scan=0;next_read=0
end
function M.avatar()return N.me.avatar end
function M.inspect()return N end -- Basic offline verification only.
function M.update()
 local now=chef.time();N.now=now;N.frame=N.frame+1
 if N.dirty_at and now>=N.dirty_at then N.dirty_at=nil;N.save_learned()end
 if N.game_build.known==false then return nil,'UNSUPPORTED BUILD'end
 local wid=chef.world_id()
 if wid~=world_seen then reset_world();world_seen=wid end
 if not chef.in_mission()then shown=nil;return nil,'NO MISSION'end
 local s,peer=N.call('session','Network.game_session'),N.call('peer','Network.peer_id')
 if s==nil or peer==nil then shown=nil;return nil,'WAIT SESSION'end
 -- Refuse types whose live field declaration does not match the supplied data.
 if not checked then
  for _=1,25 do
   local t=N.TYPES[check_i]
   if not t then checked=true;break end
   local fields=N.live_fields(t.name);local ok=fields~=nil
   if ok then for role in pairs(t.has)do
    if N.ROLE[role]and not fields[N.norm_id(N.ROLE[role].id)]then ok=false end
   end end
   t.gone=not ok;check_i=check_i+1
  end
  return nil,'CHECK FIELDS'
 end
 N.blocked.since=N.blocked.since or now
 N.classify(s)
 if now>=next_scan then next_scan=now+1;N.scan(s,peer)end
 N.read_fire_button(now);N.read_swap(now)
 if now>=next_read then
  next_read=now+.1
  if N.me.avatar and N.alive(s,N.me.avatar,N.TYPES[2])then
   -- Gate presentation after scanning, so a dead old avatar cannot prevent
   -- discovering its replacement. Seated motion state is deliberately ignored.
   local where=N.call('avatar.where','GameSession.game_object_field',s,N.me.avatar,'gls4w9b')
   local state=N.call('avatar.state','GameSession.game_object_field',s,N.me.avatar,'state')
   if(where~=nil and where~=100)or(state~=nil and state~=0)then shown=nil;return nil,'NO AVATAR'end
   N.read_av_refs(s)
  end
  local grip=N.hand_pose(s);N.watch_fire(s,grip)
  local goid=N.pick(s,grip,now)
  local hand=N.hand;local old=hand.goid and N.objs[hand.goid]
  -- Original short movement grace; no motion_enabled/seat-based HUD gate.
  if not goid and grip~=nil and not N.THROWABLE[grip]and old and old.t and old.on and not old.notmine
     and now-(N.swap.at or -100)>1 then
   hand.lost_at=hand.lost_at or now
   if now-hand.lost_at<2 then goid=hand.goid end
  elseif goid then hand.lost_at=nil end
  hand.goid,hand.grip=goid,grip
  local o=goid and N.objs[goid];local t=o and o.t and N.TYPES[o.t]
  local w=t and N.read_weapon(s,goid,t)
  shown=w and not w.gone and N.shown(s,goid,t,w,o)or nil
  if shown then
   shown.raw_fire_mode=w.fire_mode
   if not shown.kind then shown=nil end
  end
 end
 local d=shown
 if d and not N.alive(s,d.goid0,d.t0)then shown=nil;return nil,'GONE'end
 if d and d.kind=='heat'and d.o and d.o.h_last and not d.charge_anim then N.heat_model(s,d,now)
 elseif d and d.kind=='heat'and d.charge_anim and d.o and d.o.charge_t0 then
  local h=d.charge_from+(d.top_raw-d.charge_from)*math.min(1,(now-d.o.charge_t0)/d.charge_secs)
  d.value=math.max(0,h-d.rest)
 end
 return d,d and'READY'or'IDENTIFY'
end
function M.shutdown()N.save_learned();reset_world()end
return M

end
