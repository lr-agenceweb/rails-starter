Rails Startup (Work in Progress)
==============

This project has been built to increase speed when creating a new application: it's annoying to reconfigure always and always the same gems so this startup pack comes with plugins already configured such as activeadmin, devise, globalize, and many others.

Requirements:
------------
Install [Foreman](https://github.com/ddollar/foreman)  
Install [Maildev](https://github.com/djfarrelly/MailDev)  

Usage
-----
Clone it: `git clone git@github.com:anthony-robin/rails-startup.git`  
Rename `.env.example` to `.env`  
Rename `database.example.yml` to `database.yml`  
Add your database configuration  
Go to the application folder: `cd rails-startup`  
Install gems: `bundle install`  
Run migrations: `rake db:create db:migrate db:seed`  
Run `foreman start`  
Visit `http://localhost:3000`  
That's it !

Ruby and Rails versions
-----------------------
Ruby 2.2.0  
Rails 4.2

Server
------
I am using unicorn in local development. The server is launch using `foreman start`

Database:
---------
I am using `mysql2` but you can choose to use `SQlite` or any other SGBD.  
To create a dump of your database, run `rake db:backup`

Template:
--------
I am using [Slim](https://github.com/slim-template/slim-rails) template to write HTML views.

Mail
-----
I used [maildev](http://djfarrelly.github.io/MailDev/) to tset my emails in local. You don't have nothing to do, maildev server will be launched in the same time as the rails server with `foreman start`.  
To see your mails, visit `http://localhost:1080`

Gems:
-----
### Globalize
Two language are included by default: french and english  
  
Look at the Gemfile for more informations !

Tests
-----
Basics tests are included, just run `rake test`

