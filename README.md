# README

[![Code Climate](https://codeclimate.com/github/RailsStudyGroup/redditgraphed/badges/gpa.svg)](https://codeclimate.com/github/RailsStudyGroup/redditgraphed)

### Background processing
* _Requires [Redis](http://redis.io)_
* Done via sidekiq
* Start sidekiq via: 'bundle exec sidekiq'
* Restart sidekiq via: 'kill -kill $(cat tmp/pids/sidekiq.pid) && bundle exec sidekiq'
* Follow the sidekiq logs via: 'tail -f log/sidekiq.log'

### database.yml
We had some issues with different contributers needing different username/password combos for PostgreSQL so we have removed the universal database.yml. In order to get yours up and running, rename database_example.yml to database.yml