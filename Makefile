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
