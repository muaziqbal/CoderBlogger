# CoderBlogger


Coderwall is a developer community that developers use each month to learn and share programming tips.

## Prerequisites

* Ruby
* Postgres
* Heroku Toolbelt (or foreman gem)

## Get Started

cp .env.sample .env  # (most settings are not required for core functionality)
bundle install
rake db:create db:migrate
rails s
