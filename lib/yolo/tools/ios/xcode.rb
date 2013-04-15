require 'CFPropertyList'

module Yolo
  module Tools
    module Ios
      #
      # Provides an interface to Xcode
      #
      # @author [Alex Fish]
      #
      class Xcode
        # The path to The Xcode preferences file
        attr_accessor :prefs_plist_path
        # The path to an applications info plist
        attr_accessor :info_plist_path

        #
        # Creates a new instance of Xcode with the default preferences p list location loaded
        #
        # @return [Xcode] An Xcode instance
        def initialize
          self.prefs_plist_path = "#{user_directory}/Library/Preferences/com.apple.dt.Xcode.plist"
        end

        #
        # The current users home directory path
        #
        # @return [String] The path to the current users home directory, same as ~
        def user_directory
          File.expand_path('~')
        end

        #
        # Returns a hash representation of Xcode's preferences
        #
        # @return [Hash] A hash containing all of Xcode's preferences
        def prefs
          plist = CFPropertyList::List.new(:file => prefs_plist_path)
          CFPropertyList.native_types(plist.value)
        end

        #
        # Querys Xcode's preferences to find it's build folder location
        #
        # @return [String] The full path to Xcode's build location
        def build_path
          path = prefs["IDECustomDerivedDataLocation"]
          path = "#{user_directory}/Library/Developer/Xcode/DerivedData" unless path
          path
        end

        #
        # Creates a Hash representation of an applications info.plist
        #
        # @return [Hash] A hash representation of the instances info.plist
        def info_plist
          if info_plist_path.length > 0
            plist = CFPropertyList::List.new(:file => info_plist_path)
            CFPropertyList.native_types(plist.value)
          else
            error = Yolo::Formatters::ErrorFormatter.new
            error.info_plist_not_found
          end
        end

        #
        # Queries the instances info_plist hash to return the CFBundleVersion
        #
        # @return [String] The current instances info.plist CFBundleVersion
        def build_number
          info_plist["CFBundleVersion"]
        end

        #
        # Queries the instances info_plist hash to return the CFBundleShortVersionString
        #
        # @return [String] The current instances info.plist CFBundleShortVersionString
        def version_number
          info_plist["CFBundleShortVersionString"]
        end

      end
    end
  end
end
