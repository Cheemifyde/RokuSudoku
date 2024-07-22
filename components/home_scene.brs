function init()
	? "[home_scene] init"
	m.details_check = ""`
	m.video_check = ""
	m.top.backgroundColor = "0x8c52ff"
	m.top.backgroundURI = ""
	m.splash_screen = m.top.findNode("splash_screen")
	m.start_screen = m.top.findNode("start_screen")
	m.category_select_screen = m.top.findNode("category_select_screen")
	m.content_select_screen = m.top.findNode("content_select_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.videoplayer = m.top.findNode("videoplayer")
	m.error_dialog = m.top.findNode("error_dialog")
	m.wishlist_screen = m.top.findNode("wishlist_screen")
	m.review_screen = m.top.findNode("review_screen")
	initializeVideoPlayer()

	m.splash_screen.observeField("splash_finished", "onSplashFinished")	
	m.start_screen.observeField("categories_button_pressed", "onCategoriesButtonPressed")
	m.start_screen.observeField("wishlist_button_pressed", "onWishlistButtonPressed")
	m.content_select_screen.observeField("content_selected", "onContentSelected")
	m.category_select_screen.observeField("category_selected", "onCategorySelected") 
	m.review_screen.observeField("review_selected", "onReviewSelected") 
	m.wishlist_screen.observeField("wish_selected", "onWishSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")
	m.details_screen.observeField("buy_button_pressed", "onBuyButtonPressed")
	m.details_screen.observeField("wish_button_pressed", "onWishButtonPressed")
	m.details_screen.observeField("review_button_pressed", "onReviewButtonPressed")

	m.splash_screen.setFocus(true)
end function

sub onReviewButtonPressed()
	m.details_screen.visible = false
	m.review_screen.visible = true
	m.review_screen.setFocus(true)
end sub

sub onWishButtonPressed()
	m.wishlist_screen.content = m.details_screen.wish_content
	m.details_screen.visible = false
	add_content = CreateObject("roSGNode", "ContentNode")
	add_content.url = "http://192.168.43.99:8080/videos/add-video.mp4"
	m.videoplayer.content = add_content
	m.videoplayer.control ="prebuffer"
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.control = "play"
	m.video_check = "details"
end sub

sub onSplashFinished(obj)
	? m.splash_screen.getField("splash_finished")
	if m.splash_screen.getField("splash_finished") = "finished" then
		m.splash_video = m.splash_screen.findNode("splash_video")
		m.splash_video.visible = false
		m.splash_screen.visible = false
		m.start_screen.setFocus(true)
		m.start_screen.visible = true
	end if
end sub

sub initializeVideoPlayer()
	m.videoplayer.EnableCookies()
	m.videoplayer.setCertificatesFile("common:/certs/ca-bundle.crt")
	m.videoplayer.InitClientCertificates()
	'set position notification to 1 second
	m.videoplayer.notificationInterval=1
	m.videoplayer.observeFieldScoped("position", "onPlayerPositionChanged")
	m.videoplayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

sub onCategorySelected(obj)
	? "http://192.168.43.99:8080/content/" + m.category_select_screen.getField("selected_category_content") + ".xml"
	m.content_select_screen.contenturi = "http://192.168.43.99:8080/content/" + m.category_select_screen.getField("selected_category_content") + ".xml"
	? m.content_select_screen.contenturi
	m.category_select_screen.visible=false
	m.content_select_screen.visible=true
end sub

sub onReviewSelected(obj)
	m.review_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	video_content = CreateObject("roSGNode", "ContentNode")
	video_content.url = m.review_screen.getField("selected_review_content")
	? "hi" ;video_content.url
	m.videoplayer.content = video_content
	m.videoplayer.control = "play"
	m.video_check = "review"
end sub


sub onContentSelected(obj)
	selected_index = obj.getData()
	? "content selected_index :";selected_index
	m.details_screen.content = m.content_select_screen.findNode("ContentPosterGrid").content.getChild(selected_index)
	m.content_select_screen.visible = false
	m.details_screen.visible = true
	m.details_check = "content"
end sub

sub onWishSelected(obj)
	selected_index = obj.getData()
	? "content selected_index :";selected_index
	m.details_screen.content = m.wishlist_screen.findNode("wish_content_grid").content.getChild(selected_index)
	m.wishlist_screen.visible = false
	m.details_screen.visible = true
	m.details_check = "wish"
end sub

sub onPlayButtonPressed(obj)
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.content = m.details_screen.content
	m.videoplayer.control = "play"
	m.video_check = "details"
end sub

sub onBuyButtonPressed(obj) 
	? "roku pay"
end sub

sub onCategoriesButtonPressed(obj)
	m.start_screen.visible = false
	m.category_select_screen.visible = true
	m.category_select_screen.setFocus(true)
end sub

sub onWishlistButtonPressed(obj)
	m.start_screen.visible = false
	m.wishlist_screen.visible = true
	m.wishlist_screen.setFocus(true)
end sub

sub onPlayerStateChanged(obj)
    state = obj.getData()
	? "onPlayerStateChanged: ";state
	if state="error"
    	showErrorDialog(m.videoplayer.errorMsg+ chr(10) + "Error Code: "+m.videoplayer.errorCode.toStr())
	else if state = "finished"
		closeVideo()
	end if
end sub

sub closeVideo()
	m.videoplayer.control = "stop"
	m.videoplayer.visible=false
	if m.video_check = "review"
		m.review_screen.visible=true
	else
		m.details_screen.visible=true
	end if
end sub

sub showErrorDialog(message)
	m.error_dialog.title = "ERROR"
	m.error_dialog.message = message
	m.error_dialog.visible=true
	m.top.dialog = m.error_dialog
end sub

function onKeyEvent(key, press) as Boolean
	? "[home_scene] onKeyEvent", key, press
	? ;m.video_check
	? ;m.details_check
	' we must capture the 'true' for press, it comes first (true=down,false=up) to keep the firmware from handling the event
	if key = "back" and press
		if m.content_select_screen.visible
			m.content_select_screen.visible=false
			m.category_select_screen.visible=true
			m.category_select_screen.setFocus(true)
			return true
		else if m.details_screen.visible and m.details_check = "content"
			m.details_screen.visible=false
			m.content_select_screen.visible=true
			m.content_select_screen.setFocus(true)
			return true
		else if m.details_screen.visible and m.details_check = "wish"
			m.details_screen.visible=false
			m.wishlist_screen.visible=true
			m.wishlist_screen.setFocus(true)
			return true
		else if m.videoplayer.visible
			closeVideo()
			return true
		else if m.category_select_screen.visible
			m.category_select_screen.visible=false
			m.start_screen.visible=true
			m.start_screen.setFocus(true)
			return true 
		else if m.wishlist_screen.visible
			m.wishlist_screen.visible=false
			m.start_screen.visible=true
			m.start_screen.setFocus(true)
			return true
		else if m.review_screen.visible
			m.review_screen.visible=false
			m.details_screen.visible=true
			m.details_screen.setFocus(true)
			return true
		end if
	end if
  return false
end function