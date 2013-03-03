require "jekyll-multilanguage/version"
require "kramdown"

module Jekyll

  LANGS = ["en", "de"]

  TRANSLATIONS = {}

  LANGS.each do |lang|
    hash = YAML.load(File.read("_i18n/#{lang}.yaml"))
    TRANSLATIONS[lang] = hash
  end

  class I18nPage < Page
    def initialize(site, base, lang, name)
      @site = site
      @base = base
      @dir = lang
      @name = name
      self.read_yaml(base, name)
      self.data['lang'] = lang
      self.process(@name)
    end
  end

  class MultiLangPageGenerator < Generator
    safe true

    def generate(site)
      extra_pages = []
      site.pages.each do |page|
        LANGS.each do |lang|
          extra_pages << I18nPage.new(site, site.source, lang, page.name)
        end
      end
      site.pages.concat(extra_pages)
    end
  end

  class I18nTag < Liquid::Tag

    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context)
      lang = context.environments.first["page"]["lang"] || LANGS[0]
      trans = TRANSLATIONS[lang]
      # try in the page's lang
      translated_str = trans[@key]

      if translated_str.nil?
        # try the first lang
        translated_str = TRANSLATIONS[LANGS[0]][@key]
      end
      if translated_str.nil?
        # give up, use the translation key
        puts "[WARNING]: Language #{lang} doesn't translate the key #{@key}"
        translated_str = @key
      end

      # use markdown parser to convert text to html
      if translated_str =~ /\n/
        translated_str = Kramdown::Document.new(translated_str).to_html
      end
      translated_str
    end
  end

  class CurrentLanguageTag < Liquid::Tag
    def render(context)
      lang = context.environments.first["page"]["lang"] || LANGS[0]
      translated_lang = TRANSLATIONS[lang]["lang_name"]
      translated_lang
    end
  end

  class LanguageSwitcherTag < Liquid::Tag
    def render(context)
      page = context.environments.first["page"]
      current_lang = page["lang"] || LANGS[0]
      page_name = page["url"].split("/").last
      output = '<ul class="dropdown-menu">'
      LANGS.each do |lang|
        translated_lang = TRANSLATIONS[lang]["lang_name"]
        if current_lang == lang
          output << "<li class='active'><a href='/#{lang}/#{page_name}'>#{translated_lang}</a></li>"
        else
          output << "<li><a href='/#{lang}/#{page_name}'>#{translated_lang}</a></li>"
        end
      end
      output << '</ul>'
      output
    end
  end
end

Liquid::Template.register_tag('i18n', Jekyll::I18nTag)
Liquid::Template.register_tag('current_language', Jekyll::CurrentLanguageTag)
Liquid::Template.register_tag('language_switcher', Jekyll::LanguageSwitcherTag)
