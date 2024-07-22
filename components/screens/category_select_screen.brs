sub init()
  m.category_row = m.top.findNode("category_row")
  m.category_row.content = CreateObject("roSGNode", "CategorySelectContent")
  m.top.observefield("visible", "onVisibleChange")
end sub

sub onVisibleChange()
  if m.top.visible = true then
    m.category_row.setFocus(true)
  end if
end sub

sub onItemSelect()
  m.top.selected_category_content = m.category_row.content.getChild(0).getChild(m.category_row.rowItemFocused[1]).description
end sub