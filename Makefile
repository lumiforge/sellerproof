# Makefile for the SellerProof project

# Get dependencies
install:
	flutter pub get

# Run the application
run:
	flutter run

# Build the application
build:
	flutter build

# Run tests
test:
	flutter test

git:
	@if [ -z "$(M)" ]; then echo 'ERROR: set MSG, e.g. make git MSG="feat: deploy function"'; exit 1; fi
	git add -A
	git commit -m "$(M)"
	git push origin main