<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>글 수정</title>
	<script src="resources/jQuery/jquery-3.4.1.min.js"></script>
</head>
<body>
	<h1>글 수정</h1>
	<hr>
	<form id="frm" action="updateBoard.do" method="post" enctype="multipart/form-data">
		<input name="seq" type="hidden" value="${board.idx}" />
		<table border="1">
			<tr>
				<td bgcolor="orange" width="70">제목</td>
				<td align="left"><input id="title" name="title" type="text"
					value="${board.title }" /></td>
			</tr>
			<tr>
				<td bgcolor="orange">작성자</td>
				<td align="left">${board.writer }</td>
			</tr>
			<tr>
				<td bgcolor="orange">내용</td>
				<td align="left"><textarea id="content" name="content" cols="40" rows="10">${board.content }</textarea></td>
			</tr>
			<tr>
				<td bgcolor="orange">등록일</td>
				<td align="left"><fmt:formatDate value="${board.regDate }" pattern="yyyy-MM-dd"/></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="file" name="uploadFile" id="uploadFile" multiple>
					<div id="preview"></div>
				</td>
			</tr>
			<tr>
				<td bgcolor="orange">조회수</td>
				<td align="left">${board.cnt }</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button" id="modify" value="글 수정" /></td>
			</tr>
		</table>
	</form>
	<hr>
	<a href="writeBoard.do">글 쓰기</a>&nbsp;&nbsp;&nbsp; 
	<a href="deleteBoard.do?idx=${board.idx }">글 삭제</a>&nbsp;&nbsp;&nbsp;
	<a id="list" href="getBoardList.do">글 목록</a>
</body>
<script type="text/javascript">
	$(document).ready(function (e){
		
		//수정하기 버튼
		$('#modify').click(function(){
			var frmArr = ["title","content"];

			$('#frm').append("<input type='hidden' name='pageNum' value='<c:out value='${cri.pageNum }'/>'>");
			$('#frm').append("<input type='hidden' name='amount' value='<c:out value='${cri.amount }'/>'>");
			
			//입력 값 널 체크
			for(var i=0;i<frmArr.length;i++){
				//alert(arr[i]);
				if($.trim($('#'+frmArr[i]).val()) == ''){
					alert('빈 칸을 모두 입력해 주세요. -'+frmArr[i]);
					$('#'+frmArr[i]).focus();
					return false;
				}
			}
			//전송
			$('#frm').submit();
		});
		
		//글 목록
		$('#list').click(function(e){
			e.preventDefault();
			var $form = $('<form></form>');
			$form.attr('action','getBoardList.do');
			$form.attr('method','get');
			$form.appendTo('body');
			
			$form.append("<input type='hidden' name='pageNum' value='<c:out value='${cri.pageNum}'/>'>");
			$form.append("<input type='hidden' name='amount' value='<c:out value='${cri.amount}'/>'>");
			$form.submit();
		});
		
		//첨부파일
		(function(){
			var bno='<c:out value="${board.idx}"/>';
			console.log(bno);
			console.log('------');
			$.getJSON("/getAttachList", {bno: bno}, function(arr){
				console.log(arr);
				
				$(arr).each(function(i, attach){
					
					var imgPath = '/img/'+attach.path+'/'+attach.uuid;
					
					//div에 첨부파일 이미지 추가
					var str = '<div style="display: inline-flex; padding: 10px;"><li>';
					str += '<span>'+attach.fileName+'</span><br>';
					str += '<img src="'+imgPath+'" title="'+attach.fileName+'" onerror="this.src=\'/resources/img/fileImg.png\'" width=100 height=100 />';
					str += '</li></div>';
					$(str).appendTo('#preview');
					
				});//arr each
			});	//end getJSON
		})(); //end function
		
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
		
	});
</script>
</html>