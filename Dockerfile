# Build with:
# docker build -t date_holidays-reader .
FROM ruby:2.3.8

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock date-holiday-reader.gemspec ./
COPY lib ./lib
COPY node_bin ./node_bin

RUN find .

RUN bundle install

# Run tests with:
# docker run -it --mount src="$(pwd)",target=/usr/src/app/mount,type=bind date_holidays-reader sh -c 'cd mount && rspec'
