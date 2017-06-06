# Default Sinatra to "production" mode (surpress errors) unless
# otherwise specified by the `RACK_ENV` environmental variable.
# Must be done prior to requiring Sinatra, or we'll get a LoadError
# as it looks for sinatra/cross-origin, which is development only
ENV["RACK_ENV"] = "production" if ENV["RACK_ENV"].to_s.empty?

require "json"
require "jekyll"
require "base64"
require "webrick"
require "sinatra"
require "fileutils"
require "sinatra/base"
require "sinatra/json"
require "addressable/uri"
require "sinatra/reloader"
require "sinatra/namespace"

module JekyllAdmin
  autoload :APIable,          "jekyll-admin-josercc/apiable"
  autoload :DataFile,         "jekyll-admin-josercc/data_file"
  autoload :Directory,        "jekyll-admin-josercc/directory"
  autoload :FileHelper,       "jekyll-admin-josercc/file_helper"
  autoload :PageWithoutAFile, "jekyll-admin-josercc/page_without_a_file"
  autoload :PathHelper,       "jekyll-admin-josercc/path_helper"
  autoload :Server,           "jekyll-admin-josercc/server"
  autoload :StaticServer,     "jekyll-admin-josercc/static_server"
  autoload :URLable,          "jekyll-admin-josercc/urlable"
  autoload :Version,          "jekyll-admin-josercc/version"

  def self.site
    @site ||= begin
      site = Jekyll.sites.first
      site.future = true
      site
    end
  end
end

# Monkey Patches
require_relative "./jekyll/commands/serve"
require_relative "./jekyll/commands/build"

[Jekyll::Page, Jekyll::Document, Jekyll::StaticFile, Jekyll::Collection].each do |klass|
  klass.include JekyllAdmin::APIable
  klass.include JekyllAdmin::URLable
end
