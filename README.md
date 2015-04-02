Rails Startup
==============

This project has been built to increase speed when creating a new application: it's annoying to reconfigure always and always the same gems so this startup pack comes with plugins already configured such as activeadmin, devise, globalize, and many others.

Ruby and Rails versions
-----------------------
Ruby 2.2.0  
Rails 4.2

Server
------
I am using unicorn in local development. The server is launch using `foreman start`

Mail
-----
I used [maildev]{http://djfarrelly.github.io/MailDev/} to tset my emails in local. You don't have nothing to do, maildev server will be launched in the same time as the rails server with `foreman start`.  
To see your mails, visit `http://localhost:1080`

Gems:
-----
### Globalize
Two language are included by default: french and english

Tests
-----
Basics tests are included, just run `rake test`


Usage
-----
Clone it: `git clone git@github.com:anthony-robin/rails-startup.git`  
Go to the folder: `cd rails-startup`  
Run `foreman start`  
Visit `http://localhost:3000`  
