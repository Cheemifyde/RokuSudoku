sub init()
  m.title = m.top.findNode("title")
  m.description = m.top.findNode("description") 
  m.stars = m.top.findNode("stars")
  m.thumbnail = m.top.findNode("thumbnail")
 end sub

sub showcontent()
  itemcontent = m.top.itemContent
  m.description.text = itemcontent.description
  m.stars.uri = itemcontent.HDPosterUrl
  m.thumbnail.uri = itemcontent.SDPosterUrl
end sub