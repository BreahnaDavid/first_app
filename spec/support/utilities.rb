def full_title(page_title)
  base_title = 'RoR'
  if page_title.present?
    "#{base_title} | #{page_title}"
  else
    base_title
  end
end
