sub init()
    ? "start init"
    m.wishlist_button = m.top.findNode("wishlist_button")
    m.categories_button = m.top.findNode("categories_button")
	m.background_video = m.top.findNode("background_video")
    m.top.observeField("visible", "onVisibleChange")
end sub

sub onVisibleChange()
	if m.top.visible = true then
		m.categories_button.setFocus(true)
	end if
end sub


function onKeyEvent(key, press) as Boolean
	? "[home_scene] onKeyEvent", key, press
	if press then
		if key = "up" or key = "down" or key = "right" or key = "left" then
			if m.categories_button.hasFocus()
				m.wishlist_button.setFocus(true)
			else
				m.categories_button.setFocus(true)
			end if
		end if
	end if
  return false
end function