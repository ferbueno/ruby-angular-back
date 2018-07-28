# README

This application was made for testing some of our knowledge in `Rails`. Also, some of the nice features some `gems` offer.

The app offers a multitenant database scheme, created with the [Apartment](https://github.com/influitive/apartment) `gem`, mounted on a `MySQL` external database.

All passwords are encrypted with the [BCrypt](https://github.com/codahale/bcrypt-ruby) `gem`.

Finally, all documentation is built with the [Apipie](https://github.com/Apipie/apipie-rails) `gem`.

This application was designed to run on docker, featured on [this repo](https://github.com/ferbueno/ruby-angular-release). You'll need both projects for this to work.

This project may help some people who want to create a multi tenant app on Rails.

* Ruby version

    2.5.2

* Rails version

    5.2.0


## Multitenancy

```
Multitenancy  refers to a software architecture in which a single instance of software runs on a server and serves multiple tenants. A tenant is a group of users who share a common access with specific privileges to the software instance.
```
Cited from [Wikipedia](https://en.wikipedia.org/wiki/Multitenancy).

`Apartment` create a separated database schema for every tenant on the application. Whenever a `User` is registered, a new tenant is created right away, so a new database schema is created with it. This application has a custom `Elevator` which is for `Apartment` its tenant solver. 

Our custom `Elevator` parses a `JWT` and gets the custom payload, which inside contains the `username`, which the application interprets as its tenant. For this application, a simpler approach was selected, creating the `username` based on the user's name.

## Auto documentation

## Deployment

For deployment information, please visit the `release` repo of this project, which is located [here](https://github.com/ferbueno/ruby-angular-back).

This is the trickiest part, because the database is running on a `docker` container, external to the application.

For it to work, you must first deploy the stack to `docker`. The `rails` container won't start correctly at first, but eventually it will. When the stack is deployed, the MySQL container will expose its *3306*  to the computer's *4306*. You then will be able to migrate the database and install the `gems`.

To install the gems:

1. `cd` into the `release` project
```bash
cd release
```
2. Deploy the `docker` stack
```bash
./up.sh
```
3. `cd` back into the `back` project
```bash
cd ../back
```
4. Open the `database.yml` file
5. Change `host` from `rubyangular_mariadb` to `127.0.0.1`
6. Change `port` from `3306` to `4306`
7. Install the `gems`
```bash
bundle install 
```

To migrate the database:

1. After performing last operations, just run
```
rake db:migrate
```

To finally deploy the application:

1. Open the `database.yml` file
2. Revert your changes, change `host` from `127.0.0.1` to `rubyangular_mariadb`
3. Revert your changes, change `port` from `4306` to `3306`
4. `cd` into the `release` project
5. Run `down.sh`
```bash
./down.sh
```
5. Run `build.sh`
```bash
./build.sh
```
6. Run `up.sh` 
```bash
./up.sh
```

## Testing

To be implemented
