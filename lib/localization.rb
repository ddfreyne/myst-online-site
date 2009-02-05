module MOULSiteHelpers::Localization

  # Language names in all languages
  LANGUAGE_NAMES = {
    'en' => {
      'en' => 'English',
      'de' => 'German',
      'es' => 'Spanish',
      'fr' => 'French',
      'it' => 'Italian',
      'nl' => 'Dutch'
    },
    'de' => {
      'en' => 'WARNING: untranslated',
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'WARNING: untranslated'
    },
    'es' => {
      'en' => 'WARNING: untranslated',
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'WARNING: untranslated'
    },
    'fr' => {
      'en' => 'WARNING: untranslated',
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'WARNING: untranslated'
    },
    'it' => {
      'en' => 'WARNING: untranslated',
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'WARNING: untranslated'
    },
    'nl' => {
      'en' => 'Engels',
      'de' => 'Duits',
      'es' => 'Spaans',
      'fr' => 'Frans',
      'it' => 'Italiaans',
      'nl' => 'Nederlands'
    }
  }

  TRANSLATED_STRINGS = {
    'English translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Engelse vertaling'
    },
    'German translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Duitse vertaling'
    },
    'Spanish translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Spaanse vertaling'
    },
    'French translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Franse vertaling'
    },
    'Italian translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Italiaanse vertaling'
    },
    'Dutch translation' => {
      'de' => 'WARNING: untranslated',
      'es' => 'WARNING: untranslated',
      'fr' => 'WARNING: untranslated',
      'it' => 'WARNING: untranslated',
      'nl' => 'Nederlandse vertaling'
    },
  }

  # Returns the page's language code
  def language_code_of(page)
    page.path[1..2]
  end

  # Returns the page's human-readable language
  def language_of(page, lang)
    LANGUAGE_NAMES[lang][language_code_of(page)]
  end

  # Returns all articles in the given language
  def articles_in(lang)
    @pages.select { |p| p.kind == 'article' && language_code_of(p) == lang }.sort_by { |a| a.created_at }.reverse
  end

  # Returns the page's translations
  def translations_of(page)
    @pages.select { |p| p.page_id == page.page_id && p.path != page.path }
  end

  # Returns the page's translation in the given language
  def translation_of(page, lang)
    @pages.find { |p| p.page_id == page.page_id && language_code_of(p) == lang }
  end

  # Translates the given string into the given language
  def t(string, dst_lang)
    # Don't translate English texts
    return string if dst_lang == 'en'

    # Translate
    translations = TRANSLATED_STRINGS[string] || {}
    translations[dst_lang] || 'WARNING: untranslated'
  end

  module TimeExtensions

    MONTHNAMES_ENGLISH = %w(
      January
      February
      March
      April
      May
      June
      July
      August
      September
      October
      November
      December
    )

    MONTHNAMES_DUTCH = %w(
      januari
      februari
      maart
      april
      mei
      juni
      juli
      augustus
      september
      oktober
      november
      december
    )

    def to_localized_string(lang)
      if lang == 'nl'
        "#{self.mday} #{Time::MONTHNAMES_DUTCH[self.mon]} #{self.year}"
      else
        "#{Time::MONTHNAMES_ENGLISH[self.mon]} #{self.mday.ordinal}, #{self.year}"
      end
    end

  end

  class ::Time
    include TimeExtensions
  end

  module NumericExtensions

    def ordinal
      if (10...20).include?(self) then
        self.to_s + 'th'
      else
        self.to_s + %w{th st nd rd th th th th th th}[self % 10]
      end
    end

  end

  class ::Numeric
    include NumericExtensions
  end

end

include MOULSiteHelpers::Localization
