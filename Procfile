web: bundle exec thin start -e $RAILS_ENV -p $PORT
worker: QUEUE=* bundle exec rake environment resque:work --trace
scheduler: bundle exec rake environment resque:scheduler
