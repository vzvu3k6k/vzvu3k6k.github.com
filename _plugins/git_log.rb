# License: [CC0](http://creativecommons.org/publicdomain/zero/1.0/)

require 'grit'
require 'time'
require 'webrick/htmlutils'

module Jekyll
  class GitLog < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      env = context.environments[0]

      path = env["page"]["path"]
      commits = Grit::Repo.new(".").log("HEAD", path, follow: true)

      result = %q{<ul>}
      commits.each do |i|
        id, datetime, message = [i.id, i.authored_date.iso8601, i.short_message].map{|j|
          WEBrick::HTMLUtils.escape(j.force_encoding(Encoding.default_external))
        }
        result << %Q{<li><a href="#{env["site"]["commit_permalink"].sub("{id}", id)}"><time>#{datetime}</time> <span>#{message}</span></a></li>}
      end
      result << %q{</ul>}
    end
  end
end

Liquid::Template.register_tag("git_log", Jekyll::GitLog)
