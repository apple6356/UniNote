
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>

<title>한라대학교 컴퓨터공학과</title>

<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="title" content=" 한라대학교 컴퓨터공학과" />
<meta name="application-name" content=" 한라대학교 컴퓨터공학과">
<meta name="msapplication-tooltip" content=" 한라대학교 컴퓨터공학과">
<meta id="meta_og_title" property="og:title" content="한라대학교 컴퓨터공학과">
<meta name="description" content="한라대학교 컴퓨터공학과">
<meta property="og:description" content="한라대학교 컴퓨터공학과">

<meta name="keywords" content="한라대학교 컴퓨터공학과">
<meta name="og:type" property="og:type" content="website" />
<meta name="og:title" property="og:title" content="http://computer.halla.ac.kr" />
<meta name="og:url" property="og:url" content="http://computer.halla.ac.kr" />
<meta name="og:image" property="og:image" content="http://computer.halla.ac.kr" />
<meta name="og:description" property="og:description" content="" id="description" />

<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link rel="stylesheet" type="text/css" href="../css/basefont.css"/>
<link rel="stylesheet" type="text/css" href="../css/import.css"/>
<link rel="stylesheet" type="text/css" href="../css/layout.css?ver=20220504012723">
<link rel="stylesheet" type="text/css" href="../css/jquery-ui.css"/>
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">

<script type="text/javascript" src="../js/jquery.min.js"></script>
<script type="text/javascript" src="../js/common_process.js"></script>
<script type="text/javascript" src="../js/jquery-ui.custom.js"></script>
<script type="text/javascript" src="../js/design.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/placeholders.min.js"></script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>


<script src="../js/custom.js"></script>

<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
<script type="text/javascript">
if(!wcs_add) var wcs_add = {};
wcs_add["wa"] = "cacf298001f81";
if(window.wcs) {
wcs_do();
}
</script>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-177867598-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-177867598-1');
</script>

<script type="text/javascript">
<!--
 // Logout Timer 객체 정의
  var LogOutTimer = function() {
        var S = {
                  timer : null,
                 // 10분 
                  limit : 10 * 1000 * 60  ,
                  fnc   : function() {},
                  start : function() {
                            S.timer = window.setTimeout(S.fnc, S.limit);
                          },
                  reset : function() {
                            window.clearTimeout(S.timer);
                            S.start();
                          }

                };
         document.onmousemove = function() { S.reset(); };
        return S;
      }();

      // 로그아웃 체크시간 설정
      // 10분
      LogOutTimer.limit = 10 * 1000 * 60  ;
      // 로그아웃 함수 설정
      LogOutTimer.fnc = function() {
		location.href="/src/logout.php"
      }
      // 로그아웃 타이머 실행
      LogOutTimer.start();
		//-->
</script>

</head>


<body>
<ul id="skipToContent">
  <li><a href="#container">본문 바로가기</a></li>
  <li><a href="#gnbW">주메뉴 바로가기</a></li>
</ul>


<!-- loading -->
<div class="loading_area" id="loading_area" style="display:none">
    <div class="loader"></div>
    <div id="bg"></div>
</div>

<!-- //loading -->    <script type="text/javascript" src="../js/fullpage.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/fullpage.css" />
    <link rel="stylesheet" type="text/css" href="../css/animation.css" />
    <script type="text/javascript" src="../js/jquery.bxslider.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/jquery.bxslider.css" />
    <script type="text/javascript" src="../js/slick.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/slick.css" />

   <script>
        var slider = "";
        var slider1 = "";
        var slider2 = "";
        var slider3 = "";
        var slider4 = "";

        $(document).ready(function() {
           //fncTab(1);

            /*$('#fullpage').fullpage({
                navigation: false,
                autoScrolling: false,
                fitToSection: false,
                css3: true,
                slidesNavigation: false,
                navigationTooltips: ['', '', '', '', '', ''],
                showActiveTooltip: false,
                scrollHorizontally: false,

                afterLoad: function(origin, destination, direction) {


                    if (destination.index == 0) {
                        setTimeout(function() {
                            $("#section1").addClass("active2");
                        }, 100);


                    }

                },
                onLeave: function(origin, destination, direction) {
                    var leavingSection = this;


                    if (destination.index == 0) {
                        $("#header").removeClass("down");
                    } else {
                        $("#header").addClass("down");
                    }
                }
            });

            $("h1, .go_top").on("click", function() {
                $.fn.fullpage.moveTo(1);
            });*/

            $(window).resize(function() {

                slider1.reloadSlider();
            });


            //on first load, play the video
            $(".slider-youtube").on('init', function(event, slick, currentSlide) {
                var currentSlide, player, command;
                currentSlide = $(slick.$slider).find(".slick-current");
                player = currentSlide.find("iframe").get(0);
                command = {
                    "event": "command",
                    "func": "pauseVideo"
                };
                setTimeout(
                    function() {
                        player.contentWindow.postMessage(JSON.stringify(command), "*");
                    }, 5000);
            });
            //when new slide displays, play the video
            $(".slider-youtube").on("afterChange", function(event, slick) {
                var currentSlide, player, command;
                currentSlide = $(slick.$slider).find(".slick-current");
                player = currentSlide.find("iframe").get(0);
                command = {
                    "event": "command",
                    "func": "pauseVideo"
                };
                if (player != undefined) {
                    player.contentWindow.postMessage(JSON.stringify(command), "*");
                }
            });
            //reset iframe of non current slide
            $(".slider-youtube").on('beforeChange', function(event, slick, currentSlidee) {
                var current = $('.slick-current');
                var currentSlide, player, command;
                currentSlide = $(slick.$slider).find(".slick-current");
                player = currentSlide.find("iframe").get(0);
                command = {
                    "event": "command",
                    "func": "pauseVideo"
                };
                if (player != undefined) {
                    player.contentWindow.postMessage(JSON.stringify(command), "*");
                }
            });
            //start the slider
            $('.slider-youtube').slick({
                slidesToShow: 1,
                arrows: true,
                infinite: false,
                dots: true,
      
            });



        });

        function sdown() {
            $.fn.fullpage.moveTo(2);
        }

		window.onload = function(){
		//팝업 실행
			fncIsShow(1);
			//fncIsShow(2);
	}

	function setCookie(name, value, expiredays) {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
		document.cookie = name + '=' + escape(value) + '; path=/; expires=' + todayDate.toGMTString() + ';'
	}


	function closeWin(key, frm) {
		if (frm.chkbox.checked) {
			setCookie('maindiv' + key, 'done', 1);
		}
		document.all['maindiv' + key].style.display = 'none';
	}


	function fncIsShow(key) {

		cookiedata = document.cookie;
		if (cookiedata.indexOf('maindiv' + key + '=done') < 0) {
			document.all['maindiv' + key].style.display = '';
		} else {
			document.all['maindiv' + key].style.display = 'none';
		}

	}

	function fncTab(a) {
	   if ( a == 1 )  {
          $("#tab_no1").show();
		  $("#tab_more1").show();
		  $("#tab_no2").hide();
		  $("#tab_more2").hide();
	   } else {

          $("#tab_no1").hide();
		  $("#tab_more1").hide();
		  $("#tab_no2").show();
		  $("#tab_more2").show();

	   }

	}

	</script>

	<!-- 레이어 팝 -->
	<!--div id="maindiv1" class="main_layer_pop" style="display:none; z-index: 99999; top:100px; width:100%; max-width:600px; left:50%; transform: translateX(-50%); -webkit-transform: translateX(-50%);">
		<div class="main_layer_pop_inner">
			<div class="cell">
				<div class="pop_wrap_in" style="float:left; max-height:none;">
					<div class="main_pop_content">
						<img src="../popup/images/201118.jpg" alt=""  width="600">
					</div>
					<div class="main_pop_bottom">
						<form name="notice_form1">
							<label><input type="checkbox" name="chkbox" value="checkbox">오늘 하루 이 창을 열지 않음</label>
							<a href="javascript:void(0);" class="close" onclick="closeWin(1,notice_form1);">닫기</a>
						</form>

					</div>
				</div>
			</div>
		</div>
	</div-->
	<!-- //레이어 팝-->



    <div id="wrap" class="main_wrap">
        <!-- header -->
        <div id="header">

    <div class="in_header">
         <ul class="top_btns">

            <li><a href="https://www.instagram.com/halla__computer/" target="blank"><span class="m_topbtn"> <img src="../img/common/insta_ico.png"></span></a></li>
			<li><a href="/login/login.php"><span class="m_topbtn"> <img src="../img/common/top_user.png" alt="Logout"> 로그인</span></a></li>
</ul> 
            <h1><a href="../main/main.php"><img src="../img/common/han_logo.png" alt="한라대학교 신소재화학공학과"></a></h1>

            <div class="m_gnbW">
                <div class="m_gnb_on bt_all">
                    <div class="menu_btn">
                        <div class="line-top"></div>
                        <div class="line-middle"></div>
                        <div class="line-bottom"></div>
                    </div>
                </div>
            </div>
            <h2 class="skip">주요 서비스 메뉴</h2>
            <div id="gnbW" class="w_gnb">

                <div class="gnb">
    <ul>
       <li class="gnb02"><a href="../department/01.php"><span>학과소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../department/01.php">컴퓨터공학과 소개</a></li>
				<li class="lnb2"><a href="../department/02.php">오시는 길</a></li>
            </ul>
        </li>

        <li class="gnb03"><a href="../prointro/01.php"><span>교수진소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../prointro/01.php">교수진소개</a></li>
            </ul>
        </li>

		<li class="gnb06"><a href="../edu/01.php"><span>학사안내</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../edu/01.php">교육목표</a></li>
                <li class="lnb2"><a href="../edu/02.php">교과안내</a></li>
				<li class="lnb5"><a href="../edu/05.php">졸업 후 진로</a></li>
				<li class="lnb3"><a href="../edu/03.php">학사일정</a></li>
				<li class="lnb4"><a href="../edu/04.php">E-행정실</a></li>
            </ul>
        </li>

		<li class="gnb04"><a href="../comm/02.php"><span>게시판</span></a>
            <ul class="sub_menu">
                <!--<li class="lnb1"><a href="../comm/01.php">강의자료</a></li>-->
                <li class="lnb2"><a href="../comm/02.php">포토갤러리</a></li>
                <li class="lnb3"><a href="https://www.instagram.com/halla__computer/" target="blank">학과 SNS<i></i></a></li>
				<li class="lnb5"><a href="../comm/05.php">학과 Q&A</a></li>
				<li class="lnb6"><a href="../comm/06.php">자유게시판</a></li>
				<!--<li class="lnb7"><a href="../comm/07.php">동문소식</a></li>-->
            </ul>
        </li>

        <li class="gnb01"><a href="/notice/01.php"><span>공지사항</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="/notice/01.php">학과공지</a></li>
				<li class="lnb2"><a href="/notice/02.php">동문소식</a></li>
                <li class="lnb3"><a href="/notice/03.php">취업정보</a></li>
            </ul>
        </li>


    </ul>
</div>
            </div>
    </div>

    <div id="gnb_bar" style="height:340px;">
    <div class="gnb">
    <ul>
       <li class="gnb02"><a href="../department/01.php"><span>학과소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../department/01.php">컴퓨터공학과 소개</a></li>
				<li class="lnb2"><a href="../department/02.php">오시는 길</a></li>
            </ul>
        </li>

        <li class="gnb03"><a href="../prointro/01.php"><span>교수진소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../prointro/01.php">교수진소개</a></li>
            </ul>
        </li>

		<li class="gnb06"><a href="../edu/01.php"><span>학사안내</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../edu/01.php">교육목표</a></li>
                <li class="lnb2"><a href="../edu/02.php">교과안내</a></li>
				<li class="lnb5"><a href="../edu/05.php">졸업 후 진로</a></li>
				<li class="lnb3"><a href="../edu/03.php">학사일정</a></li>
				<li class="lnb4"><a href="../edu/04.php">E-행정실</a></li>
            </ul>
        </li>

		<li class="gnb04"><a href="../comm/02.php"><span>게시판</span></a>
            <ul class="sub_menu">
                <!--<li class="lnb1"><a href="../comm/01.php">강의자료</a></li>-->
                <li class="lnb2"><a href="../comm/02.php">포토갤러리</a></li>
                <li class="lnb3"><a href="https://www.instagram.com/halla__computer/" target="blank">학과 SNS<i></i></a></li>
				<li class="lnb5"><a href="../comm/05.php">학과 Q&A</a></li>
				<li class="lnb6"><a href="../comm/06.php">자유게시판</a></li>
				<!--<li class="lnb7"><a href="../comm/07.php">동문소식</a></li>-->
            </ul>
        </li>

        <li class="gnb01"><a href="/notice/01.php"><span>공지사항</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="/notice/01.php">학과공지</a></li>
				<li class="lnb2"><a href="/notice/02.php">동문소식</a></li>
                <li class="lnb3"><a href="/notice/03.php">취업정보</a></li>
            </ul>
        </li>


    </ul>
</div>
    </div>

</div>
<!-- m gnb -->

<div id="slide_menu_wrap" class="slide_menu_wrap ">
    <div class="slide_menu_inner">
         <ul class="top_btns">

            <li><a href="https://www.instagram.com/halla__computer/" target="blank"><span class="m_topbtn"> <img src="../img/common/insta_ico.png"></span></a></li>
			<li><a href="/login/login.php"><span class="m_topbtn"> <img src="../img/common/top_user.png" alt="Logout"> 로그인</span></a></li>
</ul> 
            <div class="gnb">
    <ul>
       <li class="gnb02"><a href="../department/01.php"><span>학과소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../department/01.php">컴퓨터공학과 소개</a></li>
				<li class="lnb2"><a href="../department/02.php">오시는 길</a></li>
            </ul>
        </li>

        <li class="gnb03"><a href="../prointro/01.php"><span>교수진소개</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../prointro/01.php">교수진소개</a></li>
            </ul>
        </li>

		<li class="gnb06"><a href="../edu/01.php"><span>학사안내</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="../edu/01.php">교육목표</a></li>
                <li class="lnb2"><a href="../edu/02.php">교과안내</a></li>
				<li class="lnb5"><a href="../edu/05.php">졸업 후 진로</a></li>
				<li class="lnb3"><a href="../edu/03.php">학사일정</a></li>
				<li class="lnb4"><a href="../edu/04.php">E-행정실</a></li>
            </ul>
        </li>

		<li class="gnb04"><a href="../comm/02.php"><span>게시판</span></a>
            <ul class="sub_menu">
                <!--<li class="lnb1"><a href="../comm/01.php">강의자료</a></li>-->
                <li class="lnb2"><a href="../comm/02.php">포토갤러리</a></li>
                <li class="lnb3"><a href="https://www.instagram.com/halla__computer/" target="blank">학과 SNS<i></i></a></li>
				<li class="lnb5"><a href="../comm/05.php">학과 Q&A</a></li>
				<li class="lnb6"><a href="../comm/06.php">자유게시판</a></li>
				<!--<li class="lnb7"><a href="../comm/07.php">동문소식</a></li>-->
            </ul>
        </li>

        <li class="gnb01"><a href="/notice/01.php"><span>공지사항</span></a>
            <ul class="sub_menu">
                <li class="lnb1"><a href="/notice/01.php">학과공지</a></li>
				<li class="lnb2"><a href="/notice/02.php">동문소식</a></li>
                <li class="lnb3"><a href="/notice/03.php">취업정보</a></li>
            </ul>
        </li>


    </ul>
</div>
    </div>
    <div class="all_close">
        <div class="menu_btn is-open">
            <div class="line-top"></div>
            <div class="line-middle"></div>
            <div class="line-bottom"></div>
        </div>
    </div>
</div>
<!-- //m gnb -->


<!-- //m gnb -->
<script>
    $(document).ready(function() {
       

        $(".w_gnb .gnb > ul, #gnb_bar").mouseenter(function() {
            var item = $(this);
            $("#gnb_bar").stop().slideDown(200);

            //$(".w_gnb .sub_menu").stop().slideDown(200);
        });
        $(".w_gnb .gnb > ul, #gnb_bar").mouseleave(function() {
            var item = $(this);
            $("#gnb_bar").stop().slideUp(200);

            //$(".w_gnb .sub_menu").stop().slideUp(200);
        });
    });

</script>
            <!-- //header -->
            <div id="fullpage">
                <!-- container -->
                <div id="container" class="main_content new">
                    <div id="section1" class=" section fp-auto-height">
                        <div class="mainVisualWrap">
                            <div class="mainVisual">

								<!-- 슬라이드 이미지 01 -->
								<div class="mainVisual01">
									<img src="../img/main/mainVisual01.jpg" alt="">
									<div class="mainVisualInner">
										<div class="txt01">
											<p class="tit">원주한라대 컴퓨터공학과</p>
											<p style="line-height:1.4;">선진국 수준의 새로운 지식창출 우수한 고급인력 양성</p>
										</div>
										<a href="/department/01.php" class="goto_apply">바로가기</a>
									</div>
								</div>
								<!-- //슬라이드 이미지 01 -->

								<!-- 슬라이드 이미지 02 -->
								<div class="mainVisual02">
									<img src="../img/main/mainVisual02.jpg" alt="">
									<div class="mainVisualInner">
										<div class="txt01">
											<p class="tit">원주한라대 컴퓨터공학과</p>
											<p style="line-height:1.4;">선진국 수준의 새로운 지식창출 우수한 고급인력 양성</p>
										</div>
										<a href="/department/01.php" class="goto_apply">바로가기</a>
									</div>
								</div>
								<!-- //슬라이드 이미지 02 -->

                            </div>
                        </div>
                    </div>					

                    <div id="section2" class="section fp-auto-height padd_no">
                        <div class="innerWrap">
								<div class="inner_Left">
									<h3 class="section02_lt">공지사항</h3><a class="ab" href="/notice/01.php"></a>

<style type="text/css">
.ui-tabs{padding:0;zoom:1;}
.ui-tabs .ui-tabs-nav{padding:0;border-radius:0;border:none;background:transparent;}
.ui-tabs .ui-tabs-nav li{width:50%;height:50px;margin:0;top:0;border-radius:0;border:none;}
.ui-tabs .ui-tabs-nav li a{padding:0;width:100%;height:100%;text-align:center;line-height:50px;outline:none}
.ui-tabs .ui-tabs-panel{padding:0;padding:40px 40px;border:1px solid #ccc;margin-top:-1px;height: 210px;}
.ui-tabs .ui-tabs-panel li{position:relative;margin-top:20px;padding-left:10px;}
.ui-tabs .ui-tabs-panel li strong{font-weight: 500;}
.ui-tabs .ui-tabs-panel li a{color:#555555;}
.ui-tabs .ui-tabs-panel li:before{content:"";display:block;position:absolute;top:50%;margin-top:-1px;left:0;width:3px;height:3px;background-color:#efeeee;}
.ui-tabs .ui-tabs-panel li:first-child{margin-top:0;}
.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active{background:transparent;}
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{background:#efeeee;}
.ui-tabs .ui-state-default a, 
.ui-tabs .ui-state-default a:link, 
.ui-tabs .ui-state-default a:visited{background:transparent; border-bottom: 1px solid #ccc; border-top: 3px #efeeee solid; margin-top: -3px;}

.ui-tabs .ui-tabs-nav{padding:0;}
.ui-tabs{border:none;border-radius:0;height:310px;margin-top:3rem;border-top: 0px;}
.ui-tabs .ui-tabs-active{background-color:#fff;}
.ui-tabs .ui-state-default.ui-tabs-active a{font-weight: 600; color: #000; border: 1px solid #ccc; border-bottom: 0px; width: calc(100% - 2px);border-top: 3px solid #3b319a; margin-top: -3px; font-size: 19px;}
.ui-tabs .ui-state-default.ui-tabs-active svg{display:block;}
.ui-tabs .ui-state-default a{color:#666;font-weight:400;}
.ui-tabs .ui-state-default svg{display:none;margin-left:55px;}
</style>

												<div id="tabs">
													<ul>
														<li><a href="#tabs-1">학과공지</a></li>
														<li><a href="#tabs-2">자유게시판</a></li>
													</ul>
													<div id="tabs-1">
														<ul>
														 														<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070854"> 만도 소프트웨어전공 차년도 운영을 위한 참여학생 모집 설명회 개최</a></strong>
														</li>
																												<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070855"> 2022-1학기 컴퓨터공학과 중간고사 시간표</a></strong>
														</li>
																												<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070857"> 2022-1학기 ICT융합공학부 & 전기전자공학과  중간고사 시간표</a></strong>
														</li>
																												<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070856"> 2022-1학기 정보통신소프트웨어학과 중간고사 시간표</a></strong>
														</li>
																												<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070858"> IPP 일학습병행 참여학생 모집(전기전자,정보통신) </a></strong>
														</li>
																												<li> 
														  <strong class="txt_t">
														  <a href="/notice/01.php?admin_mode=read&no=3070860"> 2022학년도 1학기 ICT융학공학부 전기.전자 전공 시간표 공지</a></strong>
														</li>
														  
													   </ul>
													</div>
													<div id="tabs-2">
														<ul>
														   

														   </ul>
													</div>
											</div> <!--  //inner_Left  -->

													<!--ul class="ai_bbo_ico">
														<li><a href="#"><span class="ico"><img src="../img/main/main_ic01.png" alt=""></span><strong>학과설명</strong></a></li>
														<li><a href="#"><span class="ico"><img src="../img/main/main_ic02.png" alt=""></span><strong>학사일정</strong></a></li>
														<li><a href="#"><span class="ico"><img src="../img/main/main_ic03.png" alt=""></span><strong>Q&A</strong></a></li>
														<li><a href="#"><span class="ico"><img src="../img/main/main_ic04.png" alt=""></span><strong>오시는길</strong></a></li>
													</ul-->
										</div>



								
								<div class="inner_right">
								<h3 class="section02_rt">포토갤러리</h3><a class="ab" href="/comm/02.php"></a>

								 <div class="photo-slide">
									<div class="cort-bx">
										<div class="pag"></div>
										<a href="#" class="stop on"></a>
										<a href="#none" class="play"></a>
									</div>

								<div class="slide-bx">
									<div class="swiper-wrapper">	
									    
						
									</div>
								</div>
							</div>
								
								</div>
								<!--inner_right-->
				</div>
                        <div class="event_ban_wrap">
                            <div class="inner">
                                <h3 class="mb_tit pt50 item item_up nth-child-1">학사안내</h3>
                                <ul class="ev_ban_list item item_up nth-child-2">
                                    <li>
                                        <a href="/edu/01.php">
                                            <dl>
                                                <dd><p class="txt_t" >교육목표</p>
                                                    <p class="txt_">사회맞춤형 창의융합 실무인재 양성</p>
                                                </dd>
                                            </dl>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="/edu/02.php">
                                            <dl>
                                                <dd><p class="txt_t">교과안내</p>
                                                    <p class="txt_">컴퓨터공학과 교육과정표</p>
                                                </dd>
                                            </dl>
                                        </a>
                                    </li>
									<li>
                                        <a href="/edu/03.php">
                                            <dl>
                                                <dd><p class="txt_t" >학사일정</p>
                                                    <p class="txt_">컴퓨터공학과 학사일정 안내</p>
                                                </dd>
                                            </dl>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="/edu/04.php">
                                            <dl>
                                                <dd><p class="txt_t">E-행정실</p>
                                                    <p class="txt_">컴퓨터공학과 행정 공지 게시판</p>
                                                </dd>
                                            </dl>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>

                    </div>



					<!-- 취업공고 ->
                    <div id="section3" class="section fp-auto-height">
                        <div class="inner">
                            <div class="pr">
                                <h3 class="mb_tit item item_up nth-child-1">
								<span style=" color: #ffffff;" >채용정보</span></h3>
                                <div class="main_companiesW item item_up nth-child-2">
                                    <ul class="main_companies ">
									    

                                    </ul>
                                    <p id="board_l1" class="bx_bt"></p>
                                    <p id="board_r1" class="bx_bt"></p>
                                </div>
                                <p class="more item item_left nth-child-1"><a href="/notice/02.php"><span>전체보기</span></a></p>
                            </div>
                        </div>

                    </div><!--section03_취업공고end-->

                    <div id="section4" class="section fp-auto-height" style="padding:0px;">
                        <div class="inner">
						
							<div class="banner left">
								<i><img src="../img/main/banner_left_ico.png" alt=""></i>
								<b>졸업 후 진로</b>
								<p>Career after graduation</p>
								<div class="btn_page"><a href="/edu/05.php">바로가기<i></i></a></div>
							</div>

							<div class="banner right">
								<i><img src="../img/main/banner_right_ico.png" alt=""></i>
								<b>학과 Q&A</b>
								<p>Department Q&A</p>
								<div class="btn_page"><a href="/comm/05.php">바로가기<i></i></a></div>
							</div>

							<ul class="ai_bbo_ico">
								<li><a href="http://www.halla.ac.kr/mbs/kr/intro/intro.html" target="_blank">
									<span class="ico"><img src="../img/main/main_ic00.png" alt=""></span>
									<strong>본교사이트 <span>바로가기</span><i></i></strong>
								</a></li>
								<li><a href="https://job.halla.ac.kr/" target="_blank">
									<span class="ico"><img src="../img/main/family_care.png" alt=""></span>
									<strong>한라FAMILYCARE <span>바로가기</span><i></i></strong>
								</a></li>
								<li><a href="http://lib.halla.ac.kr" target="_blank">
									<span class="ico"><img src="../img/main/library.png" alt=""></span>
									<strong>한라대 전자도서관 <span>바로가기</span><i></i></strong>
								</a></li>
								<li><a href="http://dorm.halla.ac.kr" target="_blank">
									<span class="ico"><img src="../img/main/dorm.png" alt=""></span>
									<strong>한라대 학생생활관 <span>바로가기</span><i></i></strong>
								</a></li>
							</ul>

                        </div>
                    </div>
                    </div>



                    <!-- footer-->
                    <div id="footerW">
    <div id="footer">
        
        <div class="addressW">
            <address><span>강원도 원주시 한라대길 28 한라대학교 컴퓨터공학과 [우] 26404</span> <span>TEL : (033) 760-1313</span> <span>FAX : (033) 760-1314</span><br>
			</address>
            
            <div class="familySite">
                <ul>
                    <li><a href="https://www.halla.ac.kr/mbs/kr/subview.jsp?id=kr_090200000000" target="blank"><b>개인정보취급방침</b></a></li>
                    <li><a href="http://www.halla.ac.kr/mbs/kr/subview.jsp?id=kr_090202000000" target="blank">영상정보처리기기 운영ㆍ관리 방침</a></li>
                    <li><a href="https://www.halla.ac.kr/mbs/kr/subview.jsp?id=kr_090300000000"	target="blank">이메일무단수집거부</a></li>
                </ul>
            </div>
			<p class="copy">COPYRIGHT (c) Halla University. All rights Reserved.</p>

            <p class="go_top"><a href="javascript:void(0);" onclick="MoveTop(); return false;"><img src="../img/common/bt_top.png" alt="top"></a></p>
        </div>
    </div>
</div>




<div id="black"></div>
                        <!-- //footer-->


                </div>
                <!-- //container -->


            </div>


    </div>
    <script src="../js/jquery.malihu.PageScroll2id.js?ver=200813" charset="utf-8"></script>

    <script>
        (function($) {
            $(window).load(function() {
                $("#navigation a").mPageScroll2id({
                    offset: 88
                });

                /*$(".item a").on("click touchend", function(e) {
                var el = $(this);
                var link = el.attr("href");
                window.location = link;
            });*/


            });
        })(jQuery);		

		   $("#tabs").tabs();
						
			var mainVSlider = $(".mainVisual").bxSlider({
				mode: 'fade',
				speed: 500,
				pause: 6000,
				slideHeight: '430px',
				auto: true,
				maxSlides: 1,
				slideMargin: 0,
				caption: false,
				pager: true,
				autoHover: true,
				autoControls: false,
				controls: false,
				adaptiveHeight: false,
			});
			

            slider1 = $('.main_companies').bxSlider({
                minSlides: 2,
                maxSlides: 4,
                infiniteLoop: true,
                slideWidth: '300px',
                moveSlides: 1,
                pager: false,
                auto: false,
                slideMargin: 0,
                nextSelector: '#board_r1',
                prevSelector: '#board_l1',
                nextText: '<img src="../img/main/slide_r2.gif">',
                prevText: '<img src="../img/main/slide_l2.gif">',
            });
				
			var photoSlide = new Swiper('.photo-slide .slide-bx', {
				speed: 800,
				loop:true,
				spaceBetween: 30,
				autoplay: {
					delay:5000,
					disableOnInteraction: false,
				},        
				pagination: {
					el: '.inner_right .pag',
					clickable: true,
					type: 'fraction',
					
				},
			});  

			$(".inner_right .cort-bx .stop").click(function() {
				photoSlide.autoplay.stop();
				$(this).removeClass("on");
				$(".inner_right .cort-bx .play").addClass("on");
			});  

			$(".inner_right .cort-bx .play").click(function() {
				photoSlide.autoplay.start();
				$(this).removeClass("on");
				$(".inner_right .cort-bx .stop").addClass("on");
			}); 
    </script>
    </body>

    </html>
