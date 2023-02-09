<%@Language="VBScript" CODEPAGE="65001" %>
<%
  Response.charset = "utf-8"
  Response.ContentType="text/html"
  Session.CodePage=65001

  links = request("links")

  If IsNull(links) or links="" Then
    response.write "빈값"
    response.end
  Else
    links = Split(links,",")
  End If

  If Ubound(links)>0 Then
    result = ""
    For i=0 to Ubound(links)
      result=result&","&shortURL(links(i))
    Next
    result = Replace(","&result,",,","")
    response.write "["&result&"]"
  Else
    response.write "["&shortURL(links(0))&"]"
    
  End If
  response.end

  Function shortURL(encText)
    client_id = "개발자센터에서 발급받은 Client ID 값"
    client_secret = "개발자센터에서 발급받은 Client Secret 값"

    data = "url=" + Server.UrlEncode(encText) 'url인코딩 해야 쿼리스트링의 특수기호 &을 제대로 인식하는 것 같다(인코딩 전에는 &이후의 내용이 짤렸음)
    url = "https://openapi.naver.com/v1/util/shorturl?"+data

    Set xhr = Server.CreateObject("MSXML2.ServerXMLHTTP")
    xhr.open "GET", url, false
    xhr.setRequestHeader "X-Naver-Client-Id", client_id
    xhr.setRequestHeader "X-Naver-Client-Secret", client_secret
    xhr.send

    If (xhr.Status = 200) then
      postFormData = xhr.ResponseText
      shortURL = postFormData
    else
      Err.Raise 1001, "postFormData", "Post to " & url & " failed with " & xhr.Status&" message "&xhr.responseText
    End If

    set xhr = nothing 
  End Function
%>