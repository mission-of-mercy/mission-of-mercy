![Mission of Mercy Logo](https://github.com/jordanbyron/mission_of_mercy/raw/master/doc/mom.png)

Clinic management software for Mission of Mercy free dental clinics. Created to streamline patient intake, digital x-ray, and check-out processes during the clinic’s operating hours.

For the latest information about the software check out [this project's wiki](http://wiki.github.com/jordanbyron/mission_of_mercy)

## Installation

Mission of Mercy Software is a Ruby on Rails 3.1 application which runs on Ruby 1.9.2 and
[PostgreSQL](http://www.postgresql.org) databases. Other databases like MySQL
or SQLite are not officially supported.

### Setting Up a Development Copy: Step by Step

To install a development version of Mission of Mercy, follow these steps:

1. Fork our GitHub repository: <http://github.com/jordanbyron/mission_of_mercy>
2. Clone the fork to your computer
3. If you don't already have bundler installed, get it by running `gem install bundler`
4. Run `bundle install` to install all of the project's dependencies
5. Finally, run `rake setup` to create the required config files, create the database, and seed it with data

To make things even easier, you can copy and paste this into your terminal once you've got the project cloned to your computer

```bash
gem install bundler
bundle install
bundle exec rake setup
```

## What is Mission of Mercy?

While there are other Missions of Mercy around the country, this mission is a
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

- Jordan Byron // <http://jordanbyron.com>
- Christopher Mitchell // <cmitchell@integrityss.com>

**Full List**

<https://github.com/jordanbyron/mission_of_mercy/contributors>