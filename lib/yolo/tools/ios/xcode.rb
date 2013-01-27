require 'CFPropertyList'

module Yolo
  module Tools
    module Ios
      class Xcode

        attr_accessor :prefs_plist_path
        attr_accessor :info_plist_path

        def initialize
          self.prefs_plist_path = "#{user_directory}/Library/Preferences/com.apple.dt.Xcode.plist"
        end

        def user_directory
          File.expand_path('~')
        end

        def prefs
          plist = CFPropertyList::List.new(:file => prefs_plist_path)
          CFPropertyList.native_types(plist.value)
        end

        def build_path
          path = prefs["IDECustomDerivedDataLocation"]
          path = "#{user_directory}/Library/Developer/Xcode/DerivedData" unless path
          path
        end

        def info_plist
          if info_plist_path
            plist = CFPropertyList::List.new(:file => info_plist_path)
            CFPropertyList.native_types(plist.value)
          else
            Yolo::Formatters::ErrorFormatter.info_plist_not_found
          end
        end

        def build_number
          info_plist["CFBundleVersion"]
        end

        def version_number
          info_plist["CFBundleShortVersionString"]
        end

      end
    end
  end
end
