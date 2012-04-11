![Mission of Mercy Logo](https://github.com/mission-of-mercy/mission-of-mercy/raw/master/doc/mom.png)

Clinic management software for Mission of Mercy free dental clinics. Created to streamline patient intake, digital x-ray, and check-out processes during the clinic’s operating hours. Since its creation in 2009 it has been used in Mission of Mercy clinics throughout the United States.

For the latest information about the software check out [this project's wiki](http://wiki.github.com/mission-of-mercy/mission-of-mercy)

## Installation

Mission of Mercy Software is a Ruby on Rails 3.1 application which runs on Ruby 1.9.2 and
[PostgreSQL](http://www.postgresql.org) databases. Other databases like MySQL
or SQLite are not officially supported.

### Setting Up a Development Copy: Step by Step

To install a development version of Mission of Mercy, follow these steps:

1. Fork our GitHub repository: <http://github.com/mission-of-mercy/mission-of-mercy>
2. Clone the fork to your computer
3. If you don't already have bundler installed, get it by running `gem install bundler`
4. Install Qt libraries for capybara-webkit: <https://github.com/thoughtbot/capybara-webkit#readme>
5. Run `bundle install` to install all of the project's dependencies
6. Finally, run `rake setup` to create the required config files, create the database, and seed it with data

To make things even easier, you can copy and paste this into your terminal once you've got the project cloned to your computer

```bash
gem install bundler
bundle install
bundle exec rake setup
```

## What is Mission of Mercy?

While there are other Missions of Mercy around the country, the mission this project supports is a one or two-day clinic in which portable dental stations are set up in a large public arena and dental screenings and services are provided at no charge to those who attend. Historically, demand for these clinics has been so intense that individuals often stand in line, as early as midnight, to receive the services. In the USA half of the states run Mission of Mercy clinics.

![Georgia Clinic](https://github.com/mission-of-mercy/mission-of-mercy/raw/master/doc/ga_clinic.png)

It's easy to work on a software project and never see the impact it makes on people. For Mission of Mercy, it' hard NOT to see the amazing impact your contributions make on people's lives. Below is a collection of photos and videos from various clinics throughout the country which use this software.

**Photos**

- [CT Mission of Mercy](http://www.flickr.com/photos/ctmissionofmercy)
- [GA Mission of Mercy](http://www.flickr.com/photos/29180323@N06/)

**Videos**

- [2012 Connecticut Mission of Mercy clinic](http://youtu.be/i3QQ0G-xcqc)
- [2011 Connecticut Mission of Mercy clinic](http://youtu.be/aGAEtleugnk)
- [2011 Georgia Mission of Mercy clinic](http://youtu.be/u4jvLU3RGfU)

## Contributing

Features and bugs are tracked through [Github Issues](https://github.com/mission-of-mercy/mission-of-mercy/issues).

Contributors retain copyright to their work but must agree to release their
contributions under the same terms as this project. For details, please see the LICENSE file.

If you would like to help with developing Mission of Mercy, please get in touch!
Contact Jordan through [GitHub (@jordanbyron)](https://github.com/jordanbyron) or [Twitter (@jordan_byron)](http://twitter.com/jordan_byron)

### Submitting a Pull Request

1. If a ticket doesn't exist for your bug or feature, create one on GitHub.
    - **NOTE:** Don't be afraid to get feedback on your idea before you begin development work. In fact it is encouraged. I promise I don't bite ;)
2. Fork the project.
3. Create a topic branch.
4. Implement your feature or bug fix.
5. Add documentation for your feature or bug fix.
6. Add tests for your feature or bug fix.
7. Run `rake test`. If your changes are not 100% covered, go back to step 6.
8. If your change affects something in this README, please update it
9. Commit and push your changes.
10. Submit a pull request.

## Authorship

Mission of Mercy was originally written by Jordan Byron for the 2009 Connecticut Mission of Mercy dental clinic. During the 2008 CT clinic, Jordan's then employer, Integrity Systems & Solutions, saw areas of the clinic which could benefit from custom software written to fit the flow and "Mash Unit" environment of the clinic. Together, Jordan and his colleagues designed the first version of the clinic software.

Over the years many people have contributed to Mission of Mercy through writing patches, performing QA tests, and helping out with the design. Without the help of Christopher Mitchell and Josephine Bicknell this project would not exist.

A full list of folks who have contributed patches to Mission of Mercy can be found on github at <https://github.com/mission-of-mercy/mission-of-mercy/contributors>

## License

Mission of Mercy is released under the License of Ruby. For details, please see the LICENSE file.

If you wish to contribute to Mission of Mercy, you will retain your own copyright but must agree to license your code under the same terms as the project itself.
