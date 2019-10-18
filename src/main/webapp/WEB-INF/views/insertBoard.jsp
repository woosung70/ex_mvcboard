<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새글등록</title>
<script src="resources/jQuery/jquery-3.4.1.min.js"></script>
</head>
<body>
	<h1>글 쓰기</h1>
	<hr>
	<form id="frm" name="frm" action="insertBoard.do" method="post" enctype="multipart/form-data">
		<table border="1">
			<tr>
				<td bgcolor="orange" width="70">제목</td>
				<td align="left">
					<input type="text" id="title" name="title" />
				</td>
			</tr>
			<tr>
				<td bgcolor="orange">작성자</td>
				<td align="left">
					<input type="text" id="writer" name="writer" size="10" />
				</td>
			</tr>
			<tr>
				<td bgcolor="orange">내용</td>
				<td align="left">
					<textarea id="content" name="content" cols="40" rows="10"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="file" name="uploadFile" id="uploadFile" multiple>
					<div id="preview"></div>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button type="button" name="write" id="write" >쓰기</button>
				</td>
			</tr>
		</table>
	</form>

	<hr>
	<a href="getBoardList.do">글 목록 가기</a>
</body>
<script type="text/javascript">
	$(document).ready(function (e){
		
		$('#write').click(function(){
				var frmArr = ["title","writer","content"];

				//입력 값 널 체크
				for(var i=0;i<frmArr.length;i++){
					//alert(arr[i]);
					if($.trim($('#'+frmArr[i]).val()) == ''){
						alert('빈 칸을 모두 입력해 주세요.');
						$('#'+frmArr[i]).focus();
						return false;
					}
				}

				//전송
				$('#frm').submit();
		});
		
		$("input[type='file']").change(function(e){

			//div 내용 비워주기
			$('#preview').empty();

			var files = e.target.files;
			var arr =Array.prototype.slice.call(files);
			
			//업로드 가능 파일인지 체크
			for(var i=0;i<files.length;i++){
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
			}
			
			preview(arr);
			
			
		});//file change
		
		function checkExtension(fileName,fileSize){

			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 20971520;	//20MB
			
			if(fileSize >= maxSize){
				alert('파일 사이즈 초과');
				$("input[type='file']").val("");	//파일 초기화
				return false;
			}
			
			if(regex.test(fileName)){
				alert('업로드 불가능한 파일이 있습니다.');
				$("input[type='file']").val("");	//파일 초기화
				return false;
			}
			return true;
		}
		
		function preview(arr){
			arr.forEach(function(f){
				
				//파일명이 길면 파일명...으로 처리
				var fileName = f.name;
				if(fileName.length > 10){
					fileName = fileName.substring(0,7)+"...";
				}
				
				//div에 이미지 추가
				var str = '<div style="display: inline-flex; padding: 10px;"><li>';
				str += '<span>'+fileName+'</span><br>';
				
				//이미지 파일 미리보기
				if(f.type.match('image.*')){
					var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
					reader.onload = function (e) { //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
						//str += '<button type="button" class="delBtn" value="'+f.name+'" style="background: red">x</button><br>';
						str += '<img src="'+e.target.result+'" title="'+f.name+'" width=100 height=100 />';
						str += '</li></div>';
						$(str).appendTo('#preview');
					} 
					reader.readAsDataURL(f);
				}else{
					str += '<img src="/resources/img/fileImg.png" title="'+f.name+'" width=100 height=100 />';
					$(str).appendTo('#preview');
				}
			});//arr.forEach
		}
		
		/* //동적태그 이벤트 걸기  
		$(document).on('click','.delBtn',function(){
			
			//삭제한 파일의 파일 이름 찾기서 지우기
			var fileName = $(this)[0].value;
			for(var i=0;i<$("input[type='file']")[0].files.length;i++){
				if(fileName==$("input[type='file']")[0].files[i].name){
					//$("input[type='file']")[0].files[i].remove();
					console.log($("input[type='file']")[0].files);
					//$("input[type='file']")[0].files[i].splice(0,1);
					//보안상의 이유로 file을 직접 컨트롤 할 수 없음. 다른 변수를 만들어서 컨트롤
					var aa= Array.from($("input[type='file']")[0].files);
					console.log(aa.splice(0,1));
					break;
				}
			} 

			//div 삭제
			var targetDiv=$(this).closest('div');
			targetDiv.remove();
		}); */
	});
</script>
</html>