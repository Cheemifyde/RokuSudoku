sub init()
	m.review_video = m.top.findNode("review_video")
	m.review_row = m.top.findNode("review_row")
    m.top.observeField("review_finished", "focusReview")
	m.top.observeField("visible", "onVisibleChange")
	m.top.observeField("review_selected", "onReviewSelected")
end sub

sub onVisibleChange()
  if m.top.visible = true then
	playReviewAnimation()
  end if
end sub


sub playReviewAnimation()
	review_content = CreateObject("roSGNode", "ContentNode")
	review_content.url = "http://192.168.43.99:8080/videos/review-video.mp4"
	review_content.streamformat = "mp4"
	m.review_video.content = review_content
	m.review_video.control ="prebuffer"
	m.review_video.visible = true
	m.review_video.setFocus(true)
	m.review_video.control = "play"
end sub

sub focusReview()
	if m.top.getField("review_finished") = "finished" then
    	m.review_video.visible = false
		m.review_video.setFocus(false)
		m.review_row.content = CreateObject("roSGNode", "ReviewSelectContent")
		m.review_row.visible = true
    	m.review_row.setFocus(true)
	end if
end sub

function onKeyEvent(key, press) as Boolean
	if key = "back" and press
		m.review_row.visible = false
	end if
end function

sub onItemSelect()
  ? ;m.review_row.content.getChild(0).getChild(m.review_row.rowItemFocused[1]).url
  m.top.selected_review_content = m.review_row.content.getChild(0).getChild(m.review_row.rowItemFocused[1]).url
  m.review_row.visible = false
end sub