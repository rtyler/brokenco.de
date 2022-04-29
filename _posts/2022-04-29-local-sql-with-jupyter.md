---
layout: post
title: "Local SQL querying in Jupyter Notebooks"
tags:
- dataeng
- databricks
---

Designing, working with, or thinking about data consumes the vast majority of
my time these days, but almost all of that has been "in the cloud" rather than
locally. I recently watched [this talk about SQLite and
Go](https://www.youtube.com/watch?v=RqubKSF3wig) which served as a good
reminder that I have a pretty powerful computer at my fingertips, and that
perhaps not all my workloads require a big [Spark](https://spark.apache.org)
cluster in the sky. Shortly after watching that video I stumbled into a small
(200k rows) data set which I needed to run some queries against, and my first
attempt at auto-ingesting it into a [Delta table](https://delta.io) in
Databricks failed, so I decided to launch a local [Jupyter
notebook](https://jupyter.org/) and give it a try!

My originating data set was a comma-separated values file (CSV) so my first
intent was to just load it into SQLite using the `.mode csv` command in the
CLI, but I found that to be a bit restrictive. Notebooks have incredible
utility for incrementally working on data. Unfortunately Jupyter doesn't have a
native SQL interface, instead everything has to run through Python. Through my
work with [delta-rs](https://github.com/delta-io/delta-rs) I am somewhat
familar with [Pandas](https://pandas.pydata.org/) for processing data in
Python, so my first attempts where using the Pandas data frame API to munge
through my data.

```python
import pandas

df = pandas.read_csv('data/2021_05-2022_04.csv')
```

I could be dense, but I find SQL to be a pretty understandable tool in
comparison to data frames, so I needed to find some way to get the data into a
SQL interface. The solution that I ended up with was to create an in-memory
SQLite database and use Pandas to query it, which works _okay enough_ to where
I continued working and didn't bother thinking too much about how to optimize
the approach further:


```python
import sqlite3
import pandas

# Loading everything into a SQLite memory database because I hate data frames and SQL is nice
conn = sqlite3.connect(':memory:')
df = pandas.read_csv('data/2021_05-2022_04.csv')
r = df.to_sql('usage', conn, if_exists='replace', index=False)
# useful little helper
sql = lambda x: pandas.read_sql_query(x, conn)


# Show some sample data
sql('SELECT * FROM usage LIMIT 3')
```

The benefit of this approach is that I can create additional tables in the
SQLite database with static data sets, or other CSVs. Since I'm also just doing
some simple ad-hoc analysis, I can skip writing anything to disk and keep
things snappy in memory.

I created the little `sql` lambda to make the notebook a bit more
understandable, and to get out of exposing the cursor or database connection to
every single cell, meaning that most of my cells in the notebook are simply
just `sql('SELECT * FROM foo')` statments with some documentation surrounding
them.

Fairly simple, easy enough to play with data quickly on my local machine
without invoking all the infinite cosmic powers the cloud provides!
