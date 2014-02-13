module Xcodeproj
  class Project
    module Object

      class PBXBuildStyle < AbstractObject

        # @!group Attributes

        # @return [String] the name of the build style.
        #
        attribute :name, String

        # @return [Hash] the build settings to use for building the target.
        #
        attribute :build_settings, Hash, {}

      end
    end
  end
end
