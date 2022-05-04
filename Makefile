ifneq ($(wildcard IHP/.*),)
IHP = IHP/lib/IHP
else
IHP = $(shell dirname $$(which RunDevServer))/../lib/IHP
endif

# CSS_FILES += ${IHP}/static/vendor/bootstrap.min.css
CSS_FILES += ${IHP}/static/vendor/flatpickr.min.css
CSS_FILES += static/app.css

JS_FILES += ${IHP}/static/vendor/jquery-3.2.1.slim.min.js
JS_FILES += ${IHP}/static/vendor/timeago.js
# JS_FILES += ${IHP}/static/vendor/popper.min.js
# JS_FILES += ${IHP}/static/vendor/bootstrap.min.js
JS_FILES += ${IHP}/static/vendor/flatpickr.js
JS_FILES += ${IHP}/static/helpers.js
JS_FILES += ${IHP}/static/vendor/morphdom-umd.min.js
JS_FILES += ${IHP}/static/vendor/turbolinks.js
JS_FILES += ${IHP}/static/vendor/turbolinksInstantClick.js
JS_FILES += ${IHP}/static/vendor/turbolinksMorphdom.js

include ${IHP}/Makefile.dist

tailwind-dev:
	node_modules/.bin/tailwind -c tailwind/tailwind.config.js -i ./tailwind/app.css -o static/app.css --watch
static/app.css:
	cd tailwind && NODE_ENV=production npx tailwindcss -i ./app.css -o ../static/app.css --minify
