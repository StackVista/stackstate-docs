---
description: StackState Self-hosted v5.1.x 
---

# MySQL

## Overview

Get realtime metrics from MySQL databases, including:

* Query throughput
* Query performance \(average query run time, slow queries, etc\)
* Connections \(currently open connections, aborted connections, errors, etc\)
* InnoDB \(buffer pool metrics, etc\)

You can also invent your own metrics using custom SQL queries.

MySQL is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Setup

### Installation

The MySQL check is included in the [Agent V2 StackPack](agent.md). No additional installation is needed on your MySQL server.

### Configuration

Edit the `mysql.d/conf.yaml` file, in the `conf.d/` folder at the root of your Agent's configuration directory to start collecting your MySQL metrics and logs.

#### Prepare MySQL

On each MySQL server, create a database user for the Agent:

```text
mysql> CREATE USER 'stackstate'@'localhost' IDENTIFIED BY '<UNIQUEPASSWORD>';
Query OK, 0 rows affected (0.00 sec)
```

For mySQL 8.0+ create the `stackstate` user with the native password hashing method:

```text
mysql> CREATE USER 'stackstate'@'localhost' IDENTIFIED WITH mysql_native_password by '<UNIQUEPASSWORD>';
Query OK, 0 rows affected (0.00 sec)
```

**Note**: `@'localhost'` is only for local connections - use the hostname/IP of your Agent for remote connections. For more information, see the MySQL documentation.

Verify the user was created successfully using the following commands - replace `<UNIQUEPASSWORD>` with the password you created above:

```text
mysql -u stackstate --password=<UNIQUEPASSWORD> -e "show status" | \
grep Uptime && echo -e "\033[0;32mMySQL user - OK\033[0m" || \
echo -e "\033[0;31mCannot connect to MySQL\033[0m"
```

```text
mysql -u stackstate --password=<UNIQUEPASSWORD> -e "show slave status" && \
echo -e "\033[0;32mMySQL grant - OK\033[0m" || \
echo -e "\033[0;31mMissing REPLICATION CLIENT grant\033[0m"
```

The Agent needs a few privileges to collect metrics. Grant the user the following limited privileges ONLY:

```text
mysql> GRANT REPLICATION CLIENT ON *.* TO 'stackstate'@'localhost' WITH MAX_USER_CONNECTIONS 5;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> GRANT PROCESS ON *.* TO 'stackstate'@'localhost';
Query OK, 0 rows affected (0.00 sec)
```

For mySQL 8.0+ set `max_user_connections` with:

```text
mysql> ALTER USER 'stackstate'@'localhost' WITH MAX_USER_CONNECTIONS 5;
Query OK, 0 rows affected (0.00 sec)
```

If enabled, metrics can be collected from the `performance_schema` database by granting an additional privilege:

```text
mysql> show databases like 'performance_schema';
+-------------------------------+
| Database (performance_schema) |
+-------------------------------+
| performance_schema            |
+-------------------------------+
1 row in set (0.00 sec)

mysql> GRANT SELECT ON performance_schema.* TO 'stackstate'@'localhost';
Query OK, 0 rows affected (0.00 sec)
```

#### Metric Collection

* Add this configuration block to your `mysql.d/conf.yaml` to collect your MySQL metrics:

  ```text
  init_config:

  instances:
    - server: 127.0.0.1
      user: stackstate
      pass: '<YOUR_CHOSEN_PASSWORD>' # from the CREATE USER step earlier
      port: <YOUR_MYSQL_PORT> # e.g. 3306
      options:
          replication: 0
          galera_cluster: 1
          extra_status_metrics: true
          extra_innodb_metrics: true
          extra_performance_metrics: true
          schema_size_metrics: false
          disable_innodb_metrics: false
  ```

**Note**: Wrap your password in single quotes in case a special character is present.

To collect `extra_performance_metrics`, your MySQL server must have `performance_schema` enabled - otherwise set `extra_performance_metrics` to `false`. For more information on `performance_schema`, see the MySQL documentation.

Note that the `stackstate` user should be set up in the MySQL integration configuration as `host: 127.0.0.1` instead of `localhost`. Alternatively, you may also use `sock`.

Restart the Agent to start sending MySQL metrics to StackState.

#### Log Collection

1. By default, MySQL logs everything in `/var/log/syslog` which requires root access to read. To make the logs more accessible, follow these steps:
   * Edit `/etc/mysql/conf.d/mysqld_safe_syslog.cnf` and remove or comment the lines.
   * Edit `/etc/mysql/my.cnf` and add following lines to enable general, error, and slow query logs:

     ```text
     [mysqld_safe]
     log_error=/var/log/mysql/mysql_error.log
     [mysqld]
     general_log = on
     general_log_file = /var/log/mysql/mysql.log
     log_error=/var/log/mysql/mysql_error.log
     slow_query_log = on
     slow_query_log_file = /var/log/mysql/mysql-slow.log
     long_query_time = 2
     ```

   * Save the file and restart MySQL using following commands: `service mysql restart`
   * Make sure the Agent has read access on the `/var/log/mysql` directory and all of the files within. Double-check your logrotate configuration to make sure those files are taken into account and that the permissions are correctly set there as well.
   * In `/etc/logrotate.d/mysql-server` there should be something similar to:

     ```text
     /var/log/mysql.log /var/log/mysql/mysql.log /var/log/mysql/mysql-slow.log {
            daily
            rotate 7
            missingok
            create 644 mysql adm
            Compress
     }
     ```
2. Collecting logs is disabled by default in StackState Agent V2, so you need to enable it in `stackstate.yaml`:

   ```text
    logs_enabled: true
   ```

3. Add this configuration block to your `mysql.d/conf.yaml` file to start collecting your MySQL logs:

   ```text
    logs:
        - type: file
          path: /var/log/mysql/mysql_error.log
          source: mysql
          sourcecategory: database
          service: myapplication

        - type: file
          path: /var/log/mysql/mysql-slow.log
          source: mysql
          sourcecategory: database
          service: myapplication

        - type: file
          path: /var/log/mysql/mysql.log
          source: mysql
          sourcecategory: database
          service: myapplication
          # For multiline logs, if they start by the date with the format yyyy-mm-dd uncomment the following processing rule
          # log_processing_rules:
          #   - type: multi_line
          #     name: new_log_start_with_date
          #     pattern: \d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])
   ```

   See our sample `mysql.yaml` for all available configuration options, including those for custom metrics.

4. Restart the Agent.

### Validation

Run the Agent's `status` subcommand and look for `mysql` under the Checks section.

## Data Collected

### Metrics

See `metadata.csv` for a list of metrics provided by this integration.

The check does not collect all metrics by default. Set the following boolean configuration options to `true` to enable the respective metrics:

`extra_status_metrics` adds the following metrics:

| Metric name | Metric type |
| :--- | :--- |
| mysql.binlog.cache\_disk\_use | GAUGE |
| mysql.binlog.cache\_use | GAUGE |
| mysql.performance.handler\_commit | RATE |
| mysql.performance.handler\_delete | RATE |
| mysql.performance.handler\_prepare | RATE |
| mysql.performance.handler\_read\_first | RATE |
| mysql.performance.handler\_read\_key | RATE |
| mysql.performance.handler\_read\_next | RATE |
| mysql.performance.handler\_read\_prev | RATE |
| mysql.performance.handler\_read\_rnd | RATE |
| mysql.performance.handler\_read\_rnd\_next | RATE |
| mysql.performance.handler\_rollback | RATE |
| mysql.performance.handler\_update | RATE |
| mysql.performance.handler\_write | RATE |
| mysql.performance.opened\_tables | RATE |
| mysql.performance.qcache\_total\_blocks | GAUGE |
| mysql.performance.qcache\_free\_blocks | GAUGE |
| mysql.performance.qcache\_free\_memory | GAUGE |
| mysql.performance.qcache\_not\_cached | RATE |
| mysql.performance.qcache\_queries\_in\_cache | GAUGE |
| mysql.performance.select\_full\_join | RATE |
| mysql.performance.select\_full\_range\_join | RATE |
| mysql.performance.select\_range | RATE |
| mysql.performance.select\_range\_check | RATE |
| mysql.performance.select\_scan | RATE |
| mysql.performance.sort\_merge\_passes | RATE |
| mysql.performance.sort\_range | RATE |
| mysql.performance.sort\_rows | RATE |
| mysql.performance.sort\_scan | RATE |
| mysql.performance.table\_locks\_immediate | GAUGE |
| mysql.performance.table\_locks\_immediate.rate | RATE |
| mysql.performance.threads\_cached | GAUGE |
| mysql.performance.threads\_created | MONOTONIC |

`extra_innodb_metrics` adds the following metrics:

| Metric name | Metric type |
| :--- | :--- |
| mysql.innodb.active\_transactions | GAUGE |
| mysql.innodb.buffer\_pool\_data | GAUGE |
| mysql.innodb.buffer\_pool\_pages\_data | GAUGE |
| mysql.innodb.buffer\_pool\_pages\_dirty | GAUGE |
| mysql.innodb.buffer\_pool\_pages\_flushed | RATE |
| mysql.innodb.buffer\_pool\_pages\_free | GAUGE |
| mysql.innodb.buffer\_pool\_pages\_total | GAUGE |
| mysql.innodb.buffer\_pool\_read\_ahead | RATE |
| mysql.innodb.buffer\_pool\_read\_ahead\_evicted | RATE |
| mysql.innodb.buffer\_pool\_read\_ahead\_rnd | GAUGE |
| mysql.innodb.buffer\_pool\_wait\_free | MONOTONIC |
| mysql.innodb.buffer\_pool\_write\_requests | RATE |
| mysql.innodb.checkpoint\_age | GAUGE |
| mysql.innodb.current\_transactions | GAUGE |
| mysql.innodb.data\_fsyncs | RATE |
| mysql.innodb.data\_pending\_fsyncs | GAUGE |
| mysql.innodb.data\_pending\_reads | GAUGE |
| mysql.innodb.data\_pending\_writes | GAUGE |
| mysql.innodb.data\_read | RATE |
| mysql.innodb.data\_written | RATE |
| mysql.innodb.dblwr\_pages\_written | RATE |
| mysql.innodb.dblwr\_writes | RATE |
| mysql.innodb.hash\_index\_cells\_total | GAUGE |
| mysql.innodb.hash\_index\_cells\_used | GAUGE |
| mysql.innodb.history\_list\_length | GAUGE |
| mysql.innodb.ibuf\_free\_list | GAUGE |
| mysql.innodb.ibuf\_merged | RATE |
| mysql.innodb.ibuf\_merged\_delete\_marks | RATE |
| mysql.innodb.ibuf\_merged\_deletes | RATE |
| mysql.innodb.ibuf\_merged\_inserts | RATE |
| mysql.innodb.ibuf\_merges | RATE |
| mysql.innodb.ibuf\_segment\_size | GAUGE |
| mysql.innodb.ibuf\_size | GAUGE |
| mysql.innodb.lock\_structs | RATE |
| mysql.innodb.locked\_tables | GAUGE |
| mysql.innodb.locked\_transactions | GAUGE |
| mysql.innodb.log\_waits | RATE |
| mysql.innodb.log\_write\_requests | RATE |
| mysql.innodb.log\_writes | RATE |
| mysql.innodb.lsn\_current | RATE |
| mysql.innodb.lsn\_flushed | RATE |
| mysql.innodb.lsn\_last\_checkpoint | RATE |
| mysql.innodb.mem\_adaptive\_hash | GAUGE |
| mysql.innodb.mem\_additional\_pool | GAUGE |
| mysql.innodb.mem\_dictionary | GAUGE |
| mysql.innodb.mem\_file\_system | GAUGE |
| mysql.innodb.mem\_lock\_system | GAUGE |
| mysql.innodb.mem\_page\_hash | GAUGE |
| mysql.innodb.mem\_recovery\_system | GAUGE |
| mysql.innodb.mem\_thread\_hash | GAUGE |
| mysql.innodb.mem\_total | GAUGE |
| mysql.innodb.os\_file\_fsyncs | RATE |
| mysql.innodb.os\_file\_reads | RATE |
| mysql.innodb.os\_file\_writes | RATE |
| mysql.innodb.os\_log\_pending\_fsyncs | GAUGE |
| mysql.innodb.os\_log\_pending\_writes | GAUGE |
| mysql.innodb.os\_log\_written | RATE |
| mysql.innodb.pages\_created | RATE |
| mysql.innodb.pages\_read | RATE |
| mysql.innodb.pages\_written | RATE |
| mysql.innodb.pending\_aio\_log\_ios | GAUGE |
| mysql.innodb.pending\_aio\_sync\_ios | GAUGE |
| mysql.innodb.pending\_buffer\_pool\_flushes | GAUGE |
| mysql.innodb.pending\_checkpoint\_writes | GAUGE |
| mysql.innodb.pending\_ibuf\_aio\_reads | GAUGE |
| mysql.innodb.pending\_log\_flushes | GAUGE |
| mysql.innodb.pending\_log\_writes | GAUGE |
| mysql.innodb.pending\_normal\_aio\_reads | GAUGE |
| mysql.innodb.pending\_normal\_aio\_writes | GAUGE |
| mysql.innodb.queries\_inside | GAUGE |
| mysql.innodb.queries\_queued | GAUGE |
| mysql.innodb.read\_views | GAUGE |
| mysql.innodb.rows\_deleted | RATE |
| mysql.innodb.rows\_inserted | RATE |
| mysql.innodb.rows\_read | RATE |
| mysql.innodb.rows\_updated | RATE |
| mysql.innodb.s\_lock\_os\_waits | RATE |
| mysql.innodb.s\_lock\_spin\_rounds | RATE |
| mysql.innodb.s\_lock\_spin\_waits | RATE |
| mysql.innodb.semaphore\_wait\_time | GAUGE |
| mysql.innodb.semaphore\_waits | GAUGE |
| mysql.innodb.tables\_in\_use | GAUGE |
| mysql.innodb.x\_lock\_os\_waits | RATE |
| mysql.innodb.x\_lock\_spin\_rounds | RATE |
| mysql.innodb.x\_lock\_spin\_waits | RATE |

`extra_performance_metrics` adds the following metrics:

| Metric name | Metric type |
| :--- | :--- |
| mysql.performance.query\_run\_time.avg | GAUGE |
| mysql.performance.digest\_95th\_percentile.avg\_us | GAUGE |

`schema_size_metrics` adds the following metric:

| Metric name | Metric type |
| :--- | :--- |
| mysql.info.schema.size | GAUGE |

### Events

The MySQL check does not include any events.

### Service Checks

`mysql.replication.slave_running`: Returns CRITICAL for a slave that's not running, otherwise OK.

`mysql.can_connect`: Returns CRITICAL if the Agent can't connect to MySQL to collect metrics, otherwise OK.

