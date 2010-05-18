# Introduction

I often find myself wanting to be able to [diff][1] the state of a database before and after some transformation.  I created this utility to make it easy to export mysql data in a format that I can diff.

## Installation

This assumes that you have a bin folder in your home directory and that that bin folder is in your PATH.

    $ cd /path/to/cloned/code
    $ git clone git://github.com/chrisroos/mysql-export.git
    $ ln -s /path/to/cloned/code/mysql-export/mysql-export.sh ~/bin/mysql-export

## Usage

This will create a timestamped directory containing a backup of each of your tables from the named mysql database.  Each table is backed up to a file named after the table.

    $ mysql-export <name-of-database>

## Example

    $ # Create a temporary directory to play around in
    $ mkdir ~/tmp-mysql-export-test
    $ cd ~/tmp-mysql-export-test

    $ # Create a database with some data
    $ mysql -uroot -e"CREATE DATABASE mysql_export_test"
    $ mysql mysql_export_test -uroot -e"CREATE TABLE people (id INTEGER AUTO_INCREMENT, name VARCHAR(30), age INTEGER, PRIMARY KEY (id))"
    $ mysql mysql_export_test -uroot -e"INSERT INTO people (name, age) VALUES ('the king', 100)"
    $ mysql mysql_export_test -uroot -e"INSERT INTO people (name, age) VALUES ('the queen', 90)"

    $ # Export the data
    $ mysql-export mysql_export_test
    Writing backups to mysql_export.mysql_export_test.20100518142447

    $ # Change the data
    $ mysql mysql_export_test -uroot -e"UPDATE people SET age = age + 1"

    $ # Export the data
    $ mysql-export mysql_export_test
    Writing backups to mysql_export.mysql_export_test.20100518142509

    $ # Show the before/after difference
    $ diff mysql_export.mysql_export_test.20100518142*
    diff mysql_export.mysql_export_test.20100518142447/people.txt mysql_export.mysql_export_test.20100518142509/people.txt
    4c4
    <  age: 100
    ---
    >  age: 101
    8c8
    <  age: 90
    ---
    >  age: 91

## Limitations

* There's a good chance it'll only work on a Mac (and possibly only my Mac)
* It assumes you can connect to the database with a user named root with no password

[1]: http://en.wikipedia.org/wiki/Diff