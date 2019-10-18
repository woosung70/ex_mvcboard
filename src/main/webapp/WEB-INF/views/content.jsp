<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>글 상세</title>
	<script src="resources/jQuery/jquery-3.4.1.min.js"></script>
</head>
<body>
	<h1>글 상세</h1>
	<hr>
	<form id="frm" action="modify.do" method="get">
		<input name="idx" type="hidden" value="${board.idx}" />
		<table border="1">
			<tr>
				<td bgcolor="orange" width="70">제목</td>
				<td align="left">${board.title }</td>
			</tr>
			<tr>
				<td bgcolor="orange">작성자</td>
				<td align="left">${board.writer }</td>
			</tr>
			<tr>
				<td bgcolor="orange">내용</td>
				<td align="left"><textarea id="content" name="content" cols="40" rows="10" readonly="readonly">${board.content }</textarea></td>
			</tr>
			<tr>
				<td bgcolor="orange">등록일</td>
				<td align="left"><fmt:formatDate value="${board.regDate }" pattern="yyyy-MM-dd"/></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<h3><b>첨부파일</b></h3>
					<div id="preview"></div>
				</td>
			</tr>
			<tr>
				<td bgcolor="orange">조회수</td>
				<td align="left">${board.cnt }</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" value="글 수정" /></td>
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
		
		//첨부파일 다운로드
		(function(){
			var bno='<c:out value="${board.idx}"/>';
			$.getJSON("/getAttachList", {bno: bno}, function(arr){

				var arrLength = arr.length;
				//첨부파일이 없을 경우
				if(arrLength == 0){
					console.log(arr.length);
					var str = "<span>첨부파일 없음</span>";
					$(str).appendTo('#preview');
				}
				$(arr).each(function(i, attach){
					
					var imgPath = '/img/'+attach.path+'/'+attach.uuid;
					//파일명이 길면 파일명...으로 처리
					var fileName = attach.fileName;
					if(fileName.length > 10){
						fileName = fileName.substring(0,7)+"...";
					}
					
					//div에 첨부파일 이미지 추가
					var fileCallpath = encodeURIComponent(attach.path+"/"+attach.uuid);
					var origin = encodeURIComponent(attach.fileName);
					console.log(fileCallpath);
					var str = '<div style="display: inline-flex; padding: 10px;"><li>';
					str += '<a href="/download?fileName='+fileCallpath+'&origin='+origin+'">'+fileName+'</a><br>';
					str += '<img src="'+imgPath+'" title="'+attach.fileName+'" title="'+attach.fileName+'" onerror="this.src=\'/resources/img/fileImg.png\'" width=100 height=100 />';
					str += '</li></div>';
					$(str).appendTo('#preview');
					
				});//arr each
			});	//end getJSON
		})(); //end function
		
	});
	
</script>
</html>