PLATFORM_IOS = iOS Simulator,name=iPhone 12 Pro,OS=14.4
.PHONY: test
test:
	@xcodebuild test \
		-workspace TvMazeApp.xcworkspace \
		-scheme TvMazeApp \
		-destination platform="$(PLATFORM_IOS)"


.PHONY: format
format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./App \
		./TvMazeAppLib


.PHONY: generate-l10n
generate-l10n:
	@swiftgen run strings \
		--templateName structured-swift5 \
		--param publicAccess=true \
		./TvMazeAppLib/Sources/L10n \
		--output ./TvMazeAppLib/Sources/L10n/L10n.swift
