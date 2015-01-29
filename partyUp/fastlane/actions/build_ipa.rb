module Fastlane
  module Actions
    module SharedValues
      BUILD_IPA_CUSTOM_VALUE = :BUILD_IPA_CUSTOM_VALUE
    end

    class BuildIpaAction
      def self.run(params)
        system("mkdir releases");
        system("ipa build --verbose && mv *.ipa releases && mv *.zip releases")
      end
    end
  end
end
