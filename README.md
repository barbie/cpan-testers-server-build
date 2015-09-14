# CPAN Testers Server Build

The following is a description of the steps required to build a full CPAN 
Testers server. As we've had to do this several times over the years, it will 
help whenever we have to do this again.

Please consider this a living document, so as things change, please update.

## 1. First Steps

Having got a machine to build, the current OS used for a CPAN Testers server 
is Debian. 

### 1.1 User Accounts

The current primary user account is 'barbie'. This runs all the
cronjobs, as well as holds permissions for web and backend processing 
directories. For security, it would make more sense for the cronjobs to run
under a 'cron' user, and ensure it has permissions to write to appropriate
directories.

ProFTP uses the 'ftp' user, but this should be created by the system. If not,
please add the user.

Most other user accounts should be disabled for login. /etc/passwd shells
should be set to '/usr/sbin/nologin' or similar.

To help prevent ssh attacks, it is recommended that 'fail2ban' is also 
installed. See 'http://www.fail2ban.org/wiki/index.php/Main_Page' for
additional information.

### 1.2 The File System

Depending on how the filesystem is mounted, entries in /etc/fstab are needed
to ensure the script and web paths all work. See fstab.txt to see the current
extras added to cpantesters3.

Note that the mounted SATA disks are:

/media/backend (contains MySQL data files, and CPAN Testers backend scripts)
/media/web (contains all web files, including CPAN and BACKPAN directories)

After this point we will assume that web sites will be available in '/var/www', 
backend files will use the path '/opt/projects', and mount points for ProFTP
are in '/home/ftp'.

### 1.3 Debian & CPAN Installs

In order to have a working system, a number of system installs and CPAN 
installs are needed. Run server-installs.sh as root to install apps and 
libraries.

### 1.4 Site Installs

The websites themselves are not straight installs from CPAN, but offsite 
builds, from the ./vhost directory in the base distribution, then loading
Labyrinth and required plugins locally. As such different websites may be
built against different versions of Labyrinth, due to the various sites
being upgraded at different times.

The list of the associated websites are:

#### 1.4.1 The Reports Website

path: /var/www/reports
distribution: CPAN-Testers-WWW-Reports
GitHub: https://github.com/barbie/cpan-testers-www-reports

This includes the Static site (/var/www/reports/html/static), and the Pass 
Matrix (/var/www/reports/html/stats) site.

#### 1.4.2 The Admin Website

path: /var/www/cpanadmin
distribution: CPAN-Testers-WWW-Admin
GitHub: https://github.com/barbie/cpan-testers-www-admin

#### 1.4.3 The Preferences Website

path: /var/www/cpanprefs
distribution: CPAN-Testers-WWW-Preferences
GitHub: https://github.com/barbie/cpan-testers-www-preferences

#### 1.4.4 The Statistics Website

path: /var/www/cpanstats
distribution: CPAN-Testers-WWW-Statistics
GitHub: https://github.com/barbie/cpan-testers-www-statistics

The site is built from scripts and files run from and stored in:

/opt/projects/cpantesters/cpanstats

#### 1.4.5 The Development Website

path: /var/www/cpandevel
distribution: CPAN-Testers-WWW-Development
GitHub: https://github.com/barbie/cpan-testers-www-development

The site is built from scripts and files run from and stored in:

/opt/projects/cpantesters/cpandevel

### 1.5 Backend System Installs

The websites require additional scripts and processes to maintain the 
databases. These scripts are again installed via the CPAN distributions.

#### 1.5.1 The Generator

path: /opt/projects/cpantesters/generate
distribution: CPAN-Testers-Data-Generator
GitHub: https://github.com/barbie/cpan-testers-data-generator

Retrieves the reports data feed from the Metabase server, and parses the
report metadata into the cpanstats database.

#### 1.5.1 The Uploader

path: /opt/projects/cpantesters/uploads
distribution: CPAN-Testers-Data-Uploads
GitHub: https://github.com/barbie/cpan-testers-data-uploads

Parses the CPAN and BACKPAN directories for new and deleted files, and 
updates the cpanstats database accordingly.

#### 1.5.1 The Statistic Excel

path: /opt/projects/cpantesters/cpanstats-excel
distribution: CPAN-Testers-WWW-Statistics-Excel
GitHub: https://github.com/barbie/cpan-testers-www-statistics-excel

Processes the statistis data into Excel spreadsheet files for download.

#### 1.5.1 The Reports Mailer

path: /opt/projects/cpantesters/reports-mailer
distribution: CPAN-Testers-WWW-Reports-Mailer
GitHub: https://github.com/barbie/cpan-testers-www-reports-mailer

Mails authors links to their reports.

#### 1.5.1 The Generator Mailer

path: /opt/projects/cpantesters/generate
distribution: CPAN-Testers-WWW-Generator-Mailer
GitHub: not available

Sends error reports, in the event a faulty report is detected.

#### 1.5.1 The Uploads Mailer

path: /opt/projects/cpantesters/uploads-mailer
distribution: CPAN-Testers-Data-Uploads-Mailer
GitHub: https://github.com/barbie/cpan-testers-data-uploads-mailer

Sends authors emails, if a distribution doesn't adhere to the approved naming
convention. Also welcomes new authors, and provides an introduction to CPAN 
Testers.

### 1.6 The Databases

There are several databases in MySQL, several for the dynamic websites, and
others to maintain the reports and statistics.

#### 1.6.1 Database Creation

Database schema can be built from the schemas of the various CPAN 
distributions. See the above distributions for details.

TODO: Provide a consolidated schema file for each database.

Where possible build the database from existing backups. It will take over a 
month to rebuild otherwise!

#### 1.6.2 Database Verification

'/var/www/reports/toolkit/dbfix.pl' is a handy script used to verify the 
database is in a healthy state. It will run ANALYZE TABLE, and REPAIR TABLE
as required. Should only be run when other processes have been stopped to
prevent the script from being unnecessarily blocked.

When the databases were created many years ago, the database engine MyISAM was
used. In retrospect this should have been InnoDB, and a migration to this 
engine should be considered.

A few modern tables have UTF-8 enabled, however all should be migrated to 
UTF-8. Although distribution names are currently ASCII, it is only a matter of
time before PAUSE can fully support Unicode.

### 1.7 ?

To Be Completed.....



