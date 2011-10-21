Mission of Mercy Software
=========================

Clinic management software for Mission of Mercy free dental clinics.

## Installation

Mission of Mercy Software is a Ruby on Rails 2.3 application which runs on Ruby 1.8.7 and
[PostgreSQL](http://www.postgresql.org) databases. Other databases like MySQL
or SQLite are not officially supported.

### Setting Up a Development Copy: Step by Step

To install a development version of Mission of Mercy, follow these steps:

1. Fork our GitHub repository: <http://github.com/jordanbyron/mission_of_mercy>
2. Clone the fork to your computer
3. Run `bundle install` to install all of the dependencies

**Automatic Setup:**

Simply run `bundle exec rake setup` and all necessary files will be created, databases created, and seed data loaded.

_NOTE: This requires you have the EDITOR shell environment variable set: Example - `EDITOR=vim`_

**Manual Setup:**

1. Create a `database.yml` file in `config`. The `config` directory contains
   an example `database.yml` for PostgreSQL.

2. Create a `mom.yml` file in `config`. This file sets up some basic information
   about the clinic and where certain information is backed up to. The `config`
   directory contains an example `mom.yml` file which can be used.

3. Create and seed a development database, and initialize a test database:

    ```bash
    $ bundle exec rake db:setup
    $ bundle exec rake db:test:prepare
    ```

    _Note: All passwords are by default set to `temp123`_

4. Finally, run the test suite to make sure everything is working correctly:

    ```bash
    $ bundle exec rake test
    ```

## More Information about the software

For the latest update-to-date information about the software check out the
project's wiki pages at <http://wiki.github.com/jordanbyron/mission_of_mercy/>

## What is Mission of Mercy?

While there are other Missions of Mercy around the country, this MoM is a
gathering of volunteer dental professionals who along with a volunteer staff of
several hundred hold free, two day dental clinics at locations around the country.

The following is a video of the 2011 Connecticut Mission of Mercy clinic:

<http://www.youtube.com/watch?v=aGAEtleugnk>

## Software History

The Mission of Mercy software project, or MoM for short, is a rails based
project created for the 2009 Connecticut Mission of Mercy clinic. The project’s
goal is to streamline patient intake, digital x-ray, and check-out processes during
the clinic’s operating hours.

In 2010 the software was re-engineered to better track patient flow throughout
the clinic and to make check-out even faster. By moving several survey questions
to the registration process and breaking up check-out to each treatment area,
the CT Mission of Mercy was able to effectively process over 2,000 patients
(112 chairs) during their two day 2010 clinic.

## License

In 2010 Mission of Mercy software was released under the license of Ruby 1.8
which made it available to all Mission of Mercy clinics throughout the US.

## Contributors

**Core**

- Jordan Byron | <http://jordanbyron.com>
- Christopher Mitchell | <cmitchell@integrityss.com>

**Full List**

<https://github.com/jordanbyron/mission_of_mercy/contributors>