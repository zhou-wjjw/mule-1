# General

Mule is a round-robin database tool (RRDtool) that can be used for applicative monitoring. Mule allows you to easily define families of metrics and to input data through a simple command line. Data can be retrieved from the Mule server using HTTP GET requests. Mule stores data according to user-defined retention settings, known as a *retention pair*.

It has the following features:

* You do not need to define metrics in advance, you can add new metrics at any time by using simple patterns.
* Mule can store multiple data sequences using different retention settings for the same metric.
* Metrics have a hierarchical name structure. Mule aggregates data from the child nodes into the parent node. When you analyze the data, you can drill-down from the parent node to view more specific data in the child nodes.
* Thresholds can be defined (similar to [Nagios](http://www.nagios.org/)) and alerts can be generated.
* Mule includes a RESTful interface which can be used to generate graphs and to monitor thresholds using tools such as [Nagios](http://www.nagios.org/).

# Definitions

* retention pair: `step:period`, for example, `1h:30d`
* metric - a (logical) name *without* any retention data, for example, `beer.stout.irish`
* event - a triple `name value timestamp`, input to the database
* sequence - list of slots, identified by a triple `<metric,step,period>`. These are managed by Mule.
* name - a triple `metric;step:period`, for example, `beer.stout;1h:30d`.
* factory - names (that is, a triple) that are used for the configuration.

# Usage

## Configuration format

The configuration uses one line per metric in the following format:

    <metric> <list-of-retention-pairs>

For example:

    beer.stout 60s:12h 1h:30d


A line can include multiple retention pairs and the same pattern can appear in multiple lines.

### Metric
A *metric* is defined as follows:

* It can be any Lua string.
* Every dot delimited prefix is also a metric, that is, `beer.stout.irish.dublin`, generates the following:
    * `beer`
    * `beer.stout`
    * `beer.stout.irish`
    * `beer.stout.irish.dublin`
* The most specific match for every metric is used to create the retention sequences for it.

#### Retention units
The following lists the retention units:

* `s` - sec
* `m` - min
* `h` - hour
* `d` - day
* `w` - week
* `m` - month (30 days)
* `y` - year (365 days)


#### Input Format
Each input line should be in the following format:

An *event*
    <metric> <value> <timestamp>

or a *command*

    .<command> ...

##### Event

    beer.stout.irish 20 74857843
This means that 20 orders of `beer.stout.irish` were recorded at the given timestamp, measured in seconds (also known as Unix time). The value (20 in this example) is added to the count of the metric for this particular bucket, derived from the timestamp and the *step* value.

Two more metric types are supported:

* Gauge - if an equal sign `=` precedes the value, then the value replaces the number rather than adding to it.
* High water mark - if `^` precedes the value, the maximal value is used.

For example:

    beer.stout.irish =32 74858041

##### Command
The following command runs garbage collection for any metric with the prefix `beer.stout` that wasn't updated after the provided timestamp.

    .gc beer.stout 7489826


### Commands


#### Command line interface

The following commands can be issue via the command line or in an input file. Recall that they should be preceded by a `.` (dot).
* `graph <metric> [<timestamp>]` - Retrieve all the sequences for which the given parameter is a prefix. `<metric>` can be an exact sequence name. `<timestamp>` can be used to limit the output to a range. `<timestamp>` can be a comma-separated array of timestamps. Additionally, `l` (latest) and `n` (now) can be used as well as simple arithmetic operations. For example, `<timestamp>` can be `l-10..l,n,n-100..l+50`.
* `key <metric>` - Retrieve all the metrics for which the given parameter is a prefix. `<metric>` can be an exact sequence name.
* `latest <metric-or-name>` - Retrieves the latest updated slot.
* `slot <metric-or-name> <timestamp>` - Retrieves the slots specified by the timestamp(s).
* `gc <metric> <timestamp> [<force>]` - Erase all metrics that weren't updated since the timestamp. You must pass `true` for `<force>` to modify the database.
* `reset <metric>` - Clear all slots in the metric.


### REST API

#### Graphs

##### Retrieve Graph Data
Use a GET request to retrieve graph data, in the following format:

    http://muleserver/graph/<metric-or-name>?<timestamps>|<level>|<alerts>

* `<metric-or-name>` is a `metric` or a `name`, that is, it includes retention data. If `metric` is used, all the graphs for the metric will be returned, that is, the graphs for all the names for which the metric is a prefix.
* Available query string parameters:
  * `timestamps` - The graph data is restricted to the given timestamps. Timestamps can be a comma-separated list of seconds or simple arithmetic expressions using the predefined variables `now` (or `n`) and `latest` (or `l`), for example, `l-10s`, `now-20d`.
  * `alerts` - If `alerts` is set to true, the alerts status is added to the names for which alerts are defined.
  * `level` - The `level` parameter is optional and sets the number of sub key levels to retrieve. Each dot represents one level. The default level is 1. If no retention pair is provided, all the sub keys and their retention pairs are returned. If a retention pair is provided, only the sub keys with the same retention pairs are returned.
  * `filter` - The `filter` parameter can be set to `now` or `latest`. If it is set to `now`, only the results in the time period of `now-period`..`now` are returned. Similarly, `latest` filters according to the latest time at which the sequence was updated.

The following shows an output example where each triple is `<value,hits,timestamp>`

```json
mule_graph({
  "version": 3,
  "data": {
    "wine.pinotage.south_africa;1d:3y": [[4,3,1293753600]]
    "wine.pinotage;1d:3y": [[7,5,1293753600]],
    "wine.pinotage;1h:30d": [[2,1,1293832800],[5,4,1293836400]],
    "wine.pinotage;5m:2d": [[2,1,1293836100],[2,1,1293836400],[3,1,1293837000]],
    "alerts": {"wine.pinotage;1h:30d": [34,100,800,900,86400,172800,0,"stale"]}
    }
})
```

You can use multiple metrics or names by separating them with `/`, for example:

    http://muleserver/graph/<metric>


##### Update Graph
To update graph data, use a POST request to:

    http://muleserver/graph

or (for compatibility with older versions)

    http://muleserver/update

The contents of the file are lines in the format described in the [Input Format](#input-format) section:

    <metric> <value> <timestamp>

##### Reset Graph Data
Use a DELETE request to erase a graph, or to set its data to 0. You can use only one of the following parameters in each request.

* `force` - Pass `force=true` to remove the graph.
* `timestamp` - All the entries before and including the timestamp are set to 0. **Note**: The entries are not deleted.

Optional parameters:
* `level` - The depth of the sub keys to reset. The default value is 0.


#### Key
The metrics and names create a hierarchy that can be retrieved by sending a GET request to:

    http://muleserver/key/<metric>?<level>

* `metric` - Returns all the names for which `metric` is a prefix.
* `level` - The `level` parameter is optional and sets the number of sub key levels to retrieve. Each dot represents one level. The default level is 1. If no retention pair is provided, all the sub keys and their retention pairs are returned. If a retention pair is provided, only the sub keys with the same retention pairs are returned.

Example output: (`level=1`)

```json
mule_keys({
  "version": 3,
  "data": {
    "beer.ale;1d:3y": { "children": true },
    "beer.ale.pale;1h:30d": { },
    "beer.ale.pale;1d:3y": { },
    "beer.ale.pale;5m:2d": { },
    "beer.ale;1h:30d": { "children": true },
    "beer.ale;5m:2d": { "children": true }
  }
})
```

You can use multiple metrics or names by separating them with `/`, for example:

    http://muleserver/key/<metric_1>/<metric_2>/.../<metric_n>

#### Access to Specific Slots
The data for specific slots can be retrieved by sending a GET request to:

    http://muleserver/slot/<metric-or-name>?<timestamps>

The timestamps (as described in the [Graphs](#graphs) section) are not optional. Multiple values can be passed as a list.

Retrieving only the latest updated slot is supported using the following:

    http://muleserver/latest/<metric-or-name>

You can use use multiple metrics in both of these requests if you separate the metrics with `/`.

#### Alerts

##### Checking Alerts
Alerts are designed to be compatible with [Nagios](http://www.nagios.org/).

When an alert is defined, you can check its state using a GET request:

     http://muleserver/alert/<name>

If you do not provide a `name`, all the alerts are retrieved. The return value is:

```json
{
  "version": 3,
  "data": {
    "<name>": [<critical_low>,<warning_low>,<warning_high>,<critical_high>,<period>,<stale>,<value>,<state>,<check_timestamp>,<msg>]
  }
}
```
The parameters are defined as follows:

* `critical_low, warning_low, warning_high, critical_high` - The threshold value of the alerts.
* `period` - The graph period.
* `stale` - If the graph is not updated during a certain time period (in seconds), the state changes to `stale`. **Note**: Updating the graph with a 0 value is considered an update.
* `value` - The graph's value at the time of the check.
* `state` - The state of the alert: `NORMAL, CRITICAL_LOW, WARNING_LOW, WARNING_HIGH, CRITICAL_HIGH, stale`
* `check_timestamp` - The time of the check.
* `msg` - An optional text message.


##### Defining Alerts
TODO

##### Stop
You can stop the http daemon with the following command. This is not intended to be secure and provides basic protection from accidental termination.

    http://muleserver/stop?token=<stop_password>

##### Backup
You can create a backup of the database with the following command. This command returns the path of the backup database.

    http://muleserver/backup


#### Configuration
To update Mule's configuration POST a configuration file to:

    http://muleserver/config
For example:

    curl -vd @<(echo "wine. 1d:3y") http://muleserver/config

To read (export) the configuration use GET:

    http://muleserver/config

#### Key-value store
Mule provides a simple interface for storing arbitrary values. Using the relevant HTTP verbs:
* To retrieve the value associated with a key use a GET request to `http://muleserver/kvs/<key>`
* To set (or update) the value associated with a key use a PUT request to `http://muleserver/kvs/<key>` where the body is the value
* To remove a key and its value use a DELETE request to `http://muleserver/kvs/<key>`.

### Processing Speed
During testing on a c3.2xlarge AWS instance with SSD in RAID 0, Mule peaked at approximately 200 files per second, with an average file size of 3k, and an average number of lines of 42. The nginx based frontend can handle writes of approximately 300 files per second.

## Installation

You need to install Lua, luarocks, and the Lightning Memory-Mapped Database.

### Lua and luarocks

* Install >=Lua 5.1 (caveat - Lua 5.3 was only lightly tested) using your standard package manager. You can also install Lua from the [Lua download page](http://www.lua.org/download.html).
* Install luarocks using the package manager or from the [luarocks download page](http://luarocks.org/en/Download).
* Install additional rocks - copas, lpack, luaposix, StackTracePlus (optional)

### Lightning Memory-Mapped Database (LMDB)
Assuming `/home/user/projects` is the root of your development projects, run the following commands to install LMDB:

<pre>
git clone https://github.com/LMDB/lmdb # This will create a directory ./mdb/libraries/liblmdb
cd ./lmdb/libraries/liblmdb
make
cd /home/user/projects
git clone git://github.com/shmul/lightningdbm.git
cd ./lightningmdb
cp ../lmdb/libraries/liblmdb/liblmdb.{a,so} .
make
</pre>

copy `lightningmdb.so` to your mule directory


### Deployment model

#### Internal HTTP daemon
Mule ships with a simple HTTP daemon and supports:

* A REST/JSONP interface
* (naive) static files serving

Mule is assumed to be an internal application, therefore, no attempt was made to make the daemon full featured. It is recommended to place an industry level HTTP server/proxy in front of it.

To run Mule as an HTTP daemon run the following command:

    lua mule.lua -d <db-path> -t <bind-address>:<port> [-x <stop-password>] [-l <log-path>] [-R <static-files-root-path>]

For example,

    lua mule.lua -d mule.kct -t localhost:3012 -x stopme

#### (through) Nginx
The recommended mule setup, is proxying the traffic through Nginx. In this setup, mule runs as a backend HTTP server (as explained above) but the traffic is proxied through Nginx. This setup enables:
- Serving static files (the user interface, see below) directly via Nginx
- Async processing of input files - a Lua script, running inside Nginx, saves the submitted input into a local directory (which serves as a queue). Mule then periodically scans the directory, and processes the files. This mode of operation adds to the robustness of the system, as Mule can be restarted and updated without losing data.
- Queries are proxied through Ngins directly to mule.


Sample nginx configuration is provided in `nginx.mule.conf.sample`. In this sample the URL routes are:
- For accessing the mule API, including file submission `http://muleserver/mule/api/`.
- For accessing the *muleview* application `http://muleserver/mule/`.
- For accessing the *scent* application `http://muleserver/scent/`.


### User interface

Two different web applications are provided with Mule, *muelview* provides a rich interface, where as *scent* is oriented towards dashboard view.

#### Muleview

Mule ships with a simple [Ext JS](http://www.sencha.com/products/extjs/)-based client web-application written in [CoffeeScript](http://coffeescript.org/) called "Muleview".
Muleview can display graphs of all Mule's current data.

##### Requirements
Muleview requires [CoffeeScript](http://coffeescript.org/) for compilation and [Sencha Cmd](http://www.sencha.com/products/sencha-cmd/download) for creating a production-ready build, that is, a single-file minified version of the entire framework and source (all_classes.js) and all the necessary static resources.

##### Build
To build a production-ready folder:

1. Install [CoffeeScript](http://coffeescript.org/#installation) and make sure the `coffee` command is available.
1. Install [Sencha Cmd](http://www.sencha.com/products/sencha-cmd/download). This requires additional 3rd party components such as Java and Compass.
1. Change directory to the muleview directory (`cd muleview`) and run `sencha app build`.
1. The output should be generated under `muleview/build/Muleview/production`.

##### Built-in Serving with Mule
You can use Mule as a web-server for Muleview. To use Mule as a web-server, run Mule with the static files root path parameter (`-R muleview/build/Muleview/production`).

A typical configuration is:

    lua mule.lua -d db/my_great_db_cdb -T myserver:80 -R muleview/build/Muleview/production

It is recommended to run Mule and Muleview on different servers. If they are on different servers, before you compile and build Muleview, you must enter Mule's URL in `muleview/coffee/app/Settings.coffee`.

#### Scent

TODO

### Development environment

#### Vagrant Box
Mule ships with a [Vagrant](http://vagrantup.com) server for development.
To set up the server:

1. Install vagrant
1. `cd vagrant`
1. `vagrant up`
1. `vagrant ssh`
1. `/vagrant/setup.sh`
This sets up a server with all the relevant development dependencies and an Nginx server that is accessible from the your host at localhost:3000/mule/

#### Docker
Mule ships with a couple of Docker files used to automate the unit tests across multiple Lua versions. Additionally a Docker file with a mule+nginx setup is provided.

# License

Mule is distributed under the Apache License, version 2.0.

## Apache License

(c) Copyright IBM Corp. 2010, 2015
Authors: Shmulik Regev, Dan Carmon, Dov Murik

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Luarocks
Licensed under the [luarocks license](http://luarocks.org/en/License)

## LMDB
Licensed under the [OpenLDAP Public License](http://www.openldap.org/software/release/license.html).

## lightningdbm
Licensed under the MIT license (https://github.com/shmul/lightningdbm).

## Lunitx
Lunitx is licensed under the terms of the MIT license. [Lunitx github](https://github.com/dcurrie/lunit/)

## Luasocket
Licensed under the MIT license (https://github.com/diegonehab/luasocket)

## luaposix
Licensed under the MIT license (https://github.com/luaposix/luaposix)

## Copas
Copas of the Kepler project is used and is distributed under [this license](http://keplerproject.github.com/copas/license.html). Copyright (c) 2005-2010 Kepler Project.

## lpack
[lpack](http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lpack) is used.
