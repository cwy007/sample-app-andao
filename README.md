# Ruby on Rails Tutorial sample application
   This is the sample application for
   [*Ruby on Rails Tutorial:
   Learn Web Development with Rails*](http://www.railstutorial.org/)
   by [Michael Hartl](http://www.michaelhartl.com/).
## License
   All source code in the [Ruby on Rails Tutorial](http://railstutorial.org/)
   is available jointly under the MIT License and the Beerware License. See
   [LICENSE.md](LICENSE.md) for details.
   ## Getting started
   To get started with the app, clone the repo and then install the needed gems:
   ```
   $ bundle install --without production
   ```
   Next, migrate the database:
   ```
   $ rails db:migrate
   ```
   Finally, run the test suite to verify that everything is working correctly:
   ```
   $ rails test
   ```
   If the test suite passes, you'll be ready to run the app in a local server:
   ```
   $ rails server
   ```
   For more information, see the
   [*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).

## 常用指令别名
```
gst='git status'
gaa='git add --all'
gcmsg='git commit -m'

gcb='git checkout -b'
gl='git pull'
gp='git push'

gstaa='git stash apply'
gstc='git stash clear'
gstl='git stash list'

glgg='git log --graph'
```