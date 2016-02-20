all: headless-test
headless-test:
	xvfb-run -a bundle exec rake test
