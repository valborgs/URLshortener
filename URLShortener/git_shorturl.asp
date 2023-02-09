<!DOCTYPE html>
<html><head>
<title> 단축 링크 생성기 </title>
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, maximum-scale=1, minimum-scale=1" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta charset="utf-8">

<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</head>
<body>
<div class="container">
		<h1>단축 링크 생성기</h1>
		<div align="right">
		*랜덤링크가 아닌 ID를 부여한 list링크일때 대량으로 변환이 필요한 경우*<br>
		*일일 2만5천건까지 가능*<br>
		</div>
		<br>
    <div class="row">
        <div class="col">
            <form>
            <div class="form-floating">
                <textarea class="form-control" placeholder="단축할 주소 입력(줄바꿈 기준 여러개 가능)" id="floatingTextarea1" style="height: 500px"></textarea>
                <label for="floatingTextarea1">단축할 주소 입력(줄바꿈 기준 여러개 가능)</label>
            </div>
            </form>
            <br>
            <input type="button" class="btn btn-success" id="submitbtn" onclick="makeShortUrl();" value="생성">
            <div class="spinner-border text-primary" style="display:none;" role="status">
            <span class="visually-hidden">Loading...</span>
            </div>
        </div>
        <div class="col">
            <div class="form-floating">
                <textarea class="form-control" placeholder="결과" id="floatingTextarea2" style="height: 500px" readonly></textarea>
                <label for="floatingTextarea2">결과</label>
            </div>
            <br>
            <input type="button" class="btn btn-danger" id="removebtn" onclick="removeUrl();" value="초기화">
        </div>
    </div>
    <br>
    <br>
    <br>
    <br>
    <br>
		<div align="right">
		*네이버 단축URL API : https://developers.naver.com/products/service-api/shortenurl/shortenurl.md*
		</div>
</div>
<br>

<script>

function makeShortUrl(){
    $(".spinner-border").show();
    var dt = "links="+$("#floatingTextarea1").val().replace(/\n/g,",").replace(/&/g,"%26");
    callUrlAPI(dt);
}

function showResult(res){
    var jsondata = JSON.parse(res);
    var resultt="";
    for(i=0;i<jsondata.length;i++){
        resultt += "," + jsondata[i].result.url
    }
    resultt=(","+resultt).replace(",,","");
    resultt=resultt.replace(/,/g,"\n");
    $("#floatingTextarea2").val(resultt);
}

function callUrlAPI(dt){
	$.ajax({
		url : "./naver_shorturl_api.asp",
		type: "post",
		data: dt,
		dataType: "text",
		success : function(res){
			showResult(res);
			$(".spinner-border").hide();
		},
		error : function(msg, status, thr){
			showError(msg);
		}
	});
}

function removeUrl(){
	$("#floatingTextarea1").val("");
	$("#floatingTextarea2").val("");
}

function showError(msg){
	var msgtxt="";
	switch(msg.errorCode){
		case "1403":
			msgtxt="요청 URL에 오류가 있습니다. 파라미터 이름과 파라미터 값을 확인해 주십시오."
			break;
		case "1500":
			msgtxt='서버 내부에 오류가 발생했습니다. "개발자 포럼"에 오류를 신고해 주십시오.'
			break;
		case "2403":
			msgtxt="API를 사용할 권한이 없습니다. 네이버 개발자 센터의 Application > 내 애플리케이션 메뉴에서 애플리케이션의 API 설정 탭을 클릭한 다음 단축 URL이 선택돼 있는지 확인해 보십시오."
			break;
		case "3403":
			msgtxt="단축할 원본 URL이 없는 페이지이거나 안전하지 않은 사이트입니다. 원본 URL 페이지의 상태를 점검해 주십시오."
			break;
	}
	alert(msgtxt);
}

</script>
</body>
</html>