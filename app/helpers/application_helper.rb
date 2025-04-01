module ApplicationHelper
  def title(page_title)
    content_for(:title) { "秋名山谷神 · #{page_title}" }
  end
end
