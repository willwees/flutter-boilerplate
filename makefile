init: clean get generate l10n

clean:
	echo "Cleaning the project" ; \
	flutter clean ; \

get:
	echo "Updating dependencies" ; \
	flutter pub get ; \

generate:
	echo "Generating needed codes" ; \
	dart run build_runner build --delete-conflicting-outputs ; \

l10n:
	echo "Generating static texts" ; \
	flutter gen-l10n ;

run:
	flutter run -v ;\