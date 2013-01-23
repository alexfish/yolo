require 'CFPropertyList'

module Yolo
  module Tools
    module Ios
      class Xcode

        attr_accessor :prefs_plist_path

        def initialize
          self.prefs_plist_path = "/Users/#{user}/Library/Preferences/com.apple.dt.Xcode.plist"
        end

        def user
          `whoami`.gsub("\n","") # get the current user
        end

        def prefs
          plist = CFPropertyList::List.new(:file => prefs_plist_path)
          CFPropertyList.native_types(plist.value)
        end

        def build_path
          path = prefs["IDECustomDerivedDataLocation"]
          path = "/Users/#{user}/Library/Developer/Xcode/DerivedData" unless  path
          path
        end
      end
    end
  end
end
