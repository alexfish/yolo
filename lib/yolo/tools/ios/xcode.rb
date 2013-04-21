require 'cfpropertylist'

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
        # Creates a new instance of Xcode
        #
        # @param info_plist_path [String] The full path to an xcode projects info_plist
        # @return [Xcode] An Xcode instance
        def new(info_plist_path = "")
          self.info_plist_path = info_plist_path
        end

        #
        # Creates a new instance of Xcode with the default preferences p list location loaded
        #
        # @return [Xcode] An Xcode instance
        def initialize
          self.prefs_plist_path = "#{Dir.pwd}/Library/Preferences/com.apple.dt.Xcode.plist"
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
          path = "#{Dir.pwd}/Library/Developer/Xcode/DerivedData" unless path
          path
        end

        #
        # Creates a Hash representation of an applications info.plist
        #
        # @return [Hash] A hash representation of the instances info.plist
        def info_plist
          if info_plist_path
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
