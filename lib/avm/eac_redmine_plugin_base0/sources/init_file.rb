# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module EacRedminePluginBase0
    module Sources
      class InitFile
        common_constructor :path

        VERSION_LINE_PATTERN = /\A(\s*)version\s*[\'\"]([^\'\"]+)[\'\"](\s*)\z/.freeze

        def version
          path.read.each_line.lazy.map { |line| line_value(line) }.find { |v| v }
        end

        def version=(new_value)
          path.write(new_value_content(new_value))
        end

        private

        # @return Version found in line, nil otherwise.
        def line_value(line)
          VERSION_LINE_PATTERN.if_match(line.rstrip, false) { |m| ::Gem::Version.new(m[2]) }
        end

        def new_value_content(new_value)
          path.read.each_line
            .map { |line| new_value_line(line, new_value) }
            .join
        end

        def new_value_line(line, new_value)
          m = VERSION_LINE_PATTERN.match(line)
          return line unless m

          "#{m[1]}version '#{new_value}'"
        end
      end
    end
  end
end
