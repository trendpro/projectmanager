require 'fileutils'

module RedmineContacts
  module Thumbnail
    extend Redmine::Utils::Shell
    include Redmine::Thumbnail

    CONVERT_BIN = (Redmine::Configuration['imagemagick_convert_command'] || 'convert').freeze

    # Generates a thumbnail for the source image to target
    def self.generate(source, target, size)
      return nil unless Redmine::Thumbnail.convert_available?
      unless File.exists?(target)
        directory = File.dirname(target)
        unless File.exists?(directory)
          FileUtils.mkdir_p directory
        end
        size_option = "#{size}x#{size}^"
        sharpen_option = "0.7x6"
        crop_option = "#{size}x#{size}"
        cmd = "#{shell_quote CONVERT_BIN} #{shell_quote source} -resize #{shell_quote size_option} -sharpen #{shell_quote sharpen_option} -gravity center -extent #{shell_quote crop_option} #{shell_quote target}"
        unless system(cmd)
          logger.error("Creating thumbnail failed (#{$?}):\nCommand: #{cmd}")
          return nil
        end
      end
      target
    end


  end
end
