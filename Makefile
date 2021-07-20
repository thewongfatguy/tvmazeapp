.PHONY: setup-dev
setup-dev:
	@bundle install
	@brew install swift-format
	@brew install swiftgen

.PHONY: test
test:
	@bundle exec fastlane test


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

.PHONY: secrets
secrets:
	@echo "$$SECRETS" > ./App/TvMazeApp/Secrets.swift

define SECRETS
enum Secrets {
  static let sentryDsn = "$(SENTRY_DSN)"
}
endef
export SECRETS