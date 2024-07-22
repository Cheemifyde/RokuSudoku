sub init()
	m.wishlist = createObject("roSGNode", "ContentNode")
	m.wishlist_video = m.top.findNode("wishlist_video")
	m.wishlist_grid = m.top.findNode("wish_content_grid")
	m.title = m.top.findNode("wishlist_title")
    m.top.observeField("wishlist_finished", "focusWishlist")
	m.top.observeField("visible", "onVisibleChange")
	m.top.observeField("wish_selected", "onWishSelected")
end sub

sub onWishSelected()
	m.wishlist_grid.visible = false
end sub


sub onVisibleChange()
  if m.top.visible = true then
	playWishlistAnimation()
  end if
end sub

sub onContentChange(obj)
	? "onContentChange"
	boolean = true
	wish_content = obj.getData()
	for each item in m.wishlist
		if item.hdgridposterurl = wish_content.hdgridposterurl
			boolean = false
		end if
	end for
	if boolean = true then
		m.wish_content = m.wishlist.createChild("ContentNode")
		m.wish_content.hdgridposterurl = wish_content.hdgridposterurl
		m.wish_content.shortdescriptionline1 = wish_content.shortdescriptionline1
		m.wish_content.shortdescriptionline2 = wish_content.shortdescriptionline2
		m.wish_content.streamformat = wish_content.streamformat
	end if
end sub

sub playWishlistAnimation()
	wishlist_content = CreateObject("roSGNode", "ContentNode")
	wishlist_content.url = "http://192.168.43.99:8080/videos/wishlist-video.mp4"
	wishlist_content.streamformat = "mp4"
	m.wishlist_video.content = wishlist_content
	m.wishlist_video.control ="prebuffer"
	m.wishlist_video.visible = true
	m.wishlist_video.setFocus(true)
	m.wishlist_video.control = "play"
	' ? wishlist_video.state
end sub

sub focusWishlist()
	if m.top.getField("wishlist_finished") = "finished" then
    	m.wishlist_video.visible = false
		m.wishlist_video.setFocus(false)
		m.wishlist_grid.content = m.wishlist
		m.wishlist_grid.visible = true
    	m.wishlist_grid.setFocus(true)
	end if
end sub

function onKeyEvent(key, press) as Boolean
	if key = "back" and press
		m.wishlist_grid.visible = false
	end if
end function