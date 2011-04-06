# Purpose

Have you ever needed to ignore a database column in ActiveRecord? For example, when you
have a table with hundreds of millions of rows and you want to delete or rename a column
with no down time. In order to pull that off you need to ignore the column on master,
while you remove it on a slave. Once the column is deleted, you start replication to catch
up to master before promoting the slave to master. Without a way to ignore a column on 
master you will get error when replicating.

## Example

    class Person < ActiveRecord::Base
       attr_ignore :last_name, :first_name
    end
