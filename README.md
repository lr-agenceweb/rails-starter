Rails Starter (Work in Progress)
==============
[![Build Status](https://travis-ci.org/anthony-robin/rails-starter.svg?branch=master)](https://travis-ci.org/anthony-robin/rails-starter)
[![Code Climate](https://codeclimate.com/github/anthony-robin/rails-starter/badges/gpa.svg)](https://codeclimate.com/github/anthony-robin/rails-starter)
[![Test Coverage](https://codeclimate.com/github/anthony-robin/rails-starter/badges/coverage.svg)](https://codeclimate.com/github/anthony-robin/rails-starter)
[![security](https://hakiri.io/github/anthony-robin/rails-starter/master.svg)](https://hakiri.io/github/anthony-robin/rails-starter/master)

This project has been built to increase speed when creating a new application: it's annoying to reconfigure always and always the same gems so this starter pack comes with plugins already configured such as activeadmin, devise, globalize, and many others.

Requirements:
------------
Install [Foreman](https://github.com/ddollar/foreman)  
Install [Maildev](https://github.com/djfarrelly/MailDev)  

Usage
-----
Clone it: `git clone git@github.com:anthony-robin/rails-starter.git`  
Rename `.env.example` to `.env`  
Rename `application.example.yml` to `application.yml`  
Setup your environment variable (database, secret key, devise key, ...)
Rename `database.example.yml` to `database.yml`  
Go to the application folder: `cd rails-starter`  
Install gems: `bundle install`  
Run migrations: `rake db:create db:migrate db:seed`  
Run `foreman start`  
Visit `http://localhost:3000`  
That's it !

Ruby and Rails versions
-----------------------
Ruby 2.2.2  
Rails 4.2.3  

Server
------
This project use unicorn in local development. The server is launch using `foreman start`

Database
---------
It use `mysql2` but you can choose to use `PostgreSQL` or `SQlite` or any other SGBD.  
To create a dump of your database, run `rake db:backup`

Template
--------
I am using [Slim](https://github.com/slim-template/slim-rails) template to write HTML views.

Assets
-------
Style is writting in `scss` and `sass` (with compass)  
Scripts are created in `coffeescript`

Tasks
------
* Color Routes: colored version of rake routes (run `rake color_routes`)
* Dump SQL: make a quick save of your Database (run `rake db:backup`)

Mail
-----
I use [maildev](http://djfarrelly.github.io/MailDev/) to test my emails in local. You don't have nothing to do, maildev server will be launched in the same time as the rails server with `foreman start`.  
To see your mails, visit `http://localhost:1080`

Newsletter
-----------
Now available

Gems
-----
### [Globalize](https://github.com/globalize/globalize)
Two languages are included by default: french and english  
  
### [Whenever](https://github.com/javan/whenever)
Setup two Cron tasks:
* Regenerate sitemap everyday
* Make a dump of database every day: it will be saved in ypur dropbox account and you will be notified by Slack about success or failure.

To make this tasks active on your server, just run `whenever --update-crontab <name-of-your-site>`  
For more information read the gem documentation.

### [Annotate](https://github.com/ctran/annotate_models)
Print table structure in models  

### [Gretel](https://github.com/lassebunk/gretel)
Breadcrumb generator

Units Tests
-----
Basics tests are included, just run `rake test`

Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Bonus
------
* This project follow most of [Rubocop](https://github.com/bbatsov/rubocop) rules

Screenshots
-----------
![Activeadmin Dashboard example](vendor/assets/images/readme/dashboard_rails_starter.jpg)