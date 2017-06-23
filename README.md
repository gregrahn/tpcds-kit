# tpcds-kit

The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).

This version is based on v2.5 and has been modified to:

* Allow compilation under macOS (commit [2ec45c5](https://github.com/gregrahn/tpcds-kit/commit/2ec45c5ed97cc860819ee630770231eac738097c))
* Address obvious query template bugs like 
  * https://github.com/gregrahn/tpcds-kit/issues/30
  * https://github.com/gregrahn/tpcds-kit/issues/31
  * https://github.com/gregrahn/tpcds-kit/issues/33
  * https://github.com/gregrahn/tpcds-kit/issues/35

## Setup

### Linux

Make sure the required development tools are installed:

Ubuntu: 
```
sudo apt-get install gcc make flex bison byacc git
```

CentOS/RHEL: 
```
sudo yum install gcc make flex bison byacc git
```

Then run the following commands to clone the repo and build the tools:

```
git clone https://github.com/gregrahn/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX
```

### macOS

Make sure the required development tools are installed:

```
xcode-select --install
```
 
Then run the following commands to clone the repo and build the tools:

```
git clone https://github.com/gregrahn/tpcds-kit.git
cd tpcds-kit/tools
make OS=MACOS
```

## Using the TPC-DS tools

### Data generation

Data generation is done via `dsdgen`.  See `dsdgen --help` for all options.  If you do not run `dsdgen` from the `tools/` directory then you will need to use the option `-DISTRIBUTIONS /.../tpcds-kit/tools/tpcds.idx`.

### Query generation

Query generation is done via `dsqgen`.   See `dsqgen --help` for all options.

The following command can be used to generate all 99 queries in numerical order (`-QUALIFY`) for the 10TB scale factor (`-SCALE`) using the Netezza dialect template (`-DIALECT`) with the output going to `/tmp/query_0.sql` (`-OUTPUT_DIR`).

```
dsqgen \
-DIRECTORY ../query_templates \
-INPUT ../query_templates/templates.lst \
-VERBOSE Y \
-QUALIFY Y \
-SCALE 10000 \
-DIALECT netezza \
-OUTPUT_DIR /tmp
```
