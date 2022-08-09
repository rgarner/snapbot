# frozen_string_literal: true

namespace :steep do
  desc "Run `steep check`"
  task :check do
    system("steep check", exception: true)
  end
end
