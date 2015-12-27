Rails Starter
==============
[![Build Status](https://travis-ci.org/lr-agenceweb/rails-starter.svg?branch=master)](https://travis-ci.org/lr-agenceweb/rails-starter)
[![Code Climate](https://codeclimate.com/github/lr-agenceweb/rails-starter/badges/gpa.svg)](https://codeclimate.com/github/lr-agenceweb/rails-starter)
[![Test Coverage](https://codeclimate.com/github/lr-agenceweb/rails-starter/badges/coverage.svg)](https://codeclimate.com/github/lr-agenceweb/rails-starter/coverage)
[![security](https://hakiri.io/github/lr-agenceweb/rails-starter/master.svg)](https://hakiri.io/github/lr-agenceweb/rails-starter/master)

This project has been built to increase speed when creating a new application: it's annoying to reconfigure always and always the same gems so this starter pack comes with plugins already configured such as activeadmin, devise, globalize, and many others.

Requirements:
------------
~~a computer~~  
RVM with Ruby 2.2.2  
Rails 4.2.5  
Install [Foreman](https://github.com/ddollar/foreman)  
Install [Maildev](https://github.com/djfarrelly/MailDev)  

Usage
-----
Clone it: `git clone git@github.com:anthony-robin/rails-starter.git`  
Duplicate `.env.example` and rename it in `.env`  
Duplicate `application.example.yml` and rename it in `application.yml`  
Duplicate `database.example.yml` and rename it in `database.yml`  
Setup your environment variable (database, secret key, devise key, ...)  
Go to the application folder: `cd rails-starter`  
Install gems: `bundle install`  
Create database: `rake db:create`  
Load schema: `rake db:schema:load`  
Seed datas: `rake db:seed`  
Run `foreman start`  
Visit `http://localhost:3000`  
That's it !  

Ruby and Rails versions
-----------------------
Ruby 2.2.2  
Rails 4.2.5  

Server
------
This project use unicorn in local development. The server is launched using `foreman start`

Database
---------
It use `MySQL2` but you can choose to use `PostgreSQL`, `SQlite` or any other SGBD.  
To create a dump of your database, run `rake db:backup`

Template
--------
It use [Slim](https://github.com/slim-template/slim-rails) template to write HTML views.

Assets
-------
Style is writting in `scss` and `sass` (with compass)  
Scripts are created in `coffeescript`

<!-- In development and test environments, assets are stored in `local` but in staging and production, they are stored with `dropbox` using dropbox-paperclip gem. The advantage of storing in an external server is that you relieve your server storage. -->

Tasks
------
* Color Routes: colored version of rake routes (run `rake color_routes`)
* Dump SQL: make a quick save of your Database (run `rake db:backup`)

Mail
-----
It use [maildev](http://djfarrelly.github.io/MailDev/) to test emails in local. You don't have nothing to do, maildev server will be launched in the same time as the rails server with `foreman start`.  
To see your mails, visit `http://localhost:1080`


Modules
---------
* **Newsletter**
In order to avoid spam email when sending newsletter to subscribers, you will need to sign your email address using SPF and DKIM keys and linked them to your DNS.
Be sure to generate a `dkim.private.key` and `dkim.public.key` and move the `dkim.private.key` in `config/dkim` folder.

* **Blog**  
Write blog articles.

* **Slider**  
Add a slider on the page you want and customize its options.

* **Comments**  
Add comments for posts or blogs articles.

* **Guest Book**  
Allow users (connected or not) to leave a message in the guest book.

* **Events**  
Create events (with start date and end date)

* **Map**  
Display a Mapbox map of your organization or business

* **Social Network**  
Display social networks icons to share your site or let users to follow you on this networks

* **Breadcrumb**  
Show a breadcrumb on the page of your site

* **Video**  
Upload your own videos or add it from video platform such as Youtube or Dailymotion

* **Calendar**  
Choose start date and end date for your Events

* **Background**  
Display a background image for your pages

* **QrCode**  
Show a contact QrCode on the website

* **Adult**  
Display a popup the first time you access the website to inform you than you must be over 18 to continue your visit

* **RSS**  
Add a RSS feed to the website

* **Search**  
Add a search form to look on title or content post articles

* **Mailing**  
Application developped to send heavy mails number to users

Units Tests
-----------
Basics tests are included, just run `rake test`

Code structure:
---------------
This project follow most of [Rubocop](https://github.com/bbatsov/rubocop) rules

Bonus
------
Do you know the Konami code ?

Screenshots
-----------
![Activeadmin Dashboard example](vendor/assets/images/readme/dashboard_rails_starter.jpg)

Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request