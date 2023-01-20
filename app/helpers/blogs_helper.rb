# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    sanitize(blog.content.gsub("\n", '<br>'), tags: %w[br], attributes: %w[href])
  end
end
